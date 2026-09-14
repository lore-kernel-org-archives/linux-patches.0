Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEAB41E6CE;
	Mon, 14 Sep 2026 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378535; cv=none; b=tOHG2VAvnlG+ILbKV+6uqAQgllZMK0im6CzfFQ7pJ1dpLaLYs3jM6eDG4b+5YKyXisXRivQRNjMFnwaWkqSFXg7HR1x3vdsNCZuBZQptLrVaNiuLXwZZMkgOQHlpTqCfsB33PHQ6F9PLWpUew19SuCnbIXsL8GxAsWsfSY4gkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378535; c=relaxed/simple;
	bh=lczIRNW5BeK1llc5a+uZhymLniWCcuVTxOMpfN2A4bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLM1/9qU9MvG339QmGVbfpIUDD87/+9IQfijHUwREcKHLgc9fBt6QAbwtj9iBovYrwww5LxscS59sJD7XuQll5YdxWiEiSu9+SApuewgfiafEQXP2jyVnH0bn6oSRr7kQvjmkvudFgfwRxpqhXYXImfyKra3tWZeExjFGGNeAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTOVbQO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTOVbQO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1251F000FF;
	Mon, 14 Sep 2026 09:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789378533;
	bh=TQYc81ggoG9W9B9egYI9ij9PEVTOOx3as0Uq0mRo3w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JTOVbQO5rYcGXTXeG30zAEwCRwLaxl5nEngCbgwngHw7E7cwEUzFfJCKqnmPXLYMY
	 I8XQlQJ2d6UzJMi+i5onfTsMTghrVBpAdg6qmDncxWj1T2BpXIMVTkxXkyh7i2EEsF
	 uK0fsEmxI4P/GuCMrdVOKVOybTnlLDDvhnWZRJ6A=
Date: Mon, 14 Sep 2026 11:35:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0248/1518] timens: Remove dependency on the vDSO
Message-ID: <2026091413-clatter-duress-71ae@gregkh>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065629.093403177@linuxfoundation.org>
 <836d73d0-163b-458b-8481-60185f88d577@t-8ch.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <836d73d0-163b-458b-8481-60185f88d577@t-8ch.de>

On Sun, Sep 13, 2026 at 01:11:07PM +0200, Thomas Weißschuh wrote:
> Hi Greg,
> 
> On 2026-09-12 08:40:17+0200, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> I object.
> 
> This now lets SPARC enable time namespaces. But the SPARC vDSO can not
> handle those (yet, in v6.18). Userspace will read incorrect data
> from the vDSO inside a time namespace.
> 
> (...)
> 
> > Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")
> 
> This does not look reasonable to me. The mentioned commit should be
> backportable as-is, without pulling in four additional patches.
> 
> If you want to keep this patch, at least drop the deletion of
> 
> 	"depends on GENERIC_GETTIMEOFDAY"

Now dropped, thanks for the review.

greg k-h
