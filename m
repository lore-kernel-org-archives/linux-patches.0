Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1010E9;
	Tue, 21 Mar 2023 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 837A9C433D2;
	Tue, 21 Mar 2023 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679403617;
	bh=i7Lt2yBcxqqjRBBkoZc9EgRf9ra0FqEFqfjEvCSEiIM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZnjZcpHybebHOenZ20j94c1EC/AbTYsPkMhkv8jjhtL90bGiDv8lhok7bDhR5enO8
	 9rWM88s63B5W7NcOBNcLZLXtOYmWpjIGMWGQYu1Je2qVmbTzmoR7tQcborX8xYvKFs
	 G2qSJiXRtsHq+MSAXW0wNLrpKSeB9Fg/YGBvgCQvkDW26VZAvJmuJA/2Cf26IQ5rJ0
	 61UooAxQRS2EaqqITiXufXtkOZ53DsnUOogjH22tY3DoKgYrEvEv0BCy9LKnjY9KBf
	 qwKU3PVz8B4RHrS3GjKVoLpbsa7dh+kPRdUSRH+ZKWgpkXXo7nB3zWOBmngP1gWvA7
	 D/H38/TqyLkDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EEE2E66C98;
	Tue, 21 Mar 2023 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pasemi: Fix return type of
 pasemi_mac_start_tx()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <167940361744.508.4471214158276958650.git-patchwork-notify@kernel.org>
Date: Tue, 21 Mar 2023 13:00:17 +0000
References: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
In-Reply-To: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
 netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 16:41:08 -0700 you wrote:
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> warning in clang aims to catch these at compile time, which reveals:
> 
> [...]

Here is the summary with links:
  - [net-next] net: pasemi: Fix return type of pasemi_mac_start_tx()
    https://git.kernel.org/netdev/net-next/c/c8384d4a51e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


