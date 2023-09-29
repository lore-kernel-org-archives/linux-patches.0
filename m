Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A67B405F3
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 19:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73BF0C433C8;
	Fri, 29 Sep 2023 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696014913;
	bh=F2fwHp2G2UWjujD4j+jNDesMDV7SSkL6P1XyJZeMlMc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=W/ZVurQZOSut7lYYC+4HEuS40nbxIC4+4G0G1S1bxALWOuCKeUc/iTEAipyHoic/6
	 eIa3xb24nK8c7VCRn/3kdLsQhaEy0O89G/JuTLwCkzqdMoVNiBRlkRED8XZcqhOdfb
	 xUcaTkFLcxFCutU+o26DCFUix9G7xPFpVQJzYxd3CfuqE+hbNcJoXnbQSDxIY3AOiy
	 fv9NuEkSLMLdJFsn5YS8pb1n6Ux6dQ65WzbX7paKsgwaxolPSBCHkkxy06josHWT5G
	 qldsdcVbQdpxFmVNoZ6YYS2sxTW23sj+mGpU6CUuzowlCcDbyk0LjQPt/cTXBix1zK
	 q/VbttR/FtryQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D77BC395C5;
	Fri, 29 Sep 2023 19:15:13 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.6-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <70699482-f413-d7b8-6378-48bc915d1ecb@suse.cz>
References: <70699482-f413-d7b8-6378-48bc915d1ecb@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <70699482-f413-d7b8-6378-48bc915d1ecb@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.6-rc4
X-PR-Tracked-Commit-Id: 8446a4deb6b6bc998f1d8d2a85d1a0c64b9e3a71
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1c84724ccb1a9f6eaf727ded49dd7e22ac62cc5b
Message-Id: <169601491337.23736.5581455098554984692.pr-tracker-bot@kernel.org>
Date: Fri, 29 Sep 2023 19:15:13 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 29 Sep 2023 09:52:02 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.6-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1c84724ccb1a9f6eaf727ded49dd7e22ac62cc5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
