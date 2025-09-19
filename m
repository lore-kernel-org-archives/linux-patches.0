Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2D318125
	for <patches@lists.linux.dev>; Fri, 19 Sep 2025 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295505; cv=none; b=gIgA6XRljyQik2+xY3jvu4DR562b7Ose/d/S+ktk/PzTPAYFqtRTJSA/Eh7iHrg7wlTc11ZiQXpUFWN4Sr5N5JigDxXAQszt05O+n32T9RYISl8eUqr5dTZJOy/DuxZh0asaMz6LrYzRKX8kVKSGYaaTAQEy/0P0jvepz4AVBHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295505; c=relaxed/simple;
	bh=tIBWHHOOKfm2qL1G0oNEg1lQ/EY8RTTkm2B9w+25Bvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQTZHvCUoLrihlQM/OuyjS6vG6XwCmRBP/PAntNe2cCFb0I7rFtXhS21gy8GlDvp89MRhU8UcIkik2ABRuiIwOCdL+elwZ688fFWNGQVvnKvnKHuES5yeLSFrzFxgkzyQeA8Q+CRY108/sBOI4jAqaBIgR12XMO8WLIHr3HTSTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=N4pVqfaS; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="N4pVqfaS"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5725e554ec1so1848252e87.3
        for <patches@lists.linux.dev>; Fri, 19 Sep 2025 08:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1758295500; x=1758900300; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EztjVQ+y07YMfegmHOd0VyK62XkODMWu0LdNE29WAS0=;
        b=N4pVqfaSojGwMhZ0SjnKJ5NfuTTBFTG9k97/GI7M2SJFdj1+2c9RW91IYaLSTz+Bep
         r6T+2Kgm2WyYWHa9wtuJyzde4zhItTvdEyhrl2xWNaYh5v1mIqbD/2cUQIDF1eofcS/p
         qGP4TC9L2Sf8TPKFrVK+Ucki3+z3BW0fNfTNF/UoPUWNjTll2wkZ2XddOIgzpcF9N2el
         3S/szoJ0FRED6bBsbmNLahezUXlIXpwPnJq6fxAryg9R56j6IsoSejq7dDT9G/v0aaIK
         QS4i8lh1qKrl7WVTT/qTs8U9goZlQ+SENjhH3hEBFQPZe26VLi5I7mwRnoN0O+fgBW4w
         qsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295500; x=1758900300;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EztjVQ+y07YMfegmHOd0VyK62XkODMWu0LdNE29WAS0=;
        b=iGpkDU1U8UnzJoylce57kqBa1fU+x+ZfQwYyPjVWOYUVugJu1kztBisb4bLEVjdqRI
         P2SYtI+bz2xIat6DodT9pVcgQGZ4D7Ce9LHNOQwc4YENyjvx2IZBrs8LJxLZPay16FT4
         bBGLqZVo+RK/5aXswIc82hnAYjSivpdu8jw/jayzeJ3rwc/iGqe+E8be2+3bXonQwh/j
         /Oa5NP6XegDXUGrv7umVzyV3FnCKxawnQnn2VpCREt4FRZJ6OLmMvO8SGxTOd3J4oCer
         7Y5SgQoe7g9aWoPVcEGHsGEtemPc50Kl9lZO8dq7L4y4MsRX55hnWBfeG0SsmPZSqsM8
         sWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUABItwmDYEF2rCBHqUUivcaNOMHMUuQ8BQVD9+XiUlYf3CAd/a4AlSafnjIkjExPUHuu/9avAf@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgq75qYHkGjv/e8N19Dgk0pOz27/+MgLtm1WhYSM+XKFJjom8k
	oNJzdamzgQM2hHsgaCvEXG4JeCuhoZmFptBwRM11RdeaU2ll0cQ89icKzdrBJtmfZqprc5LTs8b
	BKLoMZ2OxIUGKi6S3MZagh75czwD69avhOmkfk+iyoQ==
