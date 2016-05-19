// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('click', '.js-update-watchlist', function(){
	if($(this).hasClass('added')){
		$.ajax({
			type: 'DELETE',
			url: '/remove-from-watchlist',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).removeClass('added');

		if($(this).hasClass('in-watchlist')){
			$(this).parent().parent().css('display','none')
		}
	}
	else{
		$.ajax({
			type: 'POST',
			url: '/add-to-watchlist',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).addClass('added');
	}
});

$(document).on('click', '.js-update-watched', function(){
	if($(this).hasClass('added')){
		$.ajax({
			type: 'DELETE',
			url: '/remove-from-watched',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).removeClass('added');
		$(this).parent().parent().css('display','none')
	}
	else{
		$.ajax({
			type: 'POST',
			url: '/add-to-watched',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).addClass('added');
		$(this).parent().parent().css('display','none')
	}
});

$(document).on('click', '.js-update-watched-single', function(){
	if($(this).hasClass('added')){
		$.ajax({
			type: 'DELETE',
			url: '/remove-from-watched',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).removeClass('added');
	}
	else{
		$.ajax({
			type: 'POST',
			url: '/add-to-watched',
			data: {'slug': $(this).attr('data-slug')},
			dataType: 'JSON',
		});
		$(this).addClass('added');
	}
});

$(document).on('click', '.animation', function(){
	$('.do-animate').attr("class", "do-animate animate");
	$('#sign_in').text("Setting up your account");
});