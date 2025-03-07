Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28FF1519A3;
	Fri,  7 Mar 2025 21:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382790; cv=none; b=KxbNjFDO9N/aAU5eZMH9Plf9JjF/LmqWpX97svc0o5wZ+23RjfMx1Ldiq9/Fa8bTPzLNw8v9r5JxK7QNY55T+KHwi8rsAXI/O6qWcltF0Qjz9bsn7wN0XYEIx/xlPEN0UaSI2jira4YG4kYMc5zlrwBBziBthlR4z2fseJQSi60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382790; c=relaxed/simple;
	bh=AghlRP1hPF0PIFr70gnDNCaE0UGvZVqXErTE3N+ofkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chCLQWMMp6h5ZoXyOr/SenX2eL7Eomx0npJOYcyLPulZfYs9eQpvbHDO1k8lgTUcF9UUW45uOmrnTWDi9UE74/bhmun+RZGpCEv5hMsDKbuwgso3HReUatd6yc98X6maqJdWY/xrVbq8PWDE4I1AblXEQ3XRNqILCbG4BUVZtuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyGoDuq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyGoDuq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FF3C4CED1;
	Fri,  7 Mar 2025 21:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741382790;
	bh=AghlRP1hPF0PIFr70gnDNCaE0UGvZVqXErTE3N+ofkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UyGoDuq7blr4CbjrzwcocsNg3cbCgzPe/h6/sWLQBBwHg5hb/klDiJPG2/DYYULBt
	 M8M3Yee7g6NdfMHXaUFFe/WIL/FXeVS+zsoiSUZhJ2zQ9grcoQJCMlelKtNb5y+N5j
	 GYrkWaduYOTKEFLVUYYVDACzHkp/I3Yg/QefBNxjrvGQQLdwGzF0doArDgb+EXdfrx
	 070m0iCwdrRG47ZWvcYKyCmGH71Fsl4ieo6o65qeMVGSDvorF5vpdERsB/lKs6oH1/
	 wGSUlkvw14FrRsjT2s+ip82aHV+YyfhZxAs6s2urhZqL0SqsamOD5tjPKa7vS9tI0N
	 P0TQnUOID1m1w==
Date: Fri, 7 Mar 2025 22:26:25 +0100
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 070/157] objtool: Remove annotate_{,un}reachable()
Message-ID: <20250307212625.GA2700602@ax162>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174508.115393593@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305174508.115393593@linuxfoundation.org>

On Wed, Mar 05, 2025 at 06:48:26PM +0100, Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Peter Zijlstra <peterz@infradead.org>
> 
> [ Upstream commit 06e24745985c8dd0da18337503afcf2f2fdbdff1 ]
> 
> There are no users of annotate_reachable() left.

This is not true in 6.13.y because it was taken without upstream commit
624bde3465f6 ("loongarch: Use ASM_REACHABLE"), resulting in:

  In file included from include/linux/bug.h:5,
                   from include/linux/thread_info.h:13,
                   from include/asm-generic/current.h:6,
                   from ./arch/loongarch/include/generated/asm/current.h:1,
                   from include/linux/sched.h:12,
                   from arch/loongarch/kernel/asm-offsets.c:8:
  include/linux/thread_info.h: In function 'check_copy_size':
  arch/loongarch/include/asm/bug.h:47:9: error: implicit declaration of function 'annotate_reachable' [-Wimplicit-function-declaration]
     47 |         annotate_reachable();                                   \
        |         ^~~~~~~~~~~~~~~~~~
  include/asm-generic/bug.h:113:17: note: in expansion of macro '__WARN_FLAGS'
    113 |                 __WARN_FLAGS(BUGFLAG_ONCE |                     \
        |                 ^~~~~~~~~~~~
  include/linux/thread_info.h:262:13: note: in expansion of macro 'WARN_ON_ONCE'
    262 |         if (WARN_ON_ONCE(bytes > INT_MAX))
        |             ^~~~~~~~~~~~

when trying to build ARCH=loongarch now. That applies cleanly and
resolves the build failure.

> And the annotate_unreachable() usage in unreachable() is plain wrong;
> it will hide dangerous fall-through code-gen.

This may be reason enough to take this patch into stable... (but then
why wasn't it Cc'd in the first place, the tip folks are usually good
about that?)

> Remove both.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Link: https://lore.kernel.org/r/20241128094312.235637588@infradead.org
> Stable-dep-of: 73cfc53cc3b6 ("objtool: Fix C jump table annotations for Clang")

But I do not think avoiding the conflict generated by this patch is...
With the "diff3" merge.conflictstyle setting in git, I only see this
conflict in that change:

  /* Annotate a C jump table to allow objtool to follow the code flow */
  <<<<<<< HEAD
  #define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")

  ||||||| parent of 73cfc53cc3b6 (objtool: Fix C jump table annotations for Clang)
  #define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
  =======
  #define __annotate_jump_table __section(".data.rel.ro.c_jump_table")
  >>>>>>> 73cfc53cc3b6 (objtool: Fix C jump table annotations for Clang)

which seems incredibly simple to resolve without dragging in two extra
patches.

If we do want to keep this change in 6.13.y, maybe it would be worth
dragging in

  2190966fbc14 ("x86: Convert unreachable() to BUG()")
  41a1e976623e ("x86/mm: Convert unreachable() to BUG()")

as well?

Cheers,
Nathan
