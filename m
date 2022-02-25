Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D371523D5
	for <patches@lists.linux.dev>; Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96969C36AE2;
	Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1645809664;
	bh=kKt2WWIC9sQjA3ZVxKRO4C6Ek5Zwb9FUNfOwFqq+yp8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Eor90FwzhQeUnJU15sS53t2IkxKK8dyxLZXBKCgXT+q9QoMA8k3CxxYQJRSVFkJ8+
	 m7/GALxXZLt5dqCf5cVNa7iLtKApXhj1DzmtwXBcUi8duBMaottOHspPvQmQb3qjlr
	 ESm89/gR9BEXg1zISJ+jtlONav5T4wT7ZFrS5AXcCIb24rUEU5g9yqyvhyV14Uz8Sd
	 WErxHMcpN7FTAbmPoSxOvl6cJqBPs8cCdt8Yaw0dYFEPC4EHzcoe+4eiRVxx/fl9su
	 1Hk4YO7ZYJ7up9oalC9ayxOkHVvTdw7t8kmOavaSgezflGKqSFTNm4pr1NUajHHBa7
	 WvmoErxdp8XbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82BEDEAC09C;
	Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: fix return value of __setup handler
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <164580966453.15608.582946093358485153.git-patchwork-notify@kernel.org>
Date: Fri, 25 Feb 2022 17:21:04 +0000
References: <20220224033536.25056-1-rdunlap@infradead.org>
In-Reply-To: <20220224033536.25056-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, i.zhbanov@omprussia.ru,
 peppe.cavallaro@st.com, alexandre.torgue@foss.st.com, joabreu@synopsys.com,
 davem@davemloft.net, kuba@kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 19:35:36 -0800 you wrote:
> __setup() handlers should return 1 on success, i.e., the parameter
> has been handled. A return of 0 causes the "option=value" string to be
> added to init's environment strings, polluting it.
> 
> Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
> Fixes: f3240e2811f0 ("stmmac: remove warning when compile as built-in (V2)")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: stmmac: fix return value of __setup handler
    https://git.kernel.org/netdev/net/c/e01b042e580f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


