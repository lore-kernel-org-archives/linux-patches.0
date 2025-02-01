Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3BD35953;
	Sat,  1 Feb 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738424069; cv=none; b=XOxq2F6CHdmmQDQ9r8Q34caOZg3NEIMPYNxuLtN+oZ7yito7+vNWpa4Pz1UtBi8BsDAs3LtdfXGjqaLquZxcnojf0uG9t+D4Bj/ab8D4G7pG1OIsrWKOrCDwCGW1EhTqiCWgV8o0dw1Q9VXTIX6yz8Vg0JchBlFHAXNaOfHtLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738424069; c=relaxed/simple;
	bh=EP9LgQDEBEPzU128nXmG9kkyyfypu4TcWapUThglgXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bwu2EfNp4ggTaUOhsmSTyJZ79y4RSETBvZmYfLQOYu1uUjI3uqKu39Lmmw4+HFVeKIwMHxue/vZNJGxsLiOC/Fo7ZoLpmWXKskYzc51VQ8zmTDEU7SQ7VRJwR3so2bH6gzFn7JljPd6v8EwvFA1xsHZIRTZvoNwH7aNz8Yk6D/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Twa+NZ+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Twa+NZ+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D3C4CED3;
	Sat,  1 Feb 2025 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738424068;
	bh=EP9LgQDEBEPzU128nXmG9kkyyfypu4TcWapUThglgXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Twa+NZ+Tx3MJzP2dhuqTwYgsVzjdkJ1zRCSefCk7KZWcPD7xq0HPnwHtE3Rt7cooQ
	 9mfe2dZP14W9IC0IEiJv46u3Dh8swoWdpI4Nurt74LE7ty85oP6NET68b0C/VGQmDg
	 pBsCxH094f7Lc8jgtbWXPqpRhVbEN9UMnCLkrMzE=
Date: Sat, 1 Feb 2025 16:34:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
Message-ID: <2025020108-shape-clapped-305c@gregkh>
References: <20250131112114.030356568@linuxfoundation.org>
 <Z5zIZHIZxuHoymof@duo.ucw.cz>
 <2025020157-unsecured-map-aa0c@gregkh>
 <cb1e9306-9c05-4a7e-914b-d5127a411ebe@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb1e9306-9c05-4a7e-914b-d5127a411ebe@roeck-us.net>

On Sat, Feb 01, 2025 at 07:03:33AM -0800, Guenter Roeck wrote:
> On 2/1/25 00:01, Greg Kroah-Hartman wrote:
> ...
> > Anyway, are you all really caring about riscv on a 5.4.y kernel?  Last I
> > checked, the riscv maintainers said not to even use that kernel for that
> > architecture.  Do you all have real boards that care about this kernel
> > tree that you are insisting on keeping alive?  Why not move them to a
> > newer LTS kernel?
> > 
> 
> Looking into the 5.4 release candidate, I see:
> 
> $ git log --oneline v5.4.289.. arch/riscv/
> 98d26e0254ff RISC-V: Don't enable all interrupts in trap_init()
> 574c5efceb70 riscv: prefix IRQ_ macro names with an RV_ namespace
> c57ffe372502 riscv: Fix sleeping in invalid context in die()
> 98c62ee8bc75 riscv: Avoid enabling interrupts in die()
> 88cb873873ff RISC-V: Avoid dereferening NULL regs in die()
> 2a83ad25311e riscv: remove unused handle_exception symbol
> 8652d51931cc riscv: abstract out CSR names for supervisor vs machine mode

I've dropped them all now, as that is what was causing the build
problems.

> Why do you backport riscv patches to 5.4.y if you think they should not be
> tested ? Shouldn't your question imply that there won't be any further
> backports into 5.4.y for architecture(s) which are no longer supported
> in that branch ?

I'm not implying they are not to be tested, it's just a real "is this
something that people actually care about" question.  Last time we had
riscv problems in this branch the riscv maintainers said "don't worry
about it".  I didn't notice that Sasha had queued these up here,
otherwise I would have probably just dropped them then like I did right
now :)

thanks,

greg k-h
