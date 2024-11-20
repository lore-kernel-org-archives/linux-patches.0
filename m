Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A080A939
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 01:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732067352; cv=none; b=uU0ikJGmnzbej2HmXSU3kYXRPc2tdyuBMdc9GlgKhsMa2+CLFeCSidfyJu51AmEbqtttu3EE8e+uIqdVASJAo5NuYyZB3WWC8PDlrr2bxreoXRmEd1+F+d3riSLx41X8WxlwbfdM0gpjqg6F1p1iYDiRHlwft/Ry99J1pfp1fog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732067352; c=relaxed/simple;
	bh=EAKpdeyDJm1SlvzUANfvdhriFje3XuVI6ZzJj4LNyi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNKlB/rpLJ0CAAhB0QgbdrDJ99ZKpdraUM09XUTZqG2QBUYRPAIOOiJCkSLypQrOydYVY2T7PXhNN1W5gaWoByjtXDnKSlcadL9WivPJ0AO8pJp2K4y+w7J0+xNtVvQu1UZwusqjk3rBTw6bL3zzLpgCbFLRlpNqe9SB3GQ/YdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=cH9LsnSo; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="cH9LsnSo"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id A318214C1E1;
	Wed, 20 Nov 2024 02:48:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1732067342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2PViwLu+dg0P9GG0f2zwqi+Mq2PnJu2tWgniJP7nDrk=;
	b=cH9LsnSoFs+oB3EWSGWLxMU3U4Kj+0TzfjEb9LXFQXQf1Y+ZHjB0rXbbSTWOJ9rSmVpHeS
	lze/GqaRKXb9YRnh5THmanqxrPKT6AUlRMeG7CGmWdzlfTDALzRv5zX3+cgCCU82aaXe9S
	PabVm8VCDJGwiCo74I7AArg6waUpVLGnRm+xWbsUJGpStFPcgtMyepui0e7Wz8tqtNuUQE
	Vlc4MLgxv9OruY8yRnBkTfg0xmBr/s0FDgMtO5qM1MrgCeFgcCFDC0DqcHsQaA1Fj7fuxQ
	c9HOOvL8SDJiSN0BaWShU77DQb2TTqCwiHtroZKDWyTJF/w+VeIBUX68WJBT/g==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 4cfbaec6;
	Wed, 20 Nov 2024 01:48:57 +0000 (UTC)
Date: Wed, 20 Nov 2024 10:48:42 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Message-ID: <Zz0_-iJH1WaR3BUZ@codewreck.org>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827143844.891898677@linuxfoundation.org>

Hi all,

this patch introduces a regression in some versions of qemu-aarch64 (at
least as built by debian):
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1087822

It doesn't look like it still is a problem with newer versions of qemu
so I'm not sure if this should be reverted on master, but it took me a bit
of time to track this down to this commit as my reproducer isn't great,
so it might make sense to revert this commit on stable branches?

(I don't remember the policies on "don't break userspace", but qemu-user
is a bit of a special case here so I'll leave that up to Greg)


I've confirmed that this bug occurs on top of the latest v6.1.118 and
goes away reverting this.
(I've also checked the problem also occurs on master and reverting the
patch also works around the issue there at this point)


Thank you,
Dominique.

[leaving subject below for context, no more text after this]
Greg Kroah-Hartman wrote on Tue, Aug 27, 2024 at 04:38:03PM +0200:
> From: Kees Cook <keescook@chromium.org>
> 
> [ Upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d ]
> 
> In commit c1d171a00294 ("x86: randomize brk"), arch_randomize_brk() was
> defined to use a 32MB range (13 bits of entropy), but was never increased
> when moving to 64-bit. The default arch_randomize_brk() uses 32MB for
> 32-bit tasks, and 1GB (18 bits of entropy) for 64-bit tasks.
> 
> Update x86_64 to match the entropy used by arm64 and other 64-bit
> architectures.
> 
> Reported-by: y0un9n132@gmail.com
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Jiri Kosina <jkosina@suse.com>
> Closes: https://lore.kernel.org/linux-hardening/CA+2EKTVLvc8hDZc+2Yhwmus=dzOUG5E4gV7ayCbu0MPJTZzWkw@mail.gmail.com/
> Link: https://lore.kernel.org/r/20240217062545.1631668-1-keescook@chromium.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

-- 
Dominique Martinet