X-Gm-Gg: ASbGncvjswbqUoL7ev4hnV5VAyCzQqy0anzhpIiqK76s04WbU1MijnZk6z8nouFm5yc
	kOQPXsizZQL2cG7SOUyCFI5Tq+XZKtI534LU/EvxicjtJ+cezZ+WfEDC208xwLLEzxUuTTfzyKm
	Csrp9sG+a09oXuT+UCHd5IXj4rvvN4YEiiXrtFDh0wpwOXQssmzpJeFRKdBkwj7Gkef3bK9WeAU
	fj4kGmnR2A/LdU=
X-Google-Smtp-Source: AGHT+IHin4gQus9SrkFEog2pTedfunr2Ers950l0f82oxrEtfjemfexmsAorW/Dsqdjvay/GpFMt6pfW/hwC+qBHF14=
X-Received: by 2002:a05:6512:2c0b:b0:571:b70b:7dbf with SMTP id
 2adb3069b0e04-579e2507c81mr1455897e87.17.1758295499599; Fri, 19 Sep 2025
 08:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250918152830.438554-1-nschichan@freebox.fr> <20250918195806.6337-1-safinaskar@gmail.com>
In-Reply-To: <20250918195806.6337-1-safinaskar@gmail.com>
From: Nicolas Schichan <nschichan@freebox.fr>
Date: Fri, 19 Sep 2025 17:24:48 +0200
X-Gm-Features: AS18NWBwMqIXE_dMXDlT0ngUIReSbekPPTszWv5gIfg03bAEg3Id33JL3Yqjedw
Message-ID: <CAHNNwZAzecVcJXZmycX063-=p-M5jVkfStfgYVKJruOFo7y9zg@mail.gmail.com>
Subject: Re: [PATCH RESEND 00/62] initrd: remove classic initrd support
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, andy.shevchenko@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cyphar@cyphar.com, devicetree@vger.kernel.org, 
	ecurtin@redhat.com, email2tema@gmail.com, graf@amazon.com, 
	gregkh@linuxfoundation.org, hca@linux.ibm.com, hch@lst.de, 
	hsiangkao@linux.alibaba.com, initramfs@vger.kernel.org, jack@suse.cz, 
	julian.stecklina@cyberus-technology.de, kees@kernel.org, 
	linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-csky@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, mcgrof@kernel.org, 
	mingo@redhat.com, monstr@monstr.eu, mzxreary@0pointer.de, 
	patches@lists.linux.dev, rob@landley.net, sparclinux@vger.kernel.org, 
	thomas.weissschuh@linutronix.de, thorsten.blum@linux.dev, 
	torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

> > When booting with root=/dev/ram0 in the kernel commandline,
> > handle_initrd() where the deprecation message resides is never called,
> > which is rather unfortunate (init/do_mounts_initrd.c):

> Yes, this is unfortunate.
>
> I personally still think that initrd should be removed.

Considering that the deprecation message didn't get displayed in some
configurations, maybe it's a bit early at the very least.

> I suggest using workaround I described in cover letter.

I'm not too keen on having an initramfs just to loop-mount
/sys/firmware/initrd, after all current kernels are able to handle the
use case just fine.

It looks like there is a lot of code calling into specific filesystems
so that the initrd code can guess the size of the file system before
copying into /dev/ram0, and I believe this is what causes the main
gripe against initrd today. What is wrong with just copying
/initrd.image using its actual size into /dev/ram0 instead of guessing
it with the help of filesystem specific code ?

> Also, for unknown reasons I didn't get your letter in my inbox.
> (Not even in spam folder.) I ocasionally found it on lore.kernel.org .

Sorry about that, When I used git-send-email yesterday to reply, the
SMTP server I used wasn't authenticated to google, so all gmail
recipients were dropped. Hopefully this work better today.

Regards,

-- 
Nicolas Schichan
