Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7F227F4F5;
	Wed, 12 Nov 2025 02:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762912853; cv=none; b=aZ6BPTcCpZVq7J8YPsnfFsGnaZfLfPh3yR8jHCTZdYKcLl1od9/pGyW2/NnGWiQocR9MEfSoR8CMcsVQgZHq3vEQjFoPtMqwGzniQxsQNLpP/mdeWfUDDCZd52P93uzMB9AtvrZ8aEW1YErNjQc0tL9dKipUvL2n+XHx3T9me9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762912853; c=relaxed/simple;
	bh=bmOHQWtKrHPntI9DeDNIWpuAgYazNgi4duLqiFfEnvQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sFjEpFMLojTM4bRLX0yD9PYN03fOx8ln4rRf513gn6R7QBrL6DRh8UQ4woDWcVPcn24lltkdCNLD42/A1GDezW2tnUgPfeBYYfzVSoHpdw/5kLS+82tw84fBKzoHLzNsglps0EFAdwa5O66OcUlkCs+0SICMkwxOVVNmkxwtcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRBGDHvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRBGDHvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DCEC16AAE;
	Wed, 12 Nov 2025 02:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762912852;
	bh=bmOHQWtKrHPntI9DeDNIWpuAgYazNgi4duLqiFfEnvQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZRBGDHvTwVZgG2vuUoyWLjDWMBOrtkEXeNMuDphzzKwHtO/pyy9jL/8NVquwpSRZ1
	 KfVjxByxLTOEKWZHTSPhIXTBSxRzcXnCVRpw8ARkqLzpKHBF3UtnyPa/DfrotlKE1i
	 M+hCq3y28JeymcTsVxEoJ6AuUmjElJM1px2jNRLX46fiUDLeqXOIdDhGaOfa0sdWnB
	 ljT1dJHzE68dXgSzqrynRWRX7ksbPd79IJhNLIe2c220w2kfxAbXbUMbD7SMP0yueO
	 h3QzdQ6cFb2vzkLjhkWM850fjp6KiLFQc5fLOY0S36PoTH4MAHHvb7uuBkXnN3F+p8
	 lp5HfcCwv+RNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADEA7380DBCD;
	Wed, 12 Nov 2025 02:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: netcp: ethss: Fix type of first
 parameter
 in hwtstamp stubs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176291282249.3632748.2889753579213224698.git-patchwork-notify@kernel.org>
Date: Wed, 12 Nov 2025 02:00:22 +0000
References: 
 <20251110-netcp_ethss-fix-cpts-stubs-clang-wifpts-v2-1-aa6204ec1f43@kernel.org>
In-Reply-To: 
 <20251110-netcp_ethss-fix-cpts-stubs-clang-wifpts-v2-1-aa6204ec1f43@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, nick.desaulniers+lkml@gmail.com,
 morbo@google.com, justinstitt@google.com, vadim.fedorenko@linux.dev,
 kory.maincent@bootlin.com, netdev@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Nov 2025 13:55:34 -0700 you wrote:
> When building without CONFIG_TI_CPTS, there are a series of errors from
> -Wincompatible-pointer-types:
> 
>   drivers/net/ethernet/ti/netcp_ethss.c:3831:27: error: initialization of 'int (*)(void *, struct kernel_hwtstamp_config *)' from incompatible pointer type 'int (*)(struct gbe_intf *, struct kernel_hwtstamp_config *)' [-Wincompatible-pointer-types]
>    3831 |         .hwtstamp_get   = gbe_hwtstamp_get,
>         |                           ^~~~~~~~~~~~~~~~
>   drivers/net/ethernet/ti/netcp_ethss.c:3831:27: note: (near initialization for 'gbe_module.hwtstamp_get')
>   drivers/net/ethernet/ti/netcp_ethss.c:2758:19: note: 'gbe_hwtstamp_get' declared here
>    2758 | static inline int gbe_hwtstamp_get(struct gbe_intf *gbe_intf,
>         |                   ^~~~~~~~~~~~~~~~
>   drivers/net/ethernet/ti/netcp_ethss.c:3832:27: error: initialization of 'int (*)(void *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' from incompatible pointer type 'int (*)(struct gbe_intf *, struct kernel_hwtstamp_config *, struct netlink_ext_ack *)' [-Wincompatible-pointer-types]
>    3832 |         .hwtstamp_set   = gbe_hwtstamp_set,
>         |                           ^~~~~~~~~~~~~~~~
>   drivers/net/ethernet/ti/netcp_ethss.c:3832:27: note: (near initialization for 'gbe_module.hwtstamp_set')
>   drivers/net/ethernet/ti/netcp_ethss.c:2764:19: note: 'gbe_hwtstamp_set' declared here
>    2764 | static inline int gbe_hwtstamp_set(struct gbe_intf *gbe_intf,
>         |                   ^~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: netcp: ethss: Fix type of first parameter in hwtstamp stubs
    https://git.kernel.org/netdev/net-next/c/34bff6f03c13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


