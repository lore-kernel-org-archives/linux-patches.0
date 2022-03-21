Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5443757D0
	for <patches@lists.linux.dev>; Mon, 21 Mar 2022 15:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9506BC340E8;
	Mon, 21 Mar 2022 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1647877110;
	bh=AAdpnVEknkWslKv2VF+ut5MhEmYpqPzuJnQ50fQubi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBAxaZjSDYRLVRi3cIueBwjnryoukQNb6SDI18aHvXTt0lWlsi4m64R0fA5gZ60IO
	 /OK6DjmXhFnK3ApBKyaFlu0c0022qHN+12ApJ6TnaZ4QUWbZexJ03iE2QUw0qDFuaq
	 eSs7BPcZKhMaDUWnD5cL3jN9NTmLKNsIi6aFcw09LFVhBvnBFjEeVryn4NsT/0w5rm
	 cv6hydXIA0+HDwkKXgNQUiXxsEGsNaw39cXsSkow4DWIgxhtevUsqvaVCQYy8Ifz+/
	 QdX+kCnZijV8whpFC6ZpyRwSbPQfjn8wxS8DQiTERti+/E9iD+64IPh2cQhqk3Q8Yh
	 UViCMMasvXHYQ==
Date: Mon, 21 Mar 2022 08:38:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next] sched/headers: ARM needs asm/paravirt_api_clock.h
Message-ID: <Yjib7hDFRFEOwaWf@dev-arch.thelio-3990X>
References: <20220316204146.14000-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316204146.14000-1-rdunlap@infradead.org>

On Wed, Mar 16, 2022 at 01:41:46PM -0700, Randy Dunlap wrote:
> Add <asm/paravirt_api_clock.h> for arch/arm/.
> 
> Fixes this build error:
> 
> In file included from ../kernel/sched/core.c:81:
> ../kernel/sched/sched.h:87:11: fatal error: asm/paravirt_api_clock.h: No such file or directory
>    87 | # include <asm/paravirt_api_clock.h>
> 
> Fixes: 4ff8f2ca6ccd ("sched/headers: Reorganize, clean up and optimize kernel/sched/sched.h dependencies")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: patches@armlinux.org.uk

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

This needs to go into -tip to avoid breaking the build for ARM
all{mod,yes}config. It looks like the pull has already been sent though
:/

> ---
> KernelVersion: linux-next-20220316
> 
>  arch/arm/include/asm/paravirt_api_clock.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- /dev/null
> +++ linux-next-20220316/arch/arm/include/asm/paravirt_api_clock.h
> @@ -0,0 +1 @@
> +#include <asm/paravirt.h>
> 
