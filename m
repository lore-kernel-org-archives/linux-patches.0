Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69DB2A8D1;
	Tue,  7 Nov 2023 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5RTI9ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5736AC433C7;
	Tue,  7 Nov 2023 22:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699396225;
	bh=mQjxfbWMe4Gc4SDxzD5FonuT5nx1eMyTuCTNNuTUOkA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=e5RTI9ZEAfurOUWhmT3L1pIqZOmT2QSg3duFpUIpundVjG/txVcuifIuevnmQJuc0
	 ysDTx4FKKI6Wnx57BdrlEMf5L2Os2oCcIKaLnPa0WmK3A6DOlYAXABbG6RdMgxBqpP
	 5jaPJedh5Vm8FBwL8pxZ0+3+G4gw9vAFoOx52t5AkEHcuIiynoKLLPH+mqxg1qfn6u
	 djE9GBlLpkTJZZdB3hqxPRswUFewVLhBhgvDvGM9FjZHwy1IIS5jcO1Zy6NdYFtTJJ
	 NY+g0iYUULmpBNuR8KCdzn3YDQVcrHPNhJOoOcPkeeYiQQ5L+DTp8Vh4NY0Vyp3SWJ
	 xybANRqpwvawQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DA33C395FC;
	Tue,  7 Nov 2023 22:30:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] tcp: Fix -Wc23-extensions in tcp_options_write()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <169939622524.29953.10014331221596302172.git-patchwork-notify@kernel.org>
Date: Tue, 07 Nov 2023 22:30:25 +0000
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
In-Reply-To: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
 0x7f454c46@gmail.com, noureddine@arista.com, hch@infradead.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 06 Nov 2023 14:14:16 -0700 you wrote:
> Clang warns (or errors with CONFIG_WERROR=y) when CONFIG_TCP_AO is set:
> 
>   net/ipv4/tcp_output.c:663:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
>     663 |         }
>         |         ^
>   1 error generated.
> 
> [...]

Here is the summary with links:
  - [net,v3] tcp: Fix -Wc23-extensions in tcp_options_write()
    https://git.kernel.org/netdev/net/c/7425627b2b2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


