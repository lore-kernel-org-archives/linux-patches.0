Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962067E5;
	Fri,  4 Aug 2023 01:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F866C433CA;
	Fri,  4 Aug 2023 01:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691112021;
	bh=NyQViIbcv2wtLMjRQWh1tgUGameZLLC2Kz6PfNBMJig=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aBEZdPjv83k/U64YozPn99tGBeB5Ed6cS7GO66MOW97NSfwjbkDl8s5fJL7e6Hy+G
	 byTl+KhIfxZIHQUBRLvkwyl1yIpyhP/CnLcwD+zAcp7R03sGMv56kREGXq0t0YnlAc
	 ceMU1oIkiEI/lBFJEg1ERlou0NpmF8d19xNpErbIWp28eRDhN7tFA/c8FVVBBTDeUM
	 D790C1qhgknQadHhVBNQOyfNitufKAM75x49VugELNa/fOCzenin55F945BtJSjPAt
	 qXz6hKHQVwc1MojF1fNb+wWV+a3vMcLfSOxP2/6+J9q+UAflGcVGV9AV+73pkjvLHM
	 sPYh2EZyuwYBQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4965C595C1;
	Fri,  4 Aug 2023 01:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mISDN: Update parameter type of dsp_cmx_send()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <169111202093.20038.18092602618780856244.git-patchwork-notify@kernel.org>
Date: Fri, 04 Aug 2023 01:20:20 +0000
References: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
In-Reply-To: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, keescook@chromium.org,
 samitolvanen@google.com, llvm@lists.linux.dev, patches@lists.linux.dev,
 oliver.sang@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 02 Aug 2023 10:40:29 -0700 you wrote:
> When booting a kernel with CONFIG_MISDN_DSP=y and CONFIG_CFI_CLANG=y,
> there is a failure when dsp_cmx_send() is called indirectly from
> call_timer_fn():
> 
>   [    0.371412] CFI failure at call_timer_fn+0x2f/0x150 (target: dsp_cmx_send+0x0/0x530; expected type: 0x92ada1e9)
> 
> The function pointer prototype that call_timer_fn() expects is
> 
> [...]

Here is the summary with links:
  - mISDN: Update parameter type of dsp_cmx_send()
    https://git.kernel.org/netdev/net/c/1696ec865401

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


