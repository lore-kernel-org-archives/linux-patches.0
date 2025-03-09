Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61376ECF;
	Sun,  9 Mar 2025 09:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741512471; cv=none; b=mKoMIvPRNaGHsuZlaC5su6P1ygnY5ZSjbb5voppBdYJgRvpGMqwVf4H2QZQSpMCpi/4Eptdki6Rv9oeJXxOqz4bSIvIaSbHCNMB76o+noy0Vlm0uUYFcs0tqeDtTo8Z1hGiuWJKKTFIwQBnc1V/l6DU3nb6WFcIKk+o6oX6cra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741512471; c=relaxed/simple;
	bh=iIZxroa4u4ehd4+mCTaqXpZgoTcRYMgH0lLH4b1yMws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pz0+P+v+8aUnL7vNTVAt2Ze+XF559F/l8mvAFfsI1cvg8vcQcnDNG/QWwZe7W2Q/MKxIZvdrEHcuwFZWBX5r8RAqUOiA+c9KdRPBpUvHyaFD6rxui445AQ4jLzmJ9puNPiawx9B+aFL6pIV93K5BLr4qIZogMQqKDPszIJqXbgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkC6ZBV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkC6ZBV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FF8C4CEE5;
	Sun,  9 Mar 2025 09:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741512470;
	bh=iIZxroa4u4ehd4+mCTaqXpZgoTcRYMgH0lLH4b1yMws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tkC6ZBV3jzmt5WQRVfHrOPA6IWVBEw8zyaHH0t7WI11LbLLhMfrtsoPUcf/NGyC9q
	 +Dq/GshnfXbZWHZ8L9wJ+GtG7YyoPUzIxs5M03oqoTwnxAf+9Mv/Uk1DNX0AduSxyf
	 rzHzEfOmUG3s7a0SMmSzV9XEQ3ijzbePHWAUuz1w=
Date: Sun, 9 Mar 2025 10:26:34 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 070/157] objtool: Remove annotate_{,un}reachable()
Message-ID: <2025030903-juiciness-gusto-ad85@gregkh>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174508.115393593@linuxfoundation.org>
 <20250307212625.GA2700602@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307212625.GA2700602@ax162>

On Fri, Mar 07, 2025 at 10:26:25PM +0100, Nathan Chancellor wrote:
> On Wed, Mar 05, 2025 at 06:48:26PM +0100, Greg Kroah-Hartman wrote:
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > [ Upstream commit 06e24745985c8dd0da18337503afcf2f2fdbdff1 ]
> > 
> > There are no users of annotate_reachable() left.
> 
> This is not true in 6.13.y because it was taken without upstream commit
> 624bde3465f6 ("loongarch: Use ASM_REACHABLE"), resulting in:
> 
>   In file included from include/linux/bug.h:5,
>                    from include/linux/thread_info.h:13,
>                    from include/asm-generic/current.h:6,
>                    from ./arch/loongarch/include/generated/asm/current.h:1,
>                    from include/linux/sched.h:12,
>                    from arch/loongarch/kernel/asm-offsets.c:8:
>   include/linux/thread_info.h: In function 'check_copy_size':
>   arch/loongarch/include/asm/bug.h:47:9: error: implicit declaration of function 'annotate_reachable' [-Wimplicit-function-declaration]
>      47 |         annotate_reachable();                                   \
>         |         ^~~~~~~~~~~~~~~~~~
>   include/asm-generic/bug.h:113:17: note: in expansion of macro '__WARN_FLAGS'
>     113 |                 __WARN_FLAGS(BUGFLAG_ONCE |                     \
>         |                 ^~~~~~~~~~~~
>   include/linux/thread_info.h:262:13: note: in expansion of macro 'WARN_ON_ONCE'
>     262 |         if (WARN_ON_ONCE(bytes > INT_MAX))
>         |             ^~~~~~~~~~~~
> 
> when trying to build ARCH=loongarch now. That applies cleanly and
> resolves the build failure.
> 
> > And the annotate_unreachable() usage in unreachable() is plain wrong;
> > it will hide dangerous fall-through code-gen.
> 
> This may be reason enough to take this patch into stable... (but then
> why wasn't it Cc'd in the first place, the tip folks are usually good
> about that?)
> 
> > Remove both.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Link: https://lore.kernel.org/r/20241128094312.235637588@infradead.org
> > Stable-dep-of: 73cfc53cc3b6 ("objtool: Fix C jump table annotations for Clang")
> 
> But I do not think avoiding the conflict generated by this patch is...
> With the "diff3" merge.conflictstyle setting in git, I only see this
> conflict in that change:
> 
>   /* Annotate a C jump table to allow objtool to follow the code flow */
>   <<<<<<< HEAD
>   #define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
> 
>   ||||||| parent of 73cfc53cc3b6 (objtool: Fix C jump table annotations for Clang)
>   #define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
>   =======
>   #define __annotate_jump_table __section(".data.rel.ro.c_jump_table")
>   >>>>>>> 73cfc53cc3b6 (objtool: Fix C jump table annotations for Clang)
> 
> which seems incredibly simple to resolve without dragging in two extra
> patches.
> 
> If we do want to keep this change in 6.13.y, maybe it would be worth
> dragging in
> 
>   2190966fbc14 ("x86: Convert unreachable() to BUG()")
>   41a1e976623e ("x86/mm: Convert unreachable() to BUG()")
> 
> as well?

Both are already in the release, thanks!

greg k-h
