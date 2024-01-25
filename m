Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFC45CA1;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706148626; cv=none; b=p/iC72Sn92vzCpTdnZWnQ8qhaD8gq1wDkVJ4XhvbgCuuFbfawG+yQevW2U2fS/Ynaw6DOOfOLP4GDWLT666Q+n7JpcGv7sromfiJmz5a76UieW35ODpTc7BRzTCSCOl1JsbxJcfDI1fTNdNGVrjDJnXSJUoQdisL4UbjkPVFTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706148626; c=relaxed/simple;
	bh=lUxkN/OvMbdPXEMY/fiHtQ5s7E4ME3IqSZiBVqBlL3I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SIe7KX6HwrjY1hzed/eg/7V4t1eYRCTUpf27j+DICv1Wz2AKUQcvZ9NUKhwxWYpIGZVaufzzLhg1lbo0NaGtLN9Qmq6REUfu7ssg/w8yIbuj9PBXYw48Ng3PCxIqZKilOsIWITtvkZnmS+apIBrKaN6U0cvNFO7sztmN2S+piJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JinZcVzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JinZcVzi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46BC9C433B2;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706148626;
	bh=lUxkN/OvMbdPXEMY/fiHtQ5s7E4ME3IqSZiBVqBlL3I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=JinZcVziywFhSno47Ia4qolSp4H+FqdHNA19LOb4EhX2QeKj9HkxIGotLO+h3or5G
	 zsmfdIhyu/vIwE/UNtPQmuvJIYyidRinRlmyN+SW/o2NaSlcY1nXDzyatt5yO+WB+d
	 MR/t8wdpjIgGlVGV7wE0GLFCkeV6+jfmD+J29DYU9+lRMnbalJiONaVwMF0E1XECsX
	 6n5TNsiQnqobTCKD2F0xHrdDH/TSWuMVL0KW7+V+zd7Zq73GXsnMEOwiQ765clh9bg
	 xBcY1l4JQ/KKcLdGVGelE1ldFNt/MTqiPZMROtUUDjSAauJYBmKBOAWJSrDx9COvXx
	 3pfEYOyZzgBBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 293AFDFF767;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend] tipc: node: remove Excess struct member kernel-doc
 warnings
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170614862616.13756.18046951576152774345.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jan 2024 02:10:26 +0000
References: <20240123051152.23684-1-rdunlap@infradead.org>
In-Reply-To: <20240123051152.23684-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, jmaloy@redhat.com,
 ying.xue@windriver.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Jan 2024 21:11:52 -0800 you wrote:
> Remove 2 kernel-doc descriptions to squelch warnings:
> 
> node.c:150: warning: Excess struct member 'inputq' description in 'tipc_node'
> node.c:150: warning: Excess struct member 'namedq' description in 'tipc_node'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Simon Horman <horms@kernel.org>
> 
> [...]

Here is the summary with links:
  - [resend] tipc: node: remove Excess struct member kernel-doc warnings
    https://git.kernel.org/netdev/net-next/c/5ca1a5153a28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


