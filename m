Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1BF31CA72;
	Wed, 20 Aug 2025 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706271; cv=none; b=lqJVy16j/M4ndx1UopZpIWngbkecc9R5YjTLXYp9Fh9oQ7cW7CRgQ2UMQCmVIUteQPn1+1PFkuyjIVoLRUpX9qomOhH0XWs30lQ6jhxc7GTv75cgCDDvIOwoiu7HdYERSxAgQV93xj1oiSP9U59D/f03hAyC//MrKJJTbZUyQ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706271; c=relaxed/simple;
	bh=kILSVk3z9gI+nFGfR1y5ThbvAl+I3YUQHPIyOglHZhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyUvmYG+2VtyVKNMK6quHRw1/8G+FnZCh8Z/dEZdIAU6TP9BQ6exQmtO8+LLWy/wj7A1L8ZUtBMo7E/qYIQDSkSOkxYRzDLtGUpVVrE4qnSWx6K0obcp9G5SS9w7l563X1ONNRHUcNnX3lekWr1QYofnYMCrHq4a7hNOkufXqeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7AiuSJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7AiuSJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAE9C4CEE7;
	Wed, 20 Aug 2025 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755706269;
	bh=kILSVk3z9gI+nFGfR1y5ThbvAl+I3YUQHPIyOglHZhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7AiuSJHOQJiqlv8uD9FBGgeBFTKKvDcdvlq6x5IWBb0UlDJhj+vzIHW/5y2C3mn6
	 EyOvm0QWPGDdv2EW8cRjyzcyD0YIaDSKiOoS/OZIECJflmbbpbAeo/6IVCY0xapsMn
	 xU41tdoZvlQ2Q9Z99eMMr1zm74Lzh3miB8pgDLoWG070z2+enR8ycjy08wLrLSKtWD
	 PJX2zlPNEpbf2O3ScCCW9wHsY78289YB9c1goxC9QoKdK5bRz+xkbOgKLNnKs3LRvN
	 QqDp8MrA5hLfpCzIRhOWuoFtUa9uQHSZBwc0aU3WDoqI+4lNUBmWcDbmqZ5o4u68pc
	 eel+KA9tJ81xQ==
Date: Wed, 20 Aug 2025 09:11:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 07/10] riscv: Remove version check for LTO_CLANG selects
Message-ID: <20250820161104.GA3805667@ax162>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
 <20250818-bump-min-llvm-ver-15-v1-7-c8b1d0f955e0@kernel.org>
 <8078e385-e08e-40a5-b6df-31c0b5be8f43@ghiti.fr>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8078e385-e08e-40a5-b6df-31c0b5be8f43@ghiti.fr>

On Wed, Aug 20, 2025 at 09:23:08AM +0200, Alexandre Ghiti wrote:
> Hi Nathan,
> 
> On 8/18/25 20:57, Nathan Chancellor wrote:
> > Now that the minimum supported version of LLVM for building the kernel
> > has been bumped to 15.0.0, there is no need to check the LLD version
> > before selecting ARCH_SUPPORTS_LTO_CLANG{,_THIN} because it will always
> > be true.
> > 
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > Cc: Palmer Dabbelt <palmer@dabbelt.com>
> > Cc: Alexandre Ghiti <alex@ghiti.fr>
> > Cc: linux-riscv@lists.infradead.org
> > 
> > Small note, this will conflict with
> > https://lore.kernel.org/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org/
> > but I think it is simple enough to deal with.
> 
> FYI, I'll send this patch for some 6.17-rcX.

Thanks, that would help.

> I found another bunch of LLD_VERSION check in this file that could be
> removed:

Huh, I am very surprised that I missed those :/ thanks a lot for
catching that!

> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L253

I have added a patch removing CONFIG_RISCV_USE_LINKER_RELAXATION.

> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L262

I don't think this one can be currently cleaned up since it won't always
be either true or false.

> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L630
> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L731
> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L746
> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L781
> https://elixir.bootlin.com/linux/v6.17-rc2/source/arch/riscv/Kconfig#L804

I have added a patch converting those version checks to just LD_IS_LLD.

Cheers,
Nathan
