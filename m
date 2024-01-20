Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5EC15AC4;
	Sat, 20 Jan 2024 21:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705784996; cv=none; b=BPLRTfF7a+5pC11iKrc+xEj8EMNGVgL0ul5ONKIe/5yYiN51yScCMHhWGYJ+qOF16wUt9Gm+U3CwVczPgHT3ktj+HYpS08JbSGB1Y6ajofssTBActW/ugUcbFzj6HX36F7NqSCDzQVCp/6KSyC/7LAL8Pbimw5hEdgF5ctCrF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705784996; c=relaxed/simple;
	bh=76xbVIXKVqYfEqwY7yDUy2z34YtqsMOfXaiKMr2CblM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GN4i+4nBiqDVERIzx8y+23tdXK6B6xTpII/wSgjO05szB5fEpM1s/LuPyXPG5+Xt3m29AM+CT646EFUDtZaskSIyah244oKN+SQz9t28jgv6UpQFzWa4fiStY7oLMYbZa+Z10AonuDwYNKRCwzzSeSEDrF0eWSzrA3J4QRcJjwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0518Ghq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0518Ghq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3DCEC433C7;
	Sat, 20 Jan 2024 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705784995;
	bh=76xbVIXKVqYfEqwY7yDUy2z34YtqsMOfXaiKMr2CblM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C0518Ghq3hLjoNbFjrLBtjIke3NBfUfZ9GLWsgVrTwvKcrFfE9JOb1kRxhaQBwFHI
	 7SIJNVRICmNlIC9niMIjS8EiEtXKsBXiUwj9K6fkAHyQqJU+JW/jKdlalKpJwA3eRG
	 8hGSYBxE2/dPybOovOilg0emmnET2Asw8/USQBwFFyfGefjGLedazQrYggDN2/yZds
	 eQJtYNO8a3tN7CrRnLACwfCKm3gqDtxJlC3Yrwn3ucFSL3ORG82EdtDJ77nEYqj1TB
	 drqk2H+qc81JJOvTH8zhs4BIFRNu/kr/E2LA1oJyZ9c2NfdTD3PlXwNQ52obzbgPv3
	 V8i/ldlx8RByg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91A34D8C96C;
	Sat, 20 Jan 2024 21:09:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] RISC-V: Disable DWARF5 with known broken LLVM
 versions
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <170578499559.24348.17111438888014376412.git-patchwork-notify@kernel.org>
Date: Sat, 20 Jan 2024 21:09:55 +0000
References: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
In-Reply-To: <20231205-riscv-restrict-dwarf5-llvm-v2-0-aedf00a382ac@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org,
 maskray@google.com, ndesaulniers@google.com, llvm@lists.linux.dev,
 patches@lists.linux.dev

Hello:

This series was applied to riscv/linux.git (fixes)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Tue, 05 Dec 2023 16:53:49 -0700 you wrote:
> Hi all,
> 
> This series disables DWARF5 for LLVM versions where it is known to be
> broken due to linker relaxation:
> 
> https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
> 
> [...]

Here is the summary with links:
  - [v2,1/3] riscv: Hoist linker relaxation disabling logic into Kconfig
    https://git.kernel.org/riscv/c/55b71d2ce133
  - [v2,2/3] riscv: Restrict DWARF5 when building with LLVM to known working versions
    https://git.kernel.org/riscv/c/ae84ff9a14a5
  - [v2,3/3] lib/Kconfig.debug: Update AS_HAS_NON_CONST_LEB128 comment and name
    https://git.kernel.org/riscv/c/a4426641f00c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


