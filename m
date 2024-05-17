Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE552E65B;
	Fri, 17 May 2024 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715939502; cv=none; b=blISEIiGXXdOBJlF2avsRoOKcJW4G0oLYMWfHb2k94MDVSj0SLPyVouYbCDoxppbfHv1KScPNdHz+z9ZJgEDiIEAd6mUJcSU1uC/5JgFwCEzDz4n96D60/7i0I677LAX75HyppldrmF/d8svkRUbt4dw/vU853r9w+6ejC9bv14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715939502; c=relaxed/simple;
	bh=KNh+720Wgwh8m9JIhESist1X1saR8CCo7u3IGLKkC4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AombeS7CZrpQ5eniwtvWtzSSCrN4oupQTzTVT8ZejqMZRnJtJ88NT/eptAX6VXUyccO6XpCk0GH//jWXo19VMvra3kb2hlB4S8TK/d/X8mYM1Ju39Mt1AHCk73LFL1RBkmOi00q6gV+GSLNrr5TFmolR/xaf6RlM/Fjst2DUrv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VsxPCu82; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VsxPCu82"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D520640E023A;
	Fri, 17 May 2024 09:51:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z1P4H5KTAb_M; Fri, 17 May 2024 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715939488; bh=Tn19CGCpCdau3W/VZavQRk1vzNxdqS823UYMPdxtm78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsxPCu826x6OJ5zXBP9Y1SK4oeTmhoXkcLWgCKbCAMbYbstfkLuXfIYXFcKumfJPc
	 LwHb7KT9srjLqiqyF48cefYqs1kxnpJWRlFM6QjAkpT/yg1+L2BRtALQOk/kdORhx5
	 safrlHubHttQgV6i3FygkKjfsbBqodIdferr8pc4gLJrSaWjjvQO+p+sp7xXN+8Oi9
	 Admwy2sXu0y/YRQq7DnBYKHpLQJ81hfnoI9YrLN2sov4ndVaVopAwCFavscPXhQrq6
	 J2nUy4wgANjobnNmN1YJXWz1wmdX9bnEuYTba8qqHWu1Po/RbDs81AmKalz9kNsitt
	 lqt+P8FF4296Sa54BKHsZatpKFh1i6eUlmbMnOjpNddBddqOnKA/uIvPADyvWCaqp5
	 A9bbqifeoC8wChN39d+AQ/Df3xdq3vyY4CTS07Az4iQPGI9b+dx5VqOfYg0mog+Sgz
	 s6BG4VXU4wPxceI7hRsXBH7U9dEHFpyOBBqxQbAPdZmAR/Sg1qN0tAwO+Rt8UpfSp+
	 s10tvZpAflIdT9gVni5vCB0q0yLJM0t5RZ2vM33VekQo/ypq5NakJiVL6RPwmV+9Gv
	 IZm+3Rh8pwoaomM10OhmiMwGa+S7P0von8C+B4dic+SoHfYLKeXpxF5y+VM+hQ3foE
	 9yamcT2+mXy4janDcmN7T+yI=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5094A40E016A;
	Fri, 17 May 2024 09:51:17 +0000 (UTC)
Date: Fri, 17 May 2024 11:51:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Message-ID: <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>

On Thu, May 16, 2024 at 07:03:41AM -0700, Nathan Chancellor wrote:
> After enabling -Wimplicit-fallthrough for the x86 boot code, clang
> warns:
> 
>   arch/x86/boot/printf.c:257:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
>     257 |                 case 'u':
>         |                 ^
> 
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return.

Is anyone fixing Clang?

:-P

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
