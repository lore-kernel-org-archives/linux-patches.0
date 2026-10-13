Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0B24CC273;
	Tue, 13 Oct 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888609; cv=none; b=GahUw1OybXOuSJYHwOKPq0qT7z5WOXZgT16unU/kbZpfa2cAOTMJXXNmlv++ign0RTyD7hML5Jc29/3c/42pFVpsggnpGrx431AmV54gML3dnrlBbZRXPTbQVT5dVcBZavo2csCFmepV6zcS5mpBcwuxq//lIa+7ZbvL7yvfPRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888609; c=relaxed/simple;
	bh=KRvmlbXYcaDDLPtfFW06t+P2HRoZ5Kt1ADflIMwmIxI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gHXK8iafiGa4LcR89IhswZ6w/zuFIPZEJGOcTh7yyCgK+9c1It89M8ePGDsiDffd2kegiCAIiiwFXfNCkiF1DbCjwNzD1BP/n1Tgq/jMWz3D5ilzGxSwrQD4cRtE1P0gcYRg24F4kbIOWAz2/CWzFsyHwGao3XbrL09GaeeHMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAZhp3n2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAZhp3n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075671F00893;
	Tue, 13 Oct 2026 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791888607;
	bh=j8cG4X3JD8xO++Vb0UNPGgCZkobpdnrRDC3GPoRELMQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=YAZhp3n2b0eRbaPZATe33H2nk0QzO9FcBht4+Ko2UW2YbD6e8l0pdNXPHCJvaRntb
	 sHoh5yFyDRlF5JKkIWvG+Fr4T4Oe3yfJxWAawthPms7FxqqCz3GOFQ1pW0GYBiFWgD
	 ykocynRzqnrISu8zbmm6AT/XW90dSTjizNsJHIoxceJELiOrrlu4j+2EivNSPUK0KC
	 ovEXxwmKkqkokXzIKvFlGoWHuDrUF9APY1hJeSbsroIz7X2ryHPEGpHX+6YiPrNRug
	 ATIIHCHwQOh24Zoi6E2TmPePg5PPx6bcInrcryfSA4fhVoSmN4CTvApaaj+AnjEuSg
	 uB7Q64jyBqREQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F13F7392704F;
	Tue, 13 Oct 2026 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: natsemi: xtsonic: make probe function
 static
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179188860551.217011.9324241103805138564.git-patchwork-notify@kernel.org>
Date: Tue, 13 Oct 2026 10:50:05 +0000
References: <20261008183013.3223131-1-rdunlap@infradead.org>
In-Reply-To: <20261008183013.3223131-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev,
 tsbogend@alpha.franken.de, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu,  8 Oct 2026 11:30:13 -0700 you wrote:
> Avoid a build warning by making the probe function static:
> 
> drivers/net/ethernet/natsemi/xtsonic.c:200:5: warning: no previous prototype for 'xtsonic_probe' [-Wmissing-prototypes]
>   200 | int xtsonic_probe(struct platform_device *pdev)
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: natsemi: xtsonic: make probe function static
    https://git.kernel.org/netdev/net-next/c/26a8396802ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


