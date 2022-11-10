Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB212185E;
	Thu, 10 Nov 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CBA2C433D7;
	Thu, 10 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668080415;
	bh=y2vgPIMu86Bp5vTOCEE12crQig4E8T9TYe9fzBClcvk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UywrG+6lhWYi01frg6TS8PH8RwgaZVmEvwqf0rMckbrT2iVUKXfwhtaPZXKWVru6m
	 k/DmmzcDPtCKrRzhSAFbcGP8SOaXd9CC2TPAgpzgbZhWnNgnvTnEPwtiwDmV8yC2Vq
	 3IAB7GUmsGOtbNe4pSSObfu1bAmiHqsY/m+3qWsPM4fVe/3RGFxFBZW2Wi9krWz5E9
	 hng2dKVhxZqxjD83BhFKVznXzU0r7VC8XZ/KFn1jPhOKGk27Y/o179yOxlrdBootEc
	 jbRlk0CzV/gMpPIFMLBUlKUt368jFPVAPb2oQFYPVxnttoOQK+7F/HwmuVn9hltv+S
	 HO0XhUa5NUEdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3838FC395FD;
	Thu, 10 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: mana: Fix return type of mana_start_xmit()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <166808041522.12004.5463540474559850111.git-patchwork-notify@kernel.org>
Date: Thu, 10 Nov 2022 11:40:15 +0000
References: <20221109002629.1446680-1-nathan@kernel.org>
In-Reply-To: <20221109002629.1446680-1-nathan@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 ndesaulniers@google.com, trix@redhat.com, keescook@chromium.org,
 samitolvanen@google.com, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, nhuck@google.com, error27@gmail.com

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  8 Nov 2022 17:26:30 -0700 you wrote:
> From: Nathan Huckleberry <nhuck@google.com>
> 
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition. A new
> warning in clang will catch this at compile time:
> 
> [...]

Here is the summary with links:
  - [v3] net: mana: Fix return type of mana_start_xmit()
    https://git.kernel.org/netdev/net-next/c/0c9ef08a4d0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


