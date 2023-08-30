Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143046BD;
	Wed, 30 Aug 2023 13:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0191DC43142;
	Wed, 30 Aug 2023 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693401635;
	bh=KzwJRFCBiaAVTS0ZoB4zQT8L/wyozk8i7uO2fyuq0gc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sLYgIWC03UyP+2MVxVmpI51YEVIhuWcMENrYJjYx523pfTx/AXlQmbOaYPeNkYYiw
	 U/1gCBRvdDdqF9hWU/oI72hmkTdORtk1rLC235U4Enw7h3kb0CbMBthE/oXJ5YP8Lc
	 YEpPyfN69zAZuGnGMGzdSpeu8Kn1weeWxUOAsABQxhHDi+w/wxL5+ucklGjQnWNvA5
	 m8VDdzLAgoryT4fyZUllUB7drwD/btzX2A59iOWCe8UEFQXnMxvw2uYMiR4qdCxtVU
	 6LiQKU3T6NT+CscAHOn65TiTZk7WisBvSTbVe+Wu57/BnqYWOc8Wo0XyIF83S7NEFC
	 s+5CDZENrInbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3363E4509F;
	Wed, 30 Aug 2023 13:20:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <169340163492.19859.13643349679698398127.git-patchwork-notify@kernel.org>
Date: Wed, 30 Aug 2023 13:20:34 +0000
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
In-Reply-To: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, akpm@linux-foundation.org,
 conor@kernel.org, ndesaulniers@google.com, trix@redhat.com,
 llvm@lists.linux.dev, patches@lists.linux.dev, lkp@intel.com

Hello:

This patch was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Wed, 16 Aug 2023 10:35:43 -0700 you wrote:
> When building for ARCH=riscv using LLVM < 14, there is an error with
> CONFIG_DEBUG_INFO_SPLIT=y:
> 
>   error: A dwo section may not contain relocations
> 
> This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> '-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> with newer versions of LLVM:
> 
> [...]

Here is the summary with links:
  - lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
    https://git.kernel.org/riscv/c/9fa9a5f2714d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


