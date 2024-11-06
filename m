Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0880D207A0D;
	Wed,  6 Nov 2024 18:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730917852; cv=none; b=KztjpV9oFONbPb8CbAvG996iRYcSItve6+ubRCdlWNAc0xkNp3g13rEmUHQMVPlU9jpv8AYi7kDhJR0mtSugOeQtY9Qpr52pjRWZUjvDeDVfyU9VjiI+ywAwpTbtMDcQIHrf529k2v1W4Fc+/kXq7mTa597zl+L7NxS4tnQGEEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730917852; c=relaxed/simple;
	bh=3UKvbNKM++MFOTeqBmPjKQZJQ3wWqu7GOsv8HpfD4xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/xPvGFIb0fygUm0CUuh1T8Bu32Lccz42LEBen3TE8KsHMD7LUNK1p6jpBAcLQumAT3gsU5tI2aJKA/a3o9A0rqrAzwSgX/P/c6OLKJ8FVCY7z6rRDcLjvYl7JYQ7TWHKP2HajA8C8IUxt9zTA6p/+UEhdALlrGDU8mbApRS3fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 4A6ITW0E024009;
	Wed, 6 Nov 2024 12:29:32 -0600
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 4A6ITVEL024004;
	Wed, 6 Nov 2024 12:29:31 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Wed, 6 Nov 2024 12:29:31 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
Message-ID: <20241106182931.GI29862@gate.crashing.org>
References: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org> <884cf694-09c7-4082-a6b1-6de987025bf8@csgroup.eu> <20241106133752.GG29862@gate.crashing.org> <20241106152114.GA2738371@thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106152114.GA2738371@thelio-3990X>
User-Agent: Mutt/1.4.2.3i

Hi!

On Wed, Nov 06, 2024 at 08:21:14AM -0700, Nathan Chancellor wrote:
> > (r2 is the default for -m32, r13 is the default for -m64, it appears
> > that clang does not implement this option at all, it simply checks if
> > you set the default, and explodes if not).
> 
> Not sure that I would say it has not been implemented correctly, more
> that it has not been implemented in the same manner as GCC. Keith chose
> not to open up support for arbitrary registers to keep the
> implementation of this option in LLVM simple:

LLVM claims to be compatible to GCC.  It is not.  This is a bug.  As it
is, LLVM can not be used to compile the PowerPC kernel.

These flags (-mstack-protector-guard-{reg,offset}=) are there
*specifically* so that the user can choose to use something different
from the default.  I added this (back in 2017) because the kernel needed
it.  Some other GCC ports (aarch64, arm, riscv, x86) have followed suit
since then, btw.


Segher
