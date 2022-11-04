Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8151ED7;
	Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32C6AC43157;
	Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667538027;
	bh=VK8OQwdbUlsqJ5yUa+HWLi4zK1xxr2oNAnBk6r6xGVI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XY1JaOrYbRWaaDeoQRQesK2/i96xwmtLloyoMvavFi1HJnHMk46aXeaXkx2V0qRoq
	 nObM1giOSBF1DB+glRhBzW05LHgxCsfsXmpiwtAKf86mI9xy8XxQAevRiM0YqUqd2j
	 qTt8QZzizPE+nJ1LQ3zxM6zQFlZdRLIaldqogdkj+MC+ZHNeWlT2lGjpBIFaYlORbW
	 queI1rgNKTf+dPV0ZmGXaKxmY6ECIIU5BJjg5OwMX2bnuqmw8PX1nCrP/TmUYNNWBf
	 wwqgWr3k/AdXF8J2rYCcUF6GrIoHtOWpiRDuY+SsB4ApU5oMEMLKsj7y+9/tQ1qX1r
	 DVn62V8jLYu4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 087A6E5256C;
	Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hamradio: baycom_epp: Fix return type of baycom_send_packet()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <166753802702.27738.11594925007780721329.git-patchwork-notify@kernel.org>
Date: Fri, 04 Nov 2022 05:00:27 +0000
References: <20221102160610.1186145-1-nathan@kernel.org>
In-Reply-To: <20221102160610.1186145-1-nathan@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: t.sailer@alumni.ethz.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-hams@vger.kernel.org,
 netdev@vger.kernel.org, ndesaulniers@google.com, trix@redhat.com,
 keescook@chromium.org, samitolvanen@google.com, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Nov 2022 09:06:10 -0700 you wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
> 
> [...]

Here is the summary with links:
  - hamradio: baycom_epp: Fix return type of baycom_send_packet()
    https://git.kernel.org/netdev/net-next/c/c5733e5b15d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


