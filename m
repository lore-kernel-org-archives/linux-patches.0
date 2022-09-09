Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5862E808;
	Fri,  9 Sep 2022 12:10:15 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4MPFDb1sZnz4xZV;
	Fri,  9 Sep 2022 22:10:07 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, kernel test robot <lkp@intel.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Nicholas Piggin <npiggin@gmail.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Arnd Bergmann <arnd@arndb.de>, patches@lists.linux.dev, Tom Rix <trix@redhat.com>
In-Reply-To: <20220831152014.3501664-1-nathan@kernel.org>
References: <20220831152014.3501664-1-nathan@kernel.org>
Subject: Re: [PATCH] powerpc/math_emu/efp: Include module.h
Message-Id: <166272521027.2076816.11203146069625170939.b4-ty@ellerman.id.au>
Date: Fri, 09 Sep 2022 22:06:50 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 31 Aug 2022 08:20:15 -0700, Nathan Chancellor wrote:
> When building with a recent version of clang, there are a couple of
> errors around the call to module_init():
> 
>   arch/powerpc/math-emu/math_efp.c:927:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
>   module_init(spe_mathemu_init);
>   ^
>   int
>   arch/powerpc/math-emu/math_efp.c:927:13: error: a parameter list without types is only allowed in a function definition
>   module_init(spe_mathemu_init);
>               ^
>   2 errors generated.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/math_emu/efp: Include module.h
      https://git.kernel.org/powerpc/c/cfe0d370e0788625ce0df3239aad07a2506c1796

cheers
