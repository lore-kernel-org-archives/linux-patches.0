Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F17487BF;
	Wed, 20 Dec 2023 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r03de9Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAB46C433CB;
	Wed, 20 Dec 2023 23:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703115629;
	bh=RoEOFV5J3foI2l2TcuAzIT/IxdFT8RqRdlQOAD8+lOw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=r03de9FdRYeFcbYFXpKerlYZNDI6n2ah58Fy9mMo+1e+kAjBxmRi4VXXirtRCRxmY
	 /EudVqb3Q6pPDI8pkYO0Zjd3ojAMzWDpWr/Ep9nUxtNsejUcm1j6rfwr7wmyWfzcYQ
	 GIgMHiYG3Fv9cBKujI0gd5/kOUpH3GNeLFXX00I4c2QmA16YRcNlS9HIJ83QpeksrR
	 RqKZOD9Pr/Xvu9sU6+SWiKnZdhzth/VAPBHkSujaDFjE3u6u83xAC9vP+slC3m4gst
	 vNB978o5g/T4ZT02yFeD9+S6IDT8LPonF+PRLzrX3UmYupegk6lPGNKCFme+yL25Yg
	 5ab2rGkvpwX5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5104D8C983;
	Wed, 20 Dec 2023 23:40:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: skip DWARF sections in linker sanity check
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170311562886.28353.13302964689077482273.git-patchwork-notify@kernel.org>
Date: Wed, 20 Dec 2023 23:40:28 +0000
References: <20231219110324.8989-1-hi@alyssa.is>
In-Reply-To: <20231219110324.8989-1-hi@alyssa.is>
To: Alyssa Ross <hi@alyssa.is>
Cc: bpf@vger.kernel.org, andrii.nakryiko@gmail.com, patches@lists.linux.dev,
 slyich@gmail.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 19 Dec 2023 12:03:24 +0100 you wrote:
> clang can generate (with -g -Wa,--compress-debug-sections) 4-byte
> aligned DWARF sections that declare themselves to be 8-byte aligned in
> the section header.  Since DWARF sections are dropped during linking
> anyway, just skip running the sanity checks on them.
> 
> Reported-by: Sergei Trofimovich <slyich@gmail.com>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Closes: https://lore.kernel.org/bpf/ZXcFRJVKbKxtEL5t@nz.home/
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> 
> [...]

Here is the summary with links:
  - libbpf: skip DWARF sections in linker sanity check
    https://git.kernel.org/bpf/bpf-next/c/a4897b87775c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


