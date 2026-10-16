Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C232FE59C;
	Fri, 16 Oct 2026 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111821; cv=none; b=Uqems0RBjNKAwk+AQRSGU9xBCda+QQyr37PFTlsbzTkBvFYkwQJ827ZvJb3HWNKHP9ii2CDow4vXLbCP+5eJp3L0z3bm+rynCNaQ+30grH81b52m7cCT9tM7l9P2H9iObbA4VTDl7f/e7XM+rjt9ZNYqlFgxfrehQ+JdVfjliBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111821; c=relaxed/simple;
	bh=rUB6me+nFE7W5MIhlikqh4MnzkjSESjn3I9o9kYdGs4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PLdRtfNaZBp/B4UxW82F1y/Q7O/j73BWV53jKQHwzphq541Z7S7QZIyAG+VKCmiQxtTmmtB142WUVQTJ0CghxxyzOfHVjpZmRVWhV2rzTnRqAtw5tCzHCsrL213mdItDN/V5iz85gQ7/Kiun6wTWfNId1F9oGWPx8jI6n8MPzZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBW0+DhA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBW0+DhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0041F000C4;
	Fri, 16 Oct 2026 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792111819;
	bh=4L2jTYuhOxFHX8ofUOtkKnJ/116+KIZGlKdgdBRkOAY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XBW0+DhA/evM2yqJXLgswU6c6Q9SK1yiWnqttIs4oz7Ek/dqQBOKZmeHYLyBXYn4A
	 ip8GEWASHhWPJcKrNoc7BvhMJpUbgCXsHXpIKtKeQtMmKBpMCQ+7Kn8dfSBsSSGfBF
	 SXLdW0UWTqC34mSaerk3cDxLgWaXpJ8FzFWSR3d1fe4geRF5Hrd/6zhW7unqFmy+to
	 SXhCJsm/hHcLJ3tqm6axc/MN7mAYy/PWeEtRJ/eYK1jpuQhEU10nj0crgbIr0nig5b
	 C4Om8loXgllLwRhYmCy5BpEEjW3K/fNHdPJzcaSCf6GQOrFdrHtRUZ/aoxt5tSXLAK
	 4r27qQ6hph3rA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B44AC3808209;
	Fri, 16 Oct 2026 00:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dccp: uapi: clean up kernel-doc comments
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179211181826.4179746.15870876625132014446.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 00:50:18 +0000
References: <20261011032800.278870-1-rdunlap@infradead.org>
In-Reply-To: <20261011032800.278870-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Oct 2026 20:28:00 -0700 you wrote:
> Use correct kernel-doc format for struct members and add comments for
> missing struct members (dccph_seq2 and reserved).
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Simon Horman <horms@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dccp: uapi: clean up kernel-doc comments
    https://git.kernel.org/netdev/net-next/c/8241cd8ebe01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


