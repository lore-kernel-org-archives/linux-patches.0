Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A608E20125A
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 21:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719956534; cv=none; b=V6lJuI88D5QcUku0LFiq46sJIqqRxMPTP6nVBYdHJ1YC7KQeoaG60NI4jAebgHRRTiU5xmh0MQLoICBsglcfyVv2lczxvR2q1TRJ4Vq5YvZio3C4oCXwVwTgPrlKIeMYLrEo48dU7RhVtjLemoQCfZpt2/Wttf2MY8FYk5ujTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719956534; c=relaxed/simple;
	bh=0L7pcPBtAXPj0S/S+3MgLSoRSkxPBc3fu178Utq2xHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJoyNljjSZ/y6s9T0TBrej6z0JUo321Qb/0anJlyHxtMm1vagt+KezQBNLcd9bM7xs5FzWtps/7mnSmvJQLhkVAza8ZvkgAKpLdP1NP6+++ZNjNPpTOdfu6+abldnOrqOobxr9elOoOZd/ThI/urqg3A4DTP+tjug0ylEerdm+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWMYfwCp; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWMYfwCp"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e036eabc97dso3502632276.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 14:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719956531; x=1720561331; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gJQj9aBGbbKul4hCpDKi82UeY7RwXMGhGVaVDyW0wOk=;
        b=TWMYfwCpUCuskMTC2Wy/73CRlf7Bx7GHRwQlJAMMDrxyPpNp/TWFJbRRg805BGPwpL
         tY6/GwXyHLdWQ85T/4nM9l6eHzuvaoEuj/4PZ5ZnksrgXgAQw0bF4A8QVbz0RJaDj7As
         9gm750oxoVC/ookETjrsU1rjlnuAIv481nACe5kUsp16hbkLR3Hw5r9UrWyrvae+1QQt
         QEtOztNHESGBymCa7ALTYVMgyhc3raBVYIfqgv8tilBOgS0DzalnniJLWjfxVCjY7iUe
         x9Th/Abp4SkHcw/jJa2mdmCOjRyC9OYjQ1wFf7gwr5G6UyS8JfNRf25ADxzAqN91QDbF
         8XUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719956531; x=1720561331;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJQj9aBGbbKul4hCpDKi82UeY7RwXMGhGVaVDyW0wOk=;
        b=qR8FwoAUZmU+D+oa8Su0Bji3crS8R17OeRoJYjfWsrd2GTpeQfcS1N/W/bBNAAHjQX
         oUG8oIN44HjuLsvRKtUP4rhrLseMXfMxr6zxlntV1GjzLLAFNz6j16r83NKxL2dMwokf
         0R1AdGYQShs8qH8L7DEntJKfwAbvricxMECgKZDMmhyesoEdyIUPaPVwbJEq8/aGMY+y
         9bz1egtvd9VjMWCbvYluXo2a1ZoinFlhSeK2z/24LEQ5TMIifSSUmSHUb8z1LtjRd1W/
         aZQDlDHMbII1sDpw09XhUrDp2razJyPC7HmQuDglnqBH/waoI18h1uxOLQLLCtWIER89
         X+Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUc4H6RXo3jZA8mR+Ep5EK5FJGpEtUBZAUztlxYDUWLl7nn10RIdSrSRJCq2nAZ4aEbc6UtjFKJ10CbR3zehvkdOGGnOtBvzg==
X-Gm-Message-State: AOJu0YyR/bEvt5xRNqUORx1H6hMNY/JpjLnS1/9O06mIt9f7cufOWzT2
	bOfwDaRU56o/X7NSS+K1nQzE55Hum5NnRGY6TYjBETWSkTmZmSvO
X-Google-Smtp-Source: AGHT+IH1O8QzAcBaZC3Iu5DWMawGK4UuV/285H1s7NP0rmqg1WqoLOmUjwLDaVwNlrwR4zcAGkYHmA==
X-Received: by 2002:a5b:f09:0:b0:e02:c70d:d292 with SMTP id 3f1490d57ef6-e036eb6e1b9mr10684186276.33.1719956531633;
        Tue, 02 Jul 2024 14:42:11 -0700 (PDT)
