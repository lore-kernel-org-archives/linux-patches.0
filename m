Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DC77F5;
	Wed,  5 Apr 2023 09:15:27 +0000 (UTC)
Received: from uucp (helo=alpha)
	by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
	id 1pjyVe-0007pG-01; Wed, 05 Apr 2023 10:28:50 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id D9339C2160; Wed,  5 Apr 2023 10:26:25 +0200 (CEST)
Date: Wed, 5 Apr 2023 10:26:25 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, linux-mips@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] MIPS: Drop unused positional parameter in
 local_irq_{dis,en}able
Message-ID: <20230405082625.GB5556@alpha.franken.de>
References: <20230404-mips-unused-named-parameters-v1-1-71d6c656f1de@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404-mips-unused-named-parameters-v1-1-71d6c656f1de@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Apr 04, 2023 at 02:18:41PM -0700, Nathan Chancellor wrote:
> When building with clang's integrated assembler, it points out that the
> CONFIG_CPU_HAS_DIEI versions of local_irq_enable and local_irq_disable
> have a named parameter that is not used in the body of the macro and it
> thinks that $8 is a positional parameter, rather than a register:
> 
>   arch/mips/include/asm/asmmacro.h:48:2: warning: macro defined with named parameters which are not used in macro body, possible positional parameter found in body which will have no effect
>    .macro local_irq_enable reg=$8
>    ^
> 
> The comment above the function that performs this check in LLVM notes
> that the warning may trigger in this case, even though it is not
> problematic. It is easy enough to clean this up by just omitting the
> named parameter for this version of the macro, as it is entirely unused.
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1415
> Link: https://github.com/llvm/llvm-project/commit/81c944cadb7f9e55b3517b7423a820e2577b9279
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/mips/include/asm/asmmacro.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
