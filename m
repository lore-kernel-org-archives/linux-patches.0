Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7630A22D79F
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 07:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750319441; cv=none; b=D98zIowaYfFE7/j3dfXQ/xYyZRJMZwiYyEAWhNfhqSa79k8jVQjrUpdzzSjNfg+8uqxzjBg0Ig5M8rTOXS1eF+aRIyR8h4FcPhQK917EsVYUsbfmL/XES7HOg8l3xaKyoBrrjb7lAyUp3tqINBXtrIOnOtMVLvpnj1f8IGe/xT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750319441; c=relaxed/simple;
	bh=gq5eDXOTnkSJzD3MGEoM1mzFkjXA3EdT8EWxfNUexmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T8EPAYzMjWlQFwsDb7pSXRkYkePjXdeToCBqeZsnI4gKvu3ytNGP12XVKVka01rUI8vcxQDiM9dMtEchpmQDAwm89s4C+X/9jNKG9hIvNUE29i0Lu8eGeccKEV+QjdsKL5UIE2vnkzX9v+Sej4Uo641pZzNx4csC3Ooelg8eI4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OLYpiPyw; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLYpiPyw"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60780d74bbaso842353a12.0
        for <patches@lists.linux.dev>; Thu, 19 Jun 2025 00:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750319438; x=1750924238; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FfRJBeVSCQ45B7cfuHD53KdrQZJh4p4JHS2sfk8xrRU=;
        b=OLYpiPywjp2NyOvDeXpBcrQUouIhh0GY68Tm3hHj9eSEbKD9/bDCUWkqAwHJW9Hvy3
         wSAup4HHjFu2oNqpJ/cPJd1x4lWvWGcsHV83gTRrneQaFrnKWjKaIt71Ba15U4ZoKgpU
         7TK9ikqRyQpxsMV6dlg4ItCu6qzCQH1bHX3d51PaHjhmx4Lfu+ELCAoK50qcP85dQ4wY
         delwKKVvmRrkVdCLFHERJWjxElBSIi0o90br0PACcwd2YgZsPg1bIGGbpFgTGctQnpWP
         vKCnyPzyc0yFPaZO3wGtvn5JyMxU9yZ42KhkBfLlXM1wFLaYUDV1aL2uHZyuEEVN1AXY
         J21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750319438; x=1750924238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfRJBeVSCQ45B7cfuHD53KdrQZJh4p4JHS2sfk8xrRU=;
        b=RUaT9NSauN3wcumGNCFR/mKhd4Nap3D8cpowvH4p11QBpiihVxt4FW/b46OZec7xg3
         20g3QV4XMs7fA+NXhIG3FlOeb+ByBBO9fs5V2wr90Av1ARTYuGvuUQGtnoJc1PPCMkp/
         kLlcvIpUudhVgy66Y3kTL/EoCrrKMACK9vUAK7QKV1lmK74Y+pUj3mpl+f+w70/hsRe8
         a3XXJtbZg6zBaR+ZTj1bMUJcaSC55NNUjNeOVknwa7lXudo9bfmj0U3XBCiTIemK3Bay
         Em/pCiWA3R4wq6IN8cbpzw2nUNUe9odKFXJRxw5ea0rJv/qUcQqVJplc0m3Um/91chFp
         qy2A==
X-Forwarded-Encrypted: i=1; AJvYcCVv30Vdviq5A9dRTdhtXZ/elLTzM1Eu60pkS3DRhdn6apqbtdTtismoarX8jfkkY/T8nk/v31Q8@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/Lo+HoMrVOZtpo/lwxtr4Zg9gdJXgdapOyY7ncM/wWIHkj+a/
	dEjttxBoOZdEJOLjyRcxJG8T7wvJH6EGdL4pxYEznUXVHxEnLdzEBMtFslrD19/pN+k=
X-Gm-Gg: ASbGnct44RKC0jMFaXKJiIBT0Z2HLjYUNVRFdrGcTnegoAqw7wm9OpG+4PVnn40lbG8
	fD8LOI+r2WE2FMddLNXYQKLKO4mOkUPWKOoKQaei1nYSNqAvDuXEJYnzXbC97bIZB+sfh9Wu5DB
	krz9UvDD6mdj7XJCSdHcYHuMXoJTdeG/DzjISdcF5p/4kYV29mhY7blaKqna6BkGzn1I7YLq0Tc
	dqyHMENJNVftJNgCVVPJDSE8sWseUdU4s3QBFxrhi9HxxORsPE9em3jslNqieniKx0vGVE/E4ut
	AQVS3x5fO4xDj6PlpRbQPAw+r9y8/0xcRvKZhntZpVg6hEJf0arlCaAcDYQ=
X-Google-Smtp-Source: AGHT+IHgjfrbbxOvJ9sWlAlCmW0tX2gmZ6K9b6h6wOrrFiX3PrgTJ/1ROFNYKmY3yy7i+yS8s7dH4g==
X-Received: by 2002:a05:6402:13c9:b0:601:470b:6d47 with SMTP id 4fb4d7f45d1cf-609e3fb75f7mr1867518a12.1.1750319437397;
        Thu, 19 Jun 2025 00:50:37 -0700 (PDT)
Received: from Tunnel ([173.38.220.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-609b8b941bbsm2741987a12.34.2025.06.19.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 00:50:36 -0700 (PDT)
Date: Thu, 19 Jun 2025 09:50:34 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 257/356] net: Fix checksum update for ILA
 adj-transport
Message-ID: <aFPBSlRDsNv4ZT2l@Tunnel>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152348.550981340@linuxfoundation.org>
 <aFLv9Ea6Sh2eXjed@Tunnel>
 <2025061915-uninstall-subtotal-23a7@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025061915-uninstall-subtotal-23a7@gregkh>

On Thu, Jun 19, 2025 at 06:22:39AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2025 at 06:57:24PM +0200, Paul Chaignon wrote:
> > On Tue, Jun 17, 2025 at 05:26:12PM +0200, Greg Kroah-Hartman wrote:
> > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Not an objection per se, but I've sent the same backport at
> > https://lore.kernel.org/stable/6520b247c2d367849f41689f71961e9741b1b7eb.1750168920.git.paul.chaignon@gmail.com/
> > The only difference is that I also backported the second patch in the
> > series, which had a conflict. The backported patchset should apply on
> > 6.1, 6.6, and 6.12. I hope that was the correct way to proceed :)
> 
> Ah, that is nicer, I'll drop this and then queue those up for the next
> round of stable releases, thanks!

Great, thanks! There's the same for the 6.12 round of course:
https://lore.kernel.org/stable/20250617152434.326263517@linuxfoundation.org/
The 6.15 round does have both patches from the series.

> 
> greg k-h
