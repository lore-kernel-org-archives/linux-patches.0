Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32FC374D3
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719938475; cv=none; b=h+H6bHJT8W+QYiD/8DWZx2C65V/2lgM4p7LjXWZ9eynDdNE5qiQi/mSXeJu49zNWWMNKywzCviTM9DIOEMkcXSeuLWtuFLgyPUH2DvCdfNZzkU67iNvQh5eR4Q1YqIT7TddqCRDl0Ej7QvSTJ4y7oEje6SlFsWk+KqTRKEUMKw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719938475; c=relaxed/simple;
	bh=hrR1qTpjCYxMI+tohq1SLUm7xMaux6bit4k4/AiVhD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r4tnJQ8TiF8DlxWHq49hN6hJZXq9dyzqzisTuBwq8G3h+N5XaNqvmvgcLOcuGcnBQw3ysMMUB6wbyHcOKccy23GDaY/RzXLKG/SafYYJDjnV5VyE3PuZz3H8BX3JJy7tPngU017s/ogmSwvp/PkB0htCuF+hhh7CySj0bUErC8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K6uJ0W0T; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K6uJ0W0T"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-364ff42999eso2184235f8f.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 09:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719938472; x=1720543272; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdEhN7egg4GTetScTgi2yWO5StQG3EhkGlVLI6a6mXM=;
        b=K6uJ0W0TuCOgWXPhZt7gjcJBv6mA5uteRCEgJ4YBQs7CF4dliELrp+TtCyZSQU40bu
         lheAwnWrXVBstUnJp+esgtAsPRZ+NUvBiFW6g29r/ViFh02mOaQrepEHpFzjRAGUKyHW
         A4i5OSSrKfJ39bDfErdN/HRWDUkZHb9q3F0kCVozmyELkyTvZR72uzGfQAyiUIgHCXaq
         Pp1zBPtBknd2f6itQ1n9tLOwCuuXf/SI8OrHbCsbXEikHJETaWoZo/xUpC6O7Yds57S4
         NI1iteKj5Li7jOYy+pEF+4NQhmilAAhxljjli+vY9ByOmzOHoBrGAPI2lxLz4xPMORsb
         Y4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719938472; x=1720543272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdEhN7egg4GTetScTgi2yWO5StQG3EhkGlVLI6a6mXM=;
        b=fRMr6PJR1JDNAd38lcnumlMUT8e4XonxIUSVU54fqVr3AfIwIbmgVjACZ/7EM6L4UM
         A6imfbGPRIgxDVfqMSt04O7y++WixcmL8+LAQ+BSKxgyx2h0gIANziAv8wzjBenpqTbe
         YvvstEgxPaWCOerS+XL4Fnob/CgvJequeFqzZ7dLU6QBtpvMfF2IqhDV88AZb9dI07jh
         swyaOsvI55ZMraF8WMLlNXcOb72/w4etXYyz5+jiYxyr1Av0UwmFnXgBBTTR2WtcngLF
         uaogxx9T3W4edUd5ZA210kIkr1Y+yt7oc2lgFIQmssPapy1J8UaiRhpFgXx7WiZAj7u4
         KgMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAGsu/IpeF0CekrDCrt5OCKNcsROZsnEXhlZr6jUIuNUlst7vyrPVPqxe96dpG5gTk0/EehdhtkJt/NbSIndWSYG4xxWvZBg==
X-Gm-Message-State: AOJu0YwKfnxqaNHdp4/TmVPNspHvR03+LOfSW46sw8xnoLrng9TNXsaR
	4dnnDxNt1G7stm0kLuAdQTEZB6ajZ4xZ9Oz/tzY/AWqVu3wmCCtdNuw+I+dDQ5Ro8X0XT2GQPZq
	qd5VaZPyKwkS4nOsxymTNopLg6ZZNZc8nJY+O
