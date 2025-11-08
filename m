Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D79288513;
	Sat,  8 Nov 2025 00:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762563099; cv=none; b=cZBdF5HwC330vEwW8rQnR3iDEZRe4xF/mPc3+wQaUWbd28x4B3IPwlozzVQHyK3PzvLBvpjnBCeCzDjSQBocNy3khDUgxyPN+xpuINOEwV1uej9vAlr8UlBXY2zh5W6iEIZm2lE5uRPjvzZXg6WZ+UyU3qYYMx0Ru7lpvXjYhhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762563099; c=relaxed/simple;
	bh=X65BSM7S8OpvSv2313E9aYYD5lZwDf8OKqldRYlKw7M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GU/QwWVPSo3d3SU6eia2a/NJVx4Cw2Rc+SwJiHYdlwMWjlw0yzmWJQvnUZaiU95e6Lxs2vZXwT7X2Npbj9BQYBq8VSDdv8TBCHvTmX5fssynVVPY4YcZ/S6kLah9+OKVSw8ue5lHPEMycBHKDoJ8ReFI91uZ6kMchVpnPwYYr7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fqyfe4fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fqyfe4fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F39C116B1;
	Sat,  8 Nov 2025 00:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762563099;
	bh=X65BSM7S8OpvSv2313E9aYYD5lZwDf8OKqldRYlKw7M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Fqyfe4fmm7PeEVnVCbpwIwdsaGziIAnYGuaQrD2B0AhEIL0L45oiJbi1IE1t/V1I0
	 G1C1a5Ky4KmUQB+3PK6v9IHuM/yppWU4nUmg4/14gVlt84FBATGLfQqZgXoI2eGO5A
	 wMyIULLnPK4ow0J9IbAzg4dTcw/QECb51VgYvycrRUijVNie0fNpmQ9VKtnOUYHqRz
	 wMYFbpUrRmWz8oaosZqbDCMvgR8szfDV9rG3lXL6AWsaQHt9hUTAUv5LAUgHuRXwS1
	 oJPgT2+xFUssTrbvTRnEx7JxFcxpl8dYR3dv8oCyfkaqQOXIieKmQJWHklYtHP9qeu
	 rRijJ+IpVUwZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD5E3A40FC8;
	Sat,  8 Nov 2025 00:51:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH fixes] riscv: Fix CONFIG_AS_HAS_INSN for new .insn usage
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176256307124.1206494.4272115513323337188.git-patchwork-notify@kernel.org>
Date: Sat, 08 Nov 2025 00:51:11 +0000
References: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
In-Reply-To: <20251107-riscv-fix-new-insn-usage-v1-1-9a186c5928a0@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-riscv@lists.infradead.org, pjw@kernel.org, palmer@dabbelt.com,
 alex@ghiti.fr, nick.desaulniers+lkml@gmail.com, morbo@google.com,
 justinstitt@google.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
 llvm@lists.linux.dev, patches@lists.linux.dev

Hello:

This patch was applied to riscv/linux.git (fixes)
by Paul Walmsley <pjw@kernel.org>:

On Fri, 07 Nov 2025 14:56:59 -0700 you wrote:
> After commit 44aa25c000b4 ("riscv: asm: use .insn for making custom
> instructions"), builds using LLVM older that 19 or binutils older than
> 2.38 fail with:
> 
>   arch/riscv/include/asm/vdso/processor.h: Assembler messages:
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   arch/riscv/include/asm/vdso/processor.h:27: Error: unrecognized opcode `0x100000f'
>   make[4]: *** [scripts/Makefile.build:287: arch/riscv/kernel/vdso/vgettimeofday.o] Error 1
> 
> [...]

Here is the summary with links:
  - [fixes] riscv: Fix CONFIG_AS_HAS_INSN for new .insn usage
    https://git.kernel.org/riscv/c/dc20452e6caf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


