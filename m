Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEB3823A6;
	Tue, 23 Jan 2024 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706032231; cv=none; b=ohepEsI3Yg4MLYgYsynllung5VboXhxf1tmlB6dXXpRJ1Csk4ghehg2gMTZYTgk+XRGp72+Gzi8ZhoPWCIk10ItyI8tuyU48k5XDnjSoJ3+eBSoSHTOLwtl4RxKXSzqhYMSTtGk3dlTmtK2EsU2DwWTbmq1ptsva0JhPu6vGY0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706032231; c=relaxed/simple;
	bh=x1Ni5BlIAZGl/I/K/Xm762bnUAtUEwlvGnjM0NI6qOY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=t1phqpZnwKvG2PP3KNFRqzNEoDE6h4Rin8XlLeK5DkDM/um+2BpE/nj9MeF8xNrXkScBF656gJtYQzmeR/e0a/vbB7eZpERtc1zdlQLB5v9TI37a20X8V+qGtfn7po64qmxGuOS4ENSSX3xLP3Ammen2zE4Fv9g/JmwJgb2aR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prslJmCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prslJmCS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18D2DC43330;
	Tue, 23 Jan 2024 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706032230;
	bh=x1Ni5BlIAZGl/I/K/Xm762bnUAtUEwlvGnjM0NI6qOY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=prslJmCSrnlLTLgLzDJtl7IO1Ao4Ndrq+/cV/Wx3ja0KU0pL41OdzS3P8PqpwKTG/
	 IKjr3ZVKUNuNDFkglbXEYxgbrTNDTDiBQy6NYIPTywMH474wR1E0oJyi148IeL+CeO
	 6ODf80y5fGgXK9BMVnzT2/qnD4t11a9BuF7a1eQ7uUp0fZ59bWmyvceBeAPzHAERmz
	 6pVzjV86Vs6xrAGAx3Rmj5v0h2F7XpetzOZ0UwjjNwwiBzBJ9zZENJDpf3I7tGgSgN
	 26GakvNB5lm70K2TfF0fGmgOyb2UyuFFW8LEqgwYa4erGZ8w/2GfOxqZw5yinETiG1
	 CxOcSl6Y22nlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 010D8DFF763;
	Tue, 23 Jan 2024 17:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] RISC-V: build: Allow LTO to be selected
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <170603222999.30461.9105047550962692358.git-patchwork-notify@kernel.org>
Date: Tue, 23 Jan 2024 17:50:29 +0000
References: <20231017-riscv-lto-v4-1-e7810b24e805@kernel.org>
In-Reply-To: <20231017-riscv-lto-v4-1-e7810b24e805@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org,
 ndesaulniers@google.com, trix@redhat.com, samitolvanen@google.com,
 twd2.me@gmail.com, llvm@lists.linux.dev, patches@lists.linux.dev

Hello:

This patch was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Tue, 17 Oct 2023 15:21:04 -0700 you wrote:
> From: Wende Tan <twd2.me@gmail.com>
> 
> Allow LTO to be selected for RISC-V, only when LLD >= 14, since there is
> an issue [1] in prior LLD versions that prevents LLD to generate proper
> machine code for RISC-V when writing `nop`s.
> 
> To avoid boot failures in QEMU [2], '-mattr=+c' and '-mattr=+relax'
> need to be passed via '-mllvm' to ld.lld, as there appears to be an
> issue with LLVM's target-features and LTO [3], which can result in
> incorrect relocations to branch targets [4]. Once this is fixed in LLVM,
> it can be made conditional on affected ld.lld versions.
> 
> [...]

Here is the summary with links:
  - [v4] RISC-V: build: Allow LTO to be selected
    https://git.kernel.org/riscv/c/021d23428bdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


