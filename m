Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE80D78F58;
	Fri, 22 Aug 2025 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755865898; cv=none; b=O9jY55fM7qMhuZUUQLq1GlWsY10tlCiAA4q0pI+xwnOEy3CCuBoKh7AUsG9e+GJCE2dTJD9ktOfOowd9sNfDkck3IsQUNWjMxcVgOH6Auo6sLsY4d07yxtl4yDUp5j5uqSOQ9g5pVqusLO20jq+6s+qcdaN2owopY52FLvauUnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755865898; c=relaxed/simple;
	bh=qx54DOZwJcW1DwrPVQ8wdvxgjU80EshHX0N/LfUyGvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlOhs8CHQHxN2GLWIMxorCU/Xi/II3AM7SWb2sdTo9nwe7UQ8bRjrgv6HafRBqwq1FFJOCbre1S53tv/VCKBsLplLMC8LN7d5mvzPer0HWWZFIjiVSfcatbyiutRhZsO86jFevf4Jm/RNWh1WM8/04Dq/7F5pARYURJTbE8OuIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4DA2143853;
	Fri, 22 Aug 2025 12:31:23 +0000 (UTC)
Message-ID: <a18c8301-31da-4ceb-b5c6-6be5e5eca6d5@ghiti.fr>
Date: Fri, 22 Aug 2025 14:31:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] riscv: Remove version check for LTO_CLANG
 selects
To: Nathan Chancellor <nathan@kernel.org>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-7-635f3294e5f0@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-7-635f3294e5f0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieefjeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpeehgfefvdekveffheeggfduveevkeekhefgfeffteduieevveelgfeitdehjeefveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucfkphepkedtrddvudegrddvuddurddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepkedtrddvudegrddvuddurddvtddupdhhvghloheplgduledvrdduieekrdektddrudeffegnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepuddupdhrtghpthhtohepnhgrthhhrghnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhhnugesrghrnhgusgdruggvpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehnihgtkhdruggvshgruhhlnhhivghrshdolhhkm
 hhlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhmpdhrtghpthhtohepjhhushhtihhnshhtihhtthesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhlvhhmsehlihhsthhsrdhlihhnuhigrdguvghv
X-GND-Sasl: alex@ghiti.fr

Hi Nathan,

On 8/21/25 23:15, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, there is no need to check the LLD version
> before selecting ARCH_SUPPORTS_LTO_CLANG{,_THIN} because it will always
> be true.
>
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: linux-riscv@lists.infradead.org
>
> Small note, this will conflict with
> https://lore.kernel.org/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org/
> but I think it is simple enough to deal with.
> ---
>   arch/riscv/Kconfig | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index a4b233a0659e..1d53bf02d0fa 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -64,9 +64,8 @@ config RISCV
>   	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
>   	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>   	select ARCH_SUPPORTS_HUGETLBFS if MMU
> -	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
> -	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
> -	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
> +	select ARCH_SUPPORTS_LTO_CLANG
> +	select ARCH_SUPPORTS_LTO_CLANG_THIN
>   	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
>   	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
>   	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>

Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex

