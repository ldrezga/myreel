// count = 0
// $(document).on('click', '.inactive', function(){
// 	$(this).addClass('selected');
// 	var genre = $(this).data('genre');
// 	$(this).removeClass('inactive');

// 	if (count==0) {
// 		countere = 0;
// 		count++;	
// 	} else {
// 		var countere = $('.movies__single-movie').not('.' + genre + '').data('count');
// 	};
// 	console.log(countere)
	
// 	$('.movies__single-movie').not('.' + genre + '').addClass('hidden-' + genre + '').attr('data-count',countere+1).hide()
// });

// $(document).on('click', '.selected', function(){
// 	$(this).removeClass('selected');
// 	$(this).addClass('inactive');
// 	var genre = $(this).data('genre')

// 	if ($('.movies__single-movie').hasClass('hidden-'+ genre + '')) {
// 		var countere = $('.hidden-'+ genre + '').data('count');
// 		console.log(countere)
// 		$('.hidden-'+ genre + '').attr('data-count',countere-1)
// 		if ($('.hidden-'+ genre + '').data('count') == 0) {
// 			$('.hidden-'+ genre + '').show()
// 		};
// 		$('.movies__single-movie').removeClass('hidden-'+ genre + '');
// 	};
// });

$(document).on('click', '.inactive', function(){
	$(this).addClass('selected');
	var genre = $(this).data('genre');
	$(this).removeClass('inactive');
	
	$('.movies__single-movie').not('.' + genre + '').addClass('hidden-' + genre + '').hide()
});

$(document).on('click', '.selected', function(){
	$(this).removeClass('selected');
	$(this).addClass('inactive');
	var genre = $(this).data('genre')

	$('.movies__single-movie').filter('.hidden-'+ genre + '').show()	
});