Received: from fauth2-smtp.messagingengine.com (fauth2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e6228b7sm47620306d6.126.2024.07.02.14.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 14:42:11 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailfauth.nyi.internal (Postfix) with ESMTP id 984251200043;
	Tue,  2 Jul 2024 17:42:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 02 Jul 2024 17:42:10 -0400
X-ME-Sender: <xms:MnSEZvN0sPtNAnYIf9YbO8j7mSY3p9VSa86TKISGAOmC-Z6B4oKQSg>
    <xme:MnSEZp85LoVbZ1qGQDZ9MPiEBdqsX8HN4-nq5JvGf2O9GpfPOfNekB8_863GG4UIu
    JI8BxeUn5XM6VjfIQ>
X-ME-Received: <xmr:MnSEZuS6ZzTnDee-lcfKCXqGcYJctGGiP1QxD-IcrcDL0S0DmvshU-MCJR0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeiucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhepvefghfeuveekudetgfevudeuudejfeeltdfhgfehgeekkeeigfdukefhgfegleef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgv
X-ME-Proxy: <xmx:MnSEZjvXJslJ44UG8IywgIjlo4sk6T-wUqhUAZ8uwEixr-mtvMgTTQ>
    <xmx:MnSEZndqkFt7Px6mAgyBrmh-psaI42RTfyjwdRqcgBJxrSxEu2939A>
    <xmx:MnSEZv3avpRhxKs9NwPuo9y3wfyZCATSDhuVC7Kq7WuUv5jIqS7euw>
    <xmx:MnSEZj8d3IdRWACMmogPlj7_iYr2yE2e3JkD28-s27pGGBmCm6lCHg>
    <xmx:MnSEZq_awzvPDd_sJbg0WrnCIv-ULBpheWX4-6lPZOWOh16uDZ1KGQ_j>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Jul 2024 17:42:10 -0400 (EDT)
Date: Tue, 2 Jul 2024 14:41:11 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alice Ryhl <aliceryhl@google.com>, linux-mm@kvack.org,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <keescook@chromium.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] mm, slab: extend kmalloc() alignment for non
 power-of-two sizes
Message-ID: <ZoRz9yEy5wQAu9R9@boqun-archlinux>
References: <20240702155800.166503-2-vbabka@suse.cz>
 <CAH5fLgj=uOktnNCEm+npBh8LLbYUEO8uO30YUBsLS-iK+BKQJQ@mail.gmail.com>
 <c8061293-8457-4d2b-85c2-7c631c00245a@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8061293-8457-4d2b-85c2-7c631c00245a@suse.cz>

On Tue, Jul 02, 2024 at 11:18:36PM +0200, Vlastimil Babka wrote:
> On 7/2/24 6:40 PM, Alice Ryhl wrote:
> > On Tue, Jul 2, 2024 at 5:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > Thanks!
> > 
> > Since this change is motivated by Rust, why not also include the Rust
> > change in this patch? You would need to remove the if inside
> > krealloc_aligned in rust/kernel/alloc/allocator.rs and update the
> > comments.
> 
> Right, thanks. Does this look ok? (not tested as I don't have the
> environment working)
> 

Thanks! This overall looks good to me.

> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
> index 229642960cd1..c619acb8b285 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
> @@ -18,23 +18,16 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: F
>      // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
>      let layout = new_layout.pad_to_align();
>  
> +    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
> +    // which together with the slab guarantee means the `krealloc` will return a properly aligned
> +    // object (see comments in `kmalloc()` for more information).
>      let mut size = layout.size();

The `mut` needs to be removed since no need to modify `size` afterwards.

>  
> -    if layout.align() > bindings::ARCH_SLAB_MINALIGN {
> -        // The alignment requirement exceeds the slab guarantee, thus try to enlarge the size
> -        // to use the "power-of-two" size/alignment guarantee (see comments in `kmalloc()` for
> -        // more information).
> -        //
> -        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
> -        // `layout.align()`, so `next_power_of_two` gives enough alignment guarantee.
> -        size = size.next_power_of_two();
> -    }
> -
>      // SAFETY:
>      // - `ptr` is either null or a pointer returned from a previous `k{re}alloc()` by the
>      //   function safety requirement.
>      // - `size` is greater than 0 since it's either a `layout.size()` (which cannot be zero
> -    //   according to the function safety requirement) or a result from `next_power_of_two()`.
> +    //   according to the function safety requirement)

The word "either" needs to be removed as well.

With these changes,

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

>      unsafe { bindings::krealloc(ptr as *const core::ffi::c_void, size, flags.0) as *mut u8 }
>  }
>  
> 