X-Google-Smtp-Source: AGHT+IHmYsZn/Vy3aZXo1dvsiv+ZReJUZGbhaq1QATW22XsOqABArbPhv8Sbvt3RE2ym1iLvf5P0H4DKXuYSyJ0kisU=
X-Received: by 2002:a5d:5889:0:b0:366:eba0:8d8c with SMTP id
 ffacd0b85a97d-36775724976mr8558555f8f.54.1719938472236; Tue, 02 Jul 2024
 09:41:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702155800.166503-2-vbabka@suse.cz>
In-Reply-To: <20240702155800.166503-2-vbabka@suse.cz>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Jul 2024 18:40:59 +0200
Message-ID: <CAH5fLgj=uOktnNCEm+npBh8LLbYUEO8uO30YUBsLS-iK+BKQJQ@mail.gmail.com>
Subject: Re: [PATCH] mm, slab: extend kmalloc() alignment for non power-of-two sizes
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@linux.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <keescook@chromium.org>, 
	Boqun Feng <boqun.feng@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024 at 5:58=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> Slab allocators have been guaranteeing natural alignment for
> power-of-two sizes since commit 59bb47985c1d ("mm, sl[aou]b: guarantee
> natural alignment for kmalloc(power-of-two)"), while any other sizes are
> aligned only to ARCH_KMALLOC_MINALIGN bytes.
>
> Rust's allocator API specifies size and alignment per allocation, which
> have to satisfy the following rules, per Alice Ryhl [1]:
>
>   1. The alignment is a power of two.
>   2. The size is non-zero.
>   3. When you round up the size to the next multiple of the alignment,
>      then it must not overflow the signed type isize / ssize_t.
>
> In order to map this to kmalloc()'s guarantees, some requested
> allocation sizes have to be enlarged to the next power-of-two size [2].
> For example, an allocation of size 96 and alignment of 32 will be
> enlarged to an allocation of size 128, because the existing kmalloc-96
> bucket doesn't guarantee alignent above ARCH_KMALLOC_MINALIGN. Without
> slab debugging active, the layout of the kmalloc-96 slabs however
> naturally aligns the objects to 32 bytes, so extending the size to 128
> bytes is wasteful.
>
> To improve the situation we can extend the kmalloc() alignment
> guarantees in a way that
>
> 1) doesn't change the current slab layout (and thus does not increase
>    internal fragmentation) when slab debugging is not active
> 2) reduces waste in the Rust allocator use case
> 3) is a superset of the current guarantee for power-of-two sizes.
>
> The extended guarantee is that alignment is at least the largest
> power-of-two divisor of the requested size. For power-of-two sizes the
> largest divisor is the size itself, but let's keep this case documented
> separately for clarity.
>
> For current kmalloc size buckets, it means kmalloc-96 will guarantee
> alignment of 32 bytes and kmalloc-196 will guarantee 64 bytes.
>
> This covers the rules 1 and 2 above of Rust's API as long as the size is
> a multiple of the alignment. The Rust layer should now only need to
> round up the size to the next multiple if it isn't, while enforcing the
> rule 3.
>
> Implementation-wise, this changes the alignment calculation in
> create_boot_cache(). While at it also do the calulation only for caches
> with the SLAB_KMALLOC flag, because the function is also used to create
> the initial kmem_cache and kmem_cache_node caches, where no alignment
> guarantee is necessary.
>
> Link: https://lore.kernel.org/all/CAH5fLggjrbdUuT-H-5vbQfMazjRDpp2%2Bk3%3=
DYhPyS17ezEqxwcw@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/all/CAH5fLghsZRemYUwVvhk77o6y1foqnCeDzW4WZv=
6ScEWna2+_jw@mail.gmail.com/ [2]
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

Since this change is motivated by Rust, why not also include the Rust
change in this patch? You would need to remove the if inside
krealloc_aligned in rust/kernel/alloc/allocator.rs and update the
comments.

Alice
