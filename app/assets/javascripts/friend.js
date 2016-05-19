$(document).on('click', '.js-remove-from-friends', function(){
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
		$(this).parent().css('display','none')
	}
});