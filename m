Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541205026F
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706021843; cv=none; b=T2h3bUVjNOnU2tubcdAMqnRnfCffXke4WfpV72wIKef5SZi0clXOrnEQPq5A0ec7bzc2i1bhmifYLf6cSjJFtweXOvhlgloYZEulbVwESdWEmascIvFDYFUj9CYlHC+bF6+nTj01OipeU4a0NBJJD97oUxBTaQO9yQS1wIIdH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706021843; c=relaxed/simple;
	bh=OEOMWTOeHMC8LbMpgkDs4kdAWbWi7Wm2wLN/YTNKjnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FubZgEQTdHDsTetw1irEhhrpqO3nPBaoN0052wC/QZZUDbDBYf0FsEaI9aFMvu3fm0em0jn/yKlOZNYbHtSjQZfyg6+vGCBYZvxGOcQYpNawPZDAkYVTCuD1khoDpCXj/5AbbM44I7ZZvgaNjQpAA8WhSTr0ZRG0x0c9uLULVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TmsAIKWe; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TmsAIKWe"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dc226bad48cso2862792276.3
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 06:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706021839; x=1706626639; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vrNkOuwNFtND2EG7v6Xrvesdx8TZWr4RyzW0Ux+jECA=;
        b=TmsAIKWe3oDoC7zXvVeF8UbX57WiSqRbvauDin7m1mmiJhQxByQWvqJCxw8qXtJdvc
         aeQOWJWiop587CfZ+HczpfXHI1RByPpGsm/f1G13QtlR7PErK4qd7LDyLx5P9TTGFMRj
         EXxB6EYwLDhs/tp3UtzwCKffgST0tBcnUjMxyQAaBeGpnFoaI+6mHUwUIPz3KcSF2Bsb
         J8DA33pLaRxlaX6hiyRFwxW7whmZTIAitW39srIkdM61Vep++Hxgj0wh6WJIPjXkHCM4
         ohVgHPlI9Is577WPUid0lEZKrvKTsos39jO3e/lfzRpwO1TtjC+JqMpexvZG9715KdP3
         mPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706021839; x=1706626639;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vrNkOuwNFtND2EG7v6Xrvesdx8TZWr4RyzW0Ux+jECA=;
        b=re1YQ7z7ZvHq0qSPATHzgc0X3vtjPWhuhTEv5z8OfpWCknDKTP6ll1kUl+Y7QqFdIc
         WE0e+JfFWDen/r/vZ3otFijiJu44mJnAsNIKEAVzibWtLmCyg84qWaeQW+b4AHXESkyy
         tzMVwkKyYdP8eU+l8PR/Qq7lVJ7hxdxAzYmKzisu1hE+VBb+cvy6HjKF1xDwi2pFPTPU
         NE8+5zZhr9lNXInSz02zagBfSr79Z3czNY273Ry4ksP2+/wfdRidw0cv0k41l224seFs
         K5qrj7tATDz1+LFBA9HVSPfPKjafU+Rw3QAO/pgNDpvqh7MDJSSGvIcvQsCoH4vUBRGb
         2hEw==
X-Gm-Message-State: AOJu0YzOJiiQrAO0ggTWfL/R5fN6OdNZvT0U+BCWcl2ZUr5Fi+vZdtkq
	0X7PBi5HNWRvYbZZFJ6DOM37RaP2WR2LE/b46kxR/HAVD9wUr3pz4N1Nroa88lk/FeoU5ZsTkUY
	Pp7wk/Rt+tqQH/OjxipUiRxTQYMmFWvrHpJ3SZQ==
