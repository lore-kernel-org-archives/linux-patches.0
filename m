Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE73AD509
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781085346; cv=none; b=c5XI0Tp+nndS28bFDsHyMrIH3i8T3HmmlG+UcadAsJ88Da4eJjgudpK6bwNVDZKf6vzQprPwW4APMIj6ShmGi+ZKLHZwAjT3aAhJHRHgFm7DOY2YA2F9lGJEWVCWtdya0Q+rIwjW+EupHuyLzXycINbMdS7dLPes+A+ALf/YMw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781085346; c=relaxed/simple;
	bh=RxYtaOzOjvXLhABsTLKT5rUdf2WjHUzZ4ozMxheKOIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGDeUFRKkF5Nl62tKs7KM36P5GQZJUV0Z0GUSRPbpaUqPpaHAslOj+hrF1X73ymq8e430lFs6y30h7f4Uk3RF/vOlRTCJGx1IJ3sPGDyYcAv8XfQSPd3iuNeyVMM7dnZdbVPlkP2tc5xnROFFSnorW9lDqjVhXZeTXKXF3jmF+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwKuDqxy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwKuDqxy"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso51335195e9.0
        for <patches@lists.linux.dev>; Wed, 10 Jun 2026 02:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781085342; x=1781690142; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXXf5kDNkZaZma579LeFr3+QRDi52FtRCi+F8Ah0BJ0=;
        b=fwKuDqxyvuHVxF4C6bcRUD/XvYTVaBccqk3bfUrq+8Bd9tdRL4SFXPn0YIytSMza38
         aBMLIax6EeCNm+Y9JE6f9Gz6DVAv76Nj/SdNgk8BJlLOwsm0jzDb8zyogC4YKPcy9Cn3
         yCMmsBM6x3xAh5Zx8OOL9GduyFhOKkbrbmQRn0taV0pgGwifrKgp6hWrA5fqPAiBTsxC
         wmYkzYPVCIX7ZBiamJkq4+C474T2egBhyaPF4v7i8//zARHn/pxm0M2YaGepwcBvckyC
         qLSae8yXWkjHUAfK5IvJ7jNSc4csu2x+WYXQC4WQDUXNQAGPpyWJf0z5SJ1eAmeHJdYE
         vPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781085342; x=1781690142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DXXf5kDNkZaZma579LeFr3+QRDi52FtRCi+F8Ah0BJ0=;
        b=glpGTu2AVORNEGfJWdv1cA8zs5e6sUUps88i4FtRiyAzoyjdDvGSlGlTZ8mvpjYV5Y
         2rjQFkiyMYXi67AbtSeWLH0jkaxeH+Cmdyt0l3f+2qqUdkb69jAXa5WGU3gErqAC411U
         4Ny13pl73kMX5LJzPxr2OhEXq/Kprchnk83+mhQKe4adXjXeOTQtsGxwFlDsXr2iwrKx
         5e9wjn0E/flMzDkrfVASyrG3N/8K5GRz3JVQMABwQN5n7yUffnL2TMiCR+AKDKSaSUXn
         ayaLKXNILeT/UYdUIAycsPqCbWr+QjY+Vu5rXAYjYIXEEJBkdq0zFuiYuOGfSSH7A+IH
         gLig==
X-Forwarded-Encrypted: i=1; AFNElJ+1W8WziHYZNt6i/H9CV+UJU/dS7QQ6S4zCSEil4I+7Nrpw9ULGBcR2BZJJGoc9sGc6q+VF6Llg@lists.linux.dev
X-Gm-Message-State: AOJu0YzKA3UCGML9bYA7kgsmozGilvRrWFFA1aKr39pENqUwBaiH6Iu5
	Spk3GnyocLHcp94jpev3Shh8oHB7H8wKX64uu7VLQu349v0dVP9cBAXE
X-Gm-Gg: Acq92OFOd5KCRpgp+K3GA4gp+JkG65L3LkzujCuDGadRtsT9JeCcdDLhG4d2NTj/8hO
	K1vlS+orPiHGWHcyEOxjTkHQnQ+EFazFqeIuepB88V83Uyr2VIG+hgRufpixjX7lXApNjVy0sk6
	/QnXC20SaA/nQlI3A97diJItRH0CkFlZvrZFzC05lTPN0MIXXUlLfVF1JA8OnpFExCUtrAdIGV1
	gsPLCIvVEPUX/H2NWX9kdUui9ehOzZJN3/mq2j/GqVWhT+JbXWMGnuQROpftn6FJg2QrUo6nf5g
	gfeTsYY21utq+ZIxqlXljvoaGc1/fZyNk+E0m/EflE88bSPpx5SRf9/RoO02nu2Owl4oy0u1370
	7nUDR8SmjFyZ/ejT6j7sYiNwT37IbU424Eqnt3gzPuuRCaIFichTLVaD/Q6kvMo7NDx/pLCuYLE
	Mt6QAPz8ajdHb1j8rk/lj5n4cgPVfFiarG/PioHWSHrLma6OIgKuxrYWNS9EhjS5iSFpBl81n5J
	6cs1UsVyQ==
X-Received: by 2002:a05:600c:6096:b0:490:c1cb:48f4 with SMTP id 5b1f17b1804b1-490c2d038e8mr309043665e9.12.1781085342059;
        Wed, 10 Jun 2026 02:55:42 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490be1f69bcsm591850845e9.8.2026.06.10.02.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 02:55:41 -0700 (PDT)
Date: Wed, 10 Jun 2026 10:55:40 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@amacapital.net,
 safinaskar@gmail.com, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260610105540.5901a5be@pumpkin>
In-Reply-To: <aijxfxXrWLCVqV6-@gondor.apana.org.au>
References: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
	<aijxfxXrWLCVqV6-@gondor.apana.org.au>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Jun 2026 13:09:19 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Because I think splice() is a *cool* feature. It was always *clever*.
> > I just don't think it's worth the pain it has cause.
> > 
> > And it's been around for a long long time, and after more than two
> > decades it's still most definitely not _widely_ used.  
> 
> A couple of years ago I used tee(2) in dash(1) so that we could
> avoid reading the input line byte-by-byte which is what every other
> shell does in order to pass the rest of stdin to the executed
> command.

The shell just needs something like MSG_PEEK to do a non-consuming
read from a pipe.
(Without the strange behaviour of a second offset.)

That would be simple and could have been implemented 40 years ago.

-- David

> 
> https://git.kernel.org/pub/scm/utils/dash/dash.git/commit/?id=44b15ea09a9ee5872cf477e4ffc6b42ef37d1e46
> 
> It's definitely niche but made a huge performance difference to
> this rather common scenario:
> 
> echo 'command
> ...
> rest of stdin' | sh
> 
> I didn't even know tee(2) prior to this, even though it was added
> way back.
> 
> Thanks,

