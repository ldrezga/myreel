$(document).on('click', '.js-add-to-friends', function(){
	if($(this).hasClass('added')){
		$.ajax({
			type: 'DELETE',
			url: '/remove-from-friends',
			data: {
				'fbid': $(this).attr('data-slug'),
				'name': $(this).attr('data-name')
			},
			dataType: 'JSON',
		});
		$(this).removeClass('added');
	}
	else{
		$.ajax({
			type: 'POST',
			url: '/add-to-friends',
			data: {
				'fbid': $(this).attr('data-slug'),
				'name': $(this).attr('data-name')
			},
			dataType: 'JSON',
		});
		$(this).addClass('added');
	}
});