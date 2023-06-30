Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F66ED5
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 00:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 809EDC433C8;
	Fri, 30 Jun 2023 00:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1688086082;
	bh=QW/ZG27r/j6e1SMW009tpdPRu5r+I9EmKaZX3lH+NX4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hSfc1SCLNlx85OVo5mFBs86NMQH8Te05uNf8t2Zen2V5oBX/V7dxhv+IaRMKfU5/L
	 YtzNsZFp2Rj5jTz5K6vFzyngykIZLJosMwsZ+50+S1jMhlt2WxQDGy1z65CabDuEW1
	 tiALfGYdP4wkxdwB6nhl43i3+qoFEKFcLWfWoPfzzrzzmyFWN+CfyBdnvpVz/EOvKB
	 bP/+XUi8w3JocF5C3ayiYmR+Lcy6YIZB0NUIMlplrWuzemYalZ1ydYMaZsaKcLMuWX
	 loeBd+blipKmLda9P7qe35KhhzFvBCHt7PxXdDWNNlcQA728OScyq8ClQccq5K7ZHS
	 E24zMSPEQFgiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C562C39563;
	Fri, 30 Jun 2023 00:48:02 +0000 (UTC)
Subject: Re: [GIT PULL] sysctl fixes for v6.5-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZJ4EkpN71LEsakct@bombadil.infradead.org>
References: <ZJ4EkpN71LEsakct@bombadil.infradead.org>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <ZJ4EkpN71LEsakct@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-6.5-rc1-fixes
X-PR-Tracked-Commit-Id: 554588e8e932e7a0fac7d3ae2132f2b727d9acfe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 82a2a51055895f419a3aaba15ffad419063191f0
Message-Id: <168808608243.32109.6957582709458880295.pr-tracker-bot@kernel.org>
Date: Fri, 30 Jun 2023 00:48:02 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, arnd@arndb.de, matthieu.baerts@tessares.net, rdunlap@infradead.org, ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 29 Jun 2023 15:24:18 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-6.5-rc1-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/82a2a51055895f419a3aaba15ffad419063191f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
