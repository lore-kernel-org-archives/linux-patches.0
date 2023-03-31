Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE287ED8;
	Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54A24C4339C;
	Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680244220;
	bh=oVNrIse3VEoOTwiJCZSaD19tmzueBrN/XPGjwvdI2fQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=obV1cb54LwI/ig5zUv5OjGv5bgPZatX/pcn1cwoEvj5DJReOh06kNZlkf03iazlAu
	 M1ptqUnRz5ZPihbtmWSfMHUnO+xDINmr/Z9AKKvjuGBVsFig6UdPhAn8LDnIfBEhBt
	 WLTWnwzI4JYVt5mEcE5fFbsjAv6HSRvttjWKDUpIrLLWkEtWNy01xwazWkzhApPLCd
	 tGOkQLBxtyxMAPnvblsE0N+YWt8o0GZWCGic9yNKLGwwibEqQnuKb+M8AQNXQPqqvg
	 tUJ0e1FmDBolx/LyBV3Rjk/JqFuGz3QaTwY0TNHI0eBpbiu0mC0JVvC5BiuLpzVtxT
	 zwZJ9th+ePurQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B776C0C40E;
	Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: Fix format specifier in
 netcp_create_interface()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168024422016.32019.3404856022157277759.git-patchwork-notify@kernel.org>
Date: Fri, 31 Mar 2023 06:30:20 +0000
References: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
In-Reply-To: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
 razor@blackwall.org, kerneljasonxing@gmail.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 08:08:01 -0700 you wrote:
> After commit 3948b05950fd ("net: introduce a config option to tweak
> MAX_SKB_FRAGS"), clang warns:
> 
>   drivers/net/ethernet/ti/netcp_core.c:2085:4: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
>                           MAX_SKB_FRAGS);
>                           ^~~~~~~~~~~~~
>   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
>           dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
>                                                                  ~~~     ^~~~~~~~~~~
>   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
>                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
>                                ~~~    ^~~~~~~~~~~
>   include/linux/skbuff.h:352:23: note: expanded from macro 'MAX_SKB_FRAGS'
>   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
>                         ^~~~~~~~~~~~~~~~~~~~
>   ./include/generated/autoconf.h:11789:30: note: expanded from macro 'CONFIG_MAX_SKB_FRAGS'
>   #define CONFIG_MAX_SKB_FRAGS 17
>                                ^~
>   1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: Fix format specifier in netcp_create_interface()
    https://git.kernel.org/netdev/net-next/c/3292004c90c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


