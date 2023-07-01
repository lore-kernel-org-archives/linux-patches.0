Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EB7C8F5
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 432EEC433C7;
	Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1688227923;
	bh=6IsqIh05oW0elN2m/vV35hMLVDlGmRyuxBmcoCSSojE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Zva+SWeBtCyuNrQUj5aoJVlKQBwFMauhtpw/tkLHH2pOk9ArpSAX8v00FDy6W0L7w
	 oStwZc3XHIduuSGukJMd5al4b6PWscMP/xJM1Q4Fsqy53bLAJljgeo55EyEzEYOwTp
	 H4M79SetZ3VClukMI6FUAdXW0aKrNNu2eSPEL2QUnOQwGRHRXe0NlaCUb82XoUNWwS
	 xZiqJiVUqNmZayFZwj6iXTdk9xjaQHl6kpavBw3Rzm9vsN8A0+pGQyeLyF0rZJPUeJ
	 yOEKU5JQPmEiFOp4ZtpdT+zXb/RwDkapRsgfLU9vBOfBmUa749TkIAQq8BYjJRKGGs
	 kUYdi3dArJwaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D943E5381B;
	Sat,  1 Jul 2023 16:12:03 +0000 (UTC)
Subject: Re: [GIT PULL] second set of sysctl fixes v6.5-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZJ9q4AUkeaENryE7@bombadil.infradead.org>
References: <ZJ9q4AUkeaENryE7@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZJ9q4AUkeaENryE7@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-fixes-v2-v6.4-rc1
X-PR-Tracked-Commit-Id: 7fffbc71075dcb733068d711c2593127cdce86f0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: be21a73edd5ded67524eabb9dad42799b42c0585
Message-Id: <168822792318.621.6724226652558527403.pr-tracker-bot@kernel.org>
Date: Sat, 01 Jul 2023 16:12:03 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, trix@redhat.com, keescook@chromium.org, ebiederm@xmission.com, yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 30 Jun 2023 16:53:04 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-fixes-v2-v6.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/be21a73edd5ded67524eabb9dad42799b42c0585

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
