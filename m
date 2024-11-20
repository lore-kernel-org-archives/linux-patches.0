Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E9B157495;
	Wed, 20 Nov 2024 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732126336; cv=none; b=uTzdFOkmwdIyvI6g+VX53sQmLBO9WfGMZ2u+370Gu8t9WIiZCVcP4CWR8AGgDuH4p9GWWyRsJhHjMibw7IdmOfd6cxnWsziFf+WcTFOiIZboZZ57NmxTt7KF9WSD75NFbaZexhmxqUWlYG8GPfBy9BBKQg2CKfau2xUGYeSX/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732126336; c=relaxed/simple;
	bh=yN99B6dw1+Kpn9n/hT3dqt06djMUw83aiQb2jkmwd1k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Kj6RoxCZIJei3jqKgMS93i3f2UfSE6WJjBmytsWNNDZ0k51WrRgTvZlifyyxPs/Eu+O7pPKmti7RQWbUbFWPnoFjPEl4w1247USHwWVaABHCrXO3/VJ3hmHEofsNgqibCu8OSuJSN5XpmaizaT1XkYfs12uboXcbe0tzUTnqOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OefdNV7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OefdNV7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAC6C4CED0;
	Wed, 20 Nov 2024 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732126336;
	bh=yN99B6dw1+Kpn9n/hT3dqt06djMUw83aiQb2jkmwd1k=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=OefdNV7PFnk2ZaiEc7O8w/RZR8x/cGDiPk611ulWyLYYijqqZETZ3Hm6jmXt25mDT
	 RE78rzXi2rg1Bkkrj1PUzqWoEMLk41ttTaHefRJCNkuNX6hJxZPXI+sxmo8Kk2ge1c
	 DDWmvP8ohlRyjQG99+VlPtiO532UfJE7mM67WupRRwbRr5u9B9MHlhT6chx+tPKaZ0
	 G3cUufhg5H+0Ryj0tsOmz+LeqyupAoj5MUn9f50meI+knnZOgnvZwnmvbccLfNTPfH
	 2V9aCdtLVOTtbvC8d20n/TXlXRB5sEsdbTGzQIkbmiG0VC//VDHf20L75AD/GmKRcy
	 o1DAI/oxAtU1w==
Date: Wed, 20 Nov 2024 19:12:12 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
To: Kees Cook <kees@kernel.org>
cc: Ulrich Teichert <ulrich.teichert@kumkeo.de>, 
    Dominique Martinet <asmadeus@codewreck.org>, 
    Salvatore Bonaccorso <carnil@debian.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    "stable@vger.kernel.org" <stable@vger.kernel.org>, 
    "patches@lists.linux.dev" <patches@lists.linux.dev>, 
    "y0un9n132@gmail.com" <y0un9n132@gmail.com>, 
    Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <sashal@kernel.org>, 
    "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy
 for 64-bit systems
In-Reply-To: <202411201000.F3313C02@keescook>
Message-ID: <8s8037p1-8o51-278o-nor4-o5q968rsq7op@xreary.bet>
References: <20240827143838.192435816@linuxfoundation.org> <20240827143844.891898677@linuxfoundation.org> <Zz0_-iJH1WaR3BUZ@codewreck.org> <Zz2JQzi-5pTP_WPx@eldamar.lan> <Zz2YrA740TRgl_13@codewreck.org> <eaf6cfe58733416c928a8ff0d1d1b1ec@kumkeo.de>
 <202411201000.F3313C02@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 20 Nov 2024, Kees Cook wrote:

> > >> Interestigly there is another report in Debian which identifies the
> > >> backport of upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d
> > >> to cause issues in the 6.1.y series:
> > >>
> > >> https://bugs.debian.org/1085762
> > >>  https://lore.kernel.org/regressions/18f34d636390454180240e6a61af9217@kumkeo.de/T/#u
> > 
> > >Thanks for the heads up!
> > 
> > >This would appear to be the same bug (running qemu-aarch64 in user mode
> > >on an x86 machine) ?
> > >I've added Ulrich in recipients to confirm he's using qemu-user-static
> > >like I was.
> > 
> > pbuilder uses qemu inside the ARM64 chroot, yes. I don't know which variety of qemu, though.
> > 
> > >Shame I didn't notice all his work, that would have saved me some
> > >time :)
> > 
> > Well, at least we now have confirmation from two different git bisects done by
> > two different developers, pointing to the same commit ;-)
> 
> It seems like the correct first step is to revert the brk change. It's
> still not clear to me why the change is causing a problem -- I assume it
> is colliding with some other program area.
> 
> Is the problem strictly with qemu-user-static? (i.e. it was GCC running
> in qemu-user-static so the crash is qemu, not GCC) That should help me
> narrow down the issue. There must be some built-in assumption. And it's
> aarch64 within x86_64 where it happens (is the program within qemu also
> aarch64 or is it arm32)?
> 
> Is there an simple reproducer?

Also seeing /proc/<pid>/maps from a working case (without the patch) might 
give some clue.

Thanks,

-- 
Jiri Kosina
SUSE Labs

