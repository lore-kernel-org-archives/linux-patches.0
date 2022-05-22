Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F79C33D4
	for <patches@lists.linux.dev>; Sun, 22 May 2022 22:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2802FC385B8;
	Sun, 22 May 2022 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1653257412;
	bh=0N6izllcvWFLMF5ARgwmcntKeN7CYIUZAfOZuVHaGjs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b2zDwnPavQwCSoNPtz81VYcjvld22d7meR8B3I8HptAtm689pX3W5LjjRRYzNYfD7
	 +pgTwRah+Fo/4xT0Unt3KoTCD3R0RYbJNyDG4UwlsX0Io9hGhX2Y2zNNoYBB57646Z
	 nbpw/xhtVAKet8HCozHCn/7bkNZStM1baGfRghN/v4EUewYSQny9ZItt6f7j0f3bRb
	 aOsQrge/CcOquUKJfUv8aIAhLt7mYrUzQF90LG3LcMnJcAtyQMXHLe5WKwOsutoPc2
	 f7zjhduz7cJ/mLdSTFucoxbizN6brzzdUWW8AP3tNYf/4xdNuSwf7WEJPHzCm1h0XQ
	 9rk8du8GIGmCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F11F8F03938;
	Sun, 22 May 2022 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <165325741198.24339.2057653862735564436.git-patchwork-notify@kernel.org>
Date: Sun, 22 May 2022 22:10:11 +0000
References: <20220520051523.10281-1-rdunlap@infradead.org>
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, andrew@lunn.ch,
 vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
 jbe@pengutronix.de, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, mans@mansr.com

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 May 2022 22:15:23 -0700 you wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
> they are limited to VLAN_8021Q if the latter is enabled. This prevents
> the Kconfig warning:
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
    https://git.kernel.org/netdev/net/c/0a3ad7d32368

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


