Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372451E515;
	Wed, 20 Nov 2024 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732126088; cv=none; b=bBsIkoctn5xzTzfPdY/mArVimYH9I6A6WhliLv6EyisODd171ohXDDIFYf9Z1XyymGEbdQ/YKXZ82pZSO8J9vY2ndi3qSoXDeKQwP/dytesYIXful/d4Y7Dr6AAkxkfanJiTtXcEtpC1dBwM5xoPLIk0fN9ltXYAm1Eoh652z9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732126088; c=relaxed/simple;
	bh=iw4r2EmtAHn3UqWFDYild7FKS/PWFaWAo+7bl1fIHLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ngk+X3xD3AiexuSyZPZ2qgy/sNnMXAZyy97n+SRN2oj1wap3iePAw+Pjc9HtvxmNC8R1pfbEmE0SYTeT6IQsCEtH0zna5S5UbIbpmK3o32k+QSJZVwU5mZT9pYKBBaOzevyzyzejRuoT76L3al/bgqKxP/NZjYn4rM3+aN2kJTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wjlj2Y6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wjlj2Y6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1244C4CECD;
	Wed, 20 Nov 2024 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732126087;
	bh=iw4r2EmtAHn3UqWFDYild7FKS/PWFaWAo+7bl1fIHLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wjlj2Y6XW+W1AF4Re2Pcf/c3nVekBknddgTDYKMluMnJk900cJYYNwPkWxkG/I5+O
	 c6bCy9PYciOjWgUYwdJtisArGuM6OoPqFU57EB4LXCzJlRRSzSHPlobNsA9tgEaHaa
	 9E9+/HLdNaJOE8Mx0F7Nk1A2xVRQfOj/309T3TCS2Cj0aPRyS9VmCFID5c9xBgOu4Q
	 Q9A/yI5n1Hi3bSLpEnCsb5QN2ThoW8X5QWTE6F7QNhc7usNhcRgvZp8hars+98G1A7
	 GE41igKuHD4B+AHJbvqTz8zVcCCHkijO8Um2QkqAXVmyX1XPlSupGBaw3rcZmyIrSO
	 2uhq2WHXDVYCg==
Date: Wed, 20 Nov 2024 10:08:04 -0800
From: Kees Cook <kees@kernel.org>
To: Ulrich Teichert <ulrich.teichert@kumkeo.de>
Cc: Dominique Martinet <asmadeus@codewreck.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"y0un9n132@gmail.com" <y0un9n132@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Message-ID: <202411201000.F3313C02@keescook>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
 <Zz0_-iJH1WaR3BUZ@codewreck.org>
 <Zz2JQzi-5pTP_WPx@eldamar.lan>
 <Zz2YrA740TRgl_13@codewreck.org>
 <eaf6cfe58733416c928a8ff0d1d1b1ec@kumkeo.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf6cfe58733416c928a8ff0d1d1b1ec@kumkeo.de>

On Wed, Nov 20, 2024 at 08:25:57AM +0000, Ulrich Teichert wrote:
> Hi Dominique & all,
> 
> >Salvatore Bonaccorso wrote on Wed, Nov 20, 2024 at 08:01:23AM +0100:
> >> Interestigly there is another report in Debian which identifies the
> >> backport of upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d
> >> to cause issues in the 6.1.y series:
> >>
> >> https://bugs.debian.org/1085762
> >>  https://lore.kernel.org/regressions/18f34d636390454180240e6a61af9217@kumkeo.de/T/#u
> 
> >Thanks for the heads up!
> 
> >This would appear to be the same bug (running qemu-aarch64 in user mode
> >on an x86 machine) ?
> >I've added Ulrich in recipients to confirm he's using qemu-user-static
> >like I was.
> 
> pbuilder uses qemu inside the ARM64 chroot, yes. I don't know which variety of qemu, though.
> 
> >Shame I didn't notice all his work, that would have saved me some
> >time :)
> 
> Well, at least we now have confirmation from two different git bisects done by
> two different developers, pointing to the same commit ;-)

It seems like the correct first step is to revert the brk change. It's
still not clear to me why the change is causing a problem -- I assume it
is colliding with some other program area.

Is the problem strictly with qemu-user-static? (i.e. it was GCC running
in qemu-user-static so the crash is qemu, not GCC) That should help me
narrow down the issue. There must be some built-in assumption. And it's
aarch64 within x86_64 where it happens (is the program within qemu also
aarch64 or is it arm32)?

Is there an simple reproducer?

-Kees

-- 
Kees Cook
