Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DB6ED8;
	Fri,  4 Nov 2022 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A842C43143;
	Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667538027;
	bh=o0TS4iNSKwql1CsNnSuW4sitQYzuR5b7ICfwjT9hlj0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LMcPukrQaw8/EXTbPawdxSTuK/v8isU3ErmVfi70IQsJte9NSNyZpfLls3itdoTvt
	 p2dIVE4hvndPQsYhHly8evELSWbS4LBc73aeeCxs/tcRZcggPfTLh2kFlVVQkmuTib
	 mE/3MSUIqiJVONpLgz06Xk8pjPUaJlAG1DHXPV5Cr5JdR8HT5WXhbXWg1tKMqAqAPZ
	 kspQ6zj62a+RI+uMTNrAxK+Ns+kyCG46WDiJMhkvvdCsW2KAtlewNp5059mmxkJfbU
	 FGfC5yyzIU2DVYvLC4SNYa5NsOIe15wEd0eNrdryxpQaH5qmln7ACjkuyPOp8DKb3U
	 IiHEtq4Ht7IYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E2DEE6BAC5;
	Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <166753802712.27738.5840275256929015736.git-patchwork-notify@kernel.org>
Date: Fri, 04 Nov 2022 05:00:27 +0000
References: <20221102160933.1601260-1-nathan@kernel.org>
In-Reply-To: <20221102160933.1601260-1-nathan@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, ndesaulniers@google.com,
 trix@redhat.com, keescook@chromium.org, samitolvanen@google.com,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Nov 2022 09:09:33 -0700 you wrote:
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
  - net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
    https://git.kernel.org/netdev/net-next/c/63fe6ff674a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