X-Google-Smtp-Source: AGHT+IEwGgdGS6j3b73t2bhroV+V2DhZ194hO3IyNOEKWxVRBICLfz6Jfxh3BFZyQ1qS138iqow8DinpWu4m+InBsR4=
X-Received: by 2002:a25:d0cd:0:b0:dc2:28e7:193f with SMTP id
 h196-20020a25d0cd000000b00dc228e7193fmr3583852ybg.35.1706021839284; Tue, 23
 Jan 2024 06:57:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235812.238724226@linuxfoundation.org> <20240122235822.085816226@linuxfoundation.org>
 <CACMJSevr71oSy-CjUKkyXa4ur=mQL3R+PBnJUWQB-Pw3yp+kgA@mail.gmail.com>
 <2024012314-distill-womanlike-77bb@gregkh> <CACMJSevTCk+HkeBC4YbmiRrzViwBNi9r30wdDKrB8J92YBcu4A@mail.gmail.com>
 <2024012300-print-deceased-ea31@gregkh>
In-Reply-To: <2024012300-print-deceased-ea31@gregkh>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 23 Jan 2024 15:57:08 +0100
Message-ID: <CACMJSet6xZ3CDpiz3JRr8Z2u1EKUacfrxLXzWyxUS1vvPuYLMg@mail.gmail.com>
Subject: Re: [PATCH 6.6 328/583] gpiolib: provide gpio_device_find()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Linus Walleij <linus.walleij@linaro.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jan 2024 at 15:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 23, 2024 at 02:13:40PM +0100, Bartosz Golaszewski wrote:
> > On Tue, 23 Jan 2024 at 13:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 23, 2024 at 10:56:50AM +0100, Bartosz Golaszewski wrote:
> > > > On Tue, 23 Jan 2024 at 03:03, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > > >
> > > > > [ Upstream commit cfe102f63308c8c8e01199a682868a64b83f653e ]
> > > > >
> > > > > gpiochip_find() is wrong and its kernel doc is misleading as the
> > > > > function doesn't return a reference to the gpio_chip but just a raw
> > > > > pointer. The chip itself is not guaranteed to stay alive, in fact it can
> > > > > be deleted at any point. Also: other than GPIO drivers themselves,
> > > > > nobody else has any business accessing gpio_chip structs.
> > > > >
> > > > > Provide a new gpio_device_find() function that returns a real reference
> > > > > to the opaque gpio_device structure that is guaranteed to stay alive for
> > > > > as long as there are active users of it.
> > > > >
> > > > > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > > > Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > >
> > > > Greg,
> > > >
> > > > I think there's something not quite right with the system for picking
> > > > up patches into stable lately. This is the third email where I'm
> > > > stopping Sasha or you from picking up changes that are clearly new
> > > > features and not fixes suitable for backporting.
> > > >
> > > > Providing a new, improved function to replace an old interface should
> > > > not be considered for stable branches IMO. Please drop it.
> > >
> > > Even if it is required for a valid bugfix that affects users?  This is a
> > > dependency of the commit 48e1b4d369cf ("gpiolib: remove the GPIO device
> > > from the list when it's unregistered"), shouldn't that be backported to
> > > all affected kernels properly?
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Eh... It is technically a fix but also this has been like it since
> > 2014 and nobody ever hit the bug (or bothered to report it). Ok do as
> > you wish with this one.
>
> You all marked the commit as a fix for an issue, so that's why we
> backported all of this.  If something is NOT a fix, don't tag it as
> such?  :)
>
> Or, if you want, we can ignore all patches in the gpio subsystem that
> are NOT explicitly tagged with a cc: stable@ tag, if you agree that you
> will properly tag everything.  Some other subsytems do this, but that
> increases the responsibility on the maintainers of the subsystem, which
> is not something I would ever ask anyone to do.
>
> Heck, for my subsystems, I miss tagging stable a lot, but the scripts
> pick up those that get Fixes: tags, so it's a good back-stop to solve
> problems.
>
> Again, if you want us to ignore any portion of the tree that you are the
> maintainer, just let me know the directory(ies) that you want and I can
> add it to the "ignore list" or you can send a patch for this file:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list
>
> thanks!
>
> gre gk-h

No, I don't want you to ignore the commits without Cc: stable. I may
have been too eager to react but earlier today I saw Sasha pick up
patches that were clearly adding new features and *did not* have any
Fixes tags on them.

Nevermind this message.

Thanks
Bartosz
