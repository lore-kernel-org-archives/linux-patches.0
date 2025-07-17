Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A529ACCC;
	Thu, 17 Jul 2025 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752763187; cv=none; b=iSlUYnaHmGZWp0sICfr+Fu1x4E+sxzcmEnpXU2VVNS2LZYiROFmc6VzQKeWISVqjCLYa4KOKJbN5ANn06kdko41CSeXiKDYIceyesrx8FX4pNGV9x/dku5hKhWNg0CnYopjIq8gEN4Um7PPukZhbXn5ZYIKnNS4+WC3D8djHqBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752763187; c=relaxed/simple;
	bh=2uxqFTgL6A89E1Llk8rr/dFCbk+lTDW9qevuAEn8L1g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=U4xRcnnFv09sO7jiQsDGvWTXg+73IN9SlSshDk9jztoEHR/37xwFXFk0N1eKzdE5LJr0yvcEyNoVNLUQsLbuOuc6dItTjWaYtlLpeEYpBtTe/9yR5C3Zn1BEITiM5e/De+GBbOGVbQtntsbqD2AduQwQYU7vrQ+uHFqFJwOx+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R44hV034; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R44hV034"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3C1C4CEEB;
	Thu, 17 Jul 2025 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752763186;
	bh=2uxqFTgL6A89E1Llk8rr/dFCbk+lTDW9qevuAEn8L1g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=R44hV034ANsstAZW62mk3bG9OuFWoPhwjPwK2k4R+b3RtIx5fBFMk84So0muE6CcG
	 R9T6VaJzfSuiwT7pUxf9Gu238s+9eZtRt3d8jpGAg/sOWXTlceQsf4W0BHHstqaArb
	 qUdkLuXvDRN5mT7m7YSmwCUfb7/4LxU6M46z4ppgGcUy1qraa/1SP1sA0JXokbjvCv
	 uYNuVJ7a4Z2/Z9QykINLXinW3w320GgVF0RbsN5fx/cjdV0rA1XCv3b6mAGKvA7K/I
	 C80Tg74LbkVpaM7gdZu7R5Z1l5TgiMDPSe9Tsg/cFBBU74y1SI4oCMm+9BXWKfv4IH
	 kulj2fMEqQT+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEAB383BF47;
	Thu, 17 Jul 2025 14:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] phonet/pep: Move call to pn_skb_get_dst_sockaddr()
 earlier in pep_sock_accept()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175276320676.1955911.2458050765947008599.git-patchwork-notify@kernel.org>
Date: Thu, 17 Jul 2025 14:40:06 +0000
References: 
 <20250715-net-phonet-fix-uninit-const-pointer-v1-1-8efd1bd188b3@kernel.org>
In-Reply-To: 
 <20250715-net-phonet-fix-uninit-const-pointer-v1-1-8efd1bd188b3@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: courmisch@gmail.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kuniyu@google.com,
 netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Jul 2025 16:15:40 -0700 you wrote:
> A new warning in clang [1] points out a place in pep_sock_accept() where
> dst is uninitialized then passed as a const pointer to pep_find_pipe():
> 
>   net/phonet/pep.c:829:37: error: variable 'dst' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
>     829 |         newsk = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
>         |                                            ^~~:
> 
> [...]

Here is the summary with links:
  - [net] phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()
    https://git.kernel.org/netdev/net/c/17ba793f381e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


