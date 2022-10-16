Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF057F
	for <patches@lists.linux.dev>; Sun, 16 Oct 2022 00:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08537C433C1;
	Sun, 16 Oct 2022 00:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665879337;
	bh=Hotm6fY7uxsa20ffEGsks8HQGh8KFOOKC3xOJp0RDUA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ub3zCq4YyqOBXYzZPO1iYYsTQBvYpB1fQiZtnZ/HAmwHYjq06+8FhvFKUnOLrIJ7U
	 S6UTOchhwJxXy5tI5TScJt3TowPxX8zKfQZuASuWu1qpEnjAs+Sy+oVU5PaREYDE+S
	 THY99YgsgvK+cIKkk8gKMuNKJdDONmTw+rJ4t2Nvqo12Hi/VuZAsot0xj01woRtcqU
	 cuBuqVqGUn4eQf1cNyMzFLyoLq3UTr3nodyKtdCilqN/Vd5it3q6G62kO31eQzoWoW
	 qaCYz4+nUOYhNFOL61V4TSbIXsHm0vszAEV71Z6cDBJWgHCQzR3sK61hArqI/NIC3e
	 tFRpYlobz1l5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7CBAE270EF;
	Sun, 16 Oct 2022 00:15:36 +0000 (UTC)
Subject: Re: [GIT PULL] slab hotfix for 6.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <83deef1e-48ab-6e29-4611-2e7c37d023c8@suse.cz>
References: <83deef1e-48ab-6e29-4611-2e7c37d023c8@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <83deef1e-48ab-6e29-4611-2e7c37d023c8@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc1-hotfix
X-PR-Tracked-Commit-Id: e36ce448a08d43de69e7449eb225805a7a8addf8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1501278bb7ba0728b869d3399ea94b67853256a2
Message-Id: <166587933693.18523.9655976105117440555.pr-tracker-bot@kernel.org>
Date: Sun, 16 Oct 2022 00:15:36 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>, Feng Tang <feng.tang@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Sat, 15 Oct 2022 22:06:08 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc1-hotfix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1501278bb7ba0728b869d3399ea94b67853256a2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
