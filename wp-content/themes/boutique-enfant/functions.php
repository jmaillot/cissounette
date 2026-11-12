<?php
/**
 * Fonctions du thème enfant Boutique Artisanale.
 * Chargement du CSS parent + personalisations légères.
 */
add_action( 'wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'storefront-parent',
        get_template_directory_uri() . '/style.css'
    );
    wp_enqueue_style(
        'boutique-enfant',
        get_stylesheet_uri(),
        array( 'storefront-parent' ),
        wp_get_theme()->get( 'Version' )
    );
}, 20 );

/* Support des logos personnalisés (Apparence > Personnaliser) */
add_theme_support( 'custom-logo', array(
    'height'      => 160,
    'width'       => 400,
    'flex-height' => true,
    'flex-width'  => true,
) );
