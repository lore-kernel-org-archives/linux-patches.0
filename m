Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0186127;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706148626; cv=none; b=jj0lpTfgScplRCdfMEwBGycP2Tdf578jV0ImIq8X+jU2eH4njX70c9s0PKym5BGNmlWWfXpVzL/iMCPzhS6xwRING2lGvcDl9o0RNgnfTzNXM2UnIvoDeUd1/BSVCeO9sNyufn9yvSGdiuRKfOKoDdM1OJqp+zYYtHL5KYpE1tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706148626; c=relaxed/simple;
	bh=zeAy8tRADfPKtiurzOoL4rGwXdhUVhmaRIFf0BLzF+Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=I3UmG0lU3ZtcNmIokN95q2+ANpMslhJElN3SvUBx869wXaStJ8Y5BL7Hg6yOSlAnh+rq1aJd/J1e4Kg7BHHl+GscsOtppwZ4aPewNqgDOKTKIEK4JPo8hqWHOSkOQg7scV6lB9/kzp/0pM8KU5fVuOx4Laa7d4AWV5dh5x1oLgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMdRqMWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMdRqMWK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36F5AC433B1;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706148626;
	bh=zeAy8tRADfPKtiurzOoL4rGwXdhUVhmaRIFf0BLzF+Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OMdRqMWKTJg0eg7g+knRerJJ6D2Uw+d//Rwjx6S5Vh/uhCYdK2kEBdszR24/lbwUo
	 HTUBxTgAcqw5brS1IP7zP367t4V9q3otCVdSto3w6bMcptVcOLv0MsiwQbWnzk0AjD
	 CQ81cOfIntgW7F1fFh4ukoU4M5UsjfNTk299+7jWwAL0Ea3BEXZNidDM893vg+7d2h
	 gZtjmPbySul1VgMmeDEHC7VstG1mLSO9KQlivkZT8Gy9b8MeBuS4ccmXtkEFKYhTxK
	 2hhIxWosjlYCujARxxrkHoCQzU6ShR89xFg9ZLfoSkYRgexM60j6OQiyOFO8U0IxwO
	 mdJ1L4toXGZqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20941D8C967;
	Thu, 25 Jan 2024 02:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend] tipc: socket: remove Excess struct member kernel-doc
 warning
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170614862613.13756.7070098094645334807.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jan 2024 02:10:26 +0000
References: <20240123051201.24701-1-rdunlap@infradead.org>
In-Reply-To: <20240123051201.24701-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, jmaloy@redhat.com,
 ying.xue@windriver.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Jan 2024 21:12:01 -0800 you wrote:
> Remove a kernel-doc description to squelch a warning:
> 
> socket.c:143: warning: Excess struct member 'blocking_link' description in 'tipc_sock'
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
> Reviewed-by: Simon Horman <horms@kernel.org>
> 
> [...]

Here is the summary with links:
  - [resend] tipc: socket: remove Excess struct member kernel-doc warning
    https://git.kernel.org/netdev/net-next/c/88bf1b8f3c31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


