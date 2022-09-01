Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762796AD6
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 18:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22400C433C1;
	Thu,  1 Sep 2022 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1662055517;
	bh=djm/H6971ldga3eCAQ7ZfeYfbmhDth2drr4zw/yfL0I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=D6cCkdecqqCj2QaMni8IuwGumPvXK6lho3FUR9H+mATwH/HdW6rYHC0hTrNDj1zs6
	 qhkPdMrD0x4BjS8kGayw8cMVCl+8xDr7s/S8Wlkkwo5ZtAkSSaqUqr/1eBzWWoA0rx
	 PJaAsdMnTnwaiCkK1eglUOfijyBX5Efm6M8BmHjnl22Ev6bIVxMPHEpXsBcf9mQaXj
	 ehaGbhPKsXv9eSiWJY2IFD2mzLC4MIeiPoEACqSZbBAVBry7otnT3sZdf64XEPjFmW
	 OfxUyBaXJ+m3DB8Ot3yxTbAJb9azV0FkJLDTTqaqTDx2Pr9S8HUXU665Wb0E3H41g6
	 t7cQiDN4yEXYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A0A4E924D5;
	Thu,  1 Sep 2022 18:05:17 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.0-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <72c237d6-df43-fc3b-4948-6d9a34ef3ba8@suse.cz>
References: <72c237d6-df43-fc3b-4948-6d9a34ef3ba8@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <72c237d6-df43-fc3b-4948-6d9a34ef3ba8@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.0-rc4
X-PR-Tracked-Commit-Id: 0495e337b7039191dfce6e03f5f830454b1fae6b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d330076e1d4b0cbaec477e1214f6f8df27da2bb8
Message-Id: <166205551702.13559.17299489648439764853.pr-tracker-bot@kernel.org>
Date: Thu, 01 Sep 2022 18:05:17 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 1 Sep 2022 15:51:48 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.0-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d330076e1d4b0cbaec477e1214f6f8df27da2bb8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
