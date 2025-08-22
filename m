Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E3C2FB61A;
	Fri, 22 Aug 2025 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866123; cv=none; b=jAVvNysjM/q0+5L5gwkhN/8DvF9XNRaIGCJJIyN/CkNXJ1PTZ0VijW6eSlMCTvW4fkV6h2CG5Cguo/O8IXjg2wp9BzBHPj8Q+hPlNMI5ehMI6UM66fMFK3b9QS92bHRU1NyITYvib3q1gx1VnjcCpLs9G3uInkulwZ2LpbWUoQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866123; c=relaxed/simple;
	bh=QFpVs+JtR54ukkLsAfaVc1s/kJsduXsF07xuMTGlmmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PsyqBvcpZ5cjs8FJtE4kQ+v4n2bOR9ua0ncUbmobEVkFICirBS/5mw0UidN6IloMQW77wwb9hqSDhB8EYaOWyU3n8GYGoba1xH/GfrWiuARLUhU9VqX+h3U/bj52H66bqJVjRINMXXRosCvu3MRu7PfRp1zfwhpj6mT8M+NV5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2A7D643848;
	Fri, 22 Aug 2025 12:35:16 +0000 (UTC)
Message-ID: <c09fa979-e853-44b7-9287-0c4b71cb1073@ghiti.fr>
Date: Fri, 22 Aug 2025 14:35:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] riscv: Unconditionally use linker relaxation
To: Nathan Chancellor <nathan@kernel.org>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-8-635f3294e5f0@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-8-635f3294e5f0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieefjeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeehiefhuddtuddukeetkeehhedtffduhfevfeeftdefveffgfeuffejjeejfeekueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeektddrvddugedrvdduuddrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeektddrvddugedrvdduuddrvddtuddphhgvlhhopegludelvddrudeikedrkedtrddufeefngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghrnhgusegrrhhnuggsrdguvgdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhhitghkrdguvghsrghulhhnihgvrhhsodhlkhhmlhesghhmrghilhdrtghom
 hdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtghomhdprhgtphhtthhopehjuhhsthhinhhsthhithhtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehllhhvmheslhhishhtshdrlhhinhhugidruggvvh
X-GND-Sasl: alex@ghiti.fr


On 8/21/25 23:15, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, CONFIG_RISCV_USE_LINKER_RELAXATION will
> always be enabled, so it can be removed.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: linux-riscv@lists.infradead.org
> ---
>   arch/riscv/Kconfig  | 6 ------
>   arch/riscv/Makefile | 9 +--------
>   2 files changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 1d53bf02d0fa..d482236e93f4 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -246,15 +246,9 @@ config HAVE_SHADOW_CALL_STACK
>   	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
>   	depends on $(ld-option,--no-relax-gp)
>   
> -config RISCV_USE_LINKER_RELAXATION
> -	def_bool y
> -	# https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
> -	depends on !LD_IS_LLD || LLD_VERSION >= 150000
> -
>   # https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
>   config ARCH_HAS_BROKEN_DWARF5
>   	def_bool y
> -	depends on RISCV_USE_LINKER_RELAXATION
>   	# https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a
>   	depends on AS_IS_LLVM && AS_VERSION < 180000
>   	# https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index df57654a615e..ecf2fcce2d92 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -46,17 +46,10 @@ else
>   	KBUILD_LDFLAGS += -melf32lriscv
>   endif
>   
> -ifndef CONFIG_RISCV_USE_LINKER_RELAXATION
> -	KBUILD_CFLAGS += -mno-relax
> -	KBUILD_AFLAGS += -mno-relax
> -ifndef CONFIG_AS_IS_LLVM
> -	KBUILD_CFLAGS += -Wa,-mno-relax
> -	KBUILD_AFLAGS += -Wa,-mno-relax
> -endif
>   # LLVM has an issue with target-features and LTO: https://github.com/llvm/llvm-project/issues/59350
>   # Ensure it is aware of linker relaxation with LTO, otherwise relocations may
>   # be incorrect: https://github.com/llvm/llvm-project/issues/65090
> -else ifeq ($(CONFIG_LTO_CLANG),y)
> +ifeq ($(CONFIG_LTO_CLANG),y)
>   	KBUILD_LDFLAGS += -mllvm -mattr=+c -mllvm -mattr=+relax
>   endif
>   
>

Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex

