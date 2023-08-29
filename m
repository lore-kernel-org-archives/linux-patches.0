Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61AA17751
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 20:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D4BDC433C8;
	Tue, 29 Aug 2023 20:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693340333;
	bh=/GGZMXYAli7WBIKadqeGvtCE9PvkU/UbngH+hR/lhzQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PeRCMHFhcjS+oXm96e+3SfVEOWCvMfVGMQ2rCM9WyNAaHFKOIdENfFxHwgh3O5aSc
	 Qrv128XiQSm5grtKOlESMgq4zg2bNbe6TaphudSV+BVcwa1VVsJp58aK65/csuOWba
	 9Odw/YamT3bSBQK3WK04M8PE5TnyK6BFRrnJTSSPS76uQh3Vjpu6o+gEHJckM+0Xue
	 cA6TCvfzp2a41fCKGKDNR9E3Vak4u3Hkxf7tYapIG2Vn9UaEHMr7M4/ciFRAQyX12U
	 HOmLPGP8HTFUJ9UDZpV18Uhu9s7iNSe3Zmm3cDF3sIdqwithAARNClnQS6Q8CWKmV6
	 HfwAtXETTBR/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17AD4C595D2;
	Tue, 29 Aug 2023 20:18:53 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.6
From: pr-tracker-bot@kernel.org
In-Reply-To: <eea66c95-8b95-49b1-18f5-5bd92f73f60e@suse.cz>
References: <eea66c95-8b95-49b1-18f5-5bd92f73f60e@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <eea66c95-8b95-49b1-18f5-5bd92f73f60e@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.6
X-PR-Tracked-Commit-Id: 3d053e8060430b86bad0854b7c7f03f15be3a7e5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 651a00bc56403161351090a9d7ddbd7095975324
Message-Id: <169334033308.16899.15010161954904891513.pr-tracker-bot@kernel.org>
Date: Tue, 29 Aug 2023 20:18:53 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 29 Aug 2023 15:22:37 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/651a00bc56403161351090a9d7ddbd7095975324

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
