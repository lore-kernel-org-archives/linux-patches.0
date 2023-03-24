Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53574C950
	for <patches@lists.linux.dev>; Fri, 24 Mar 2023 17:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDAEAC4339E;
	Fri, 24 Mar 2023 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679678149;
	bh=KrjiDQaOUAvwQXctCJJ1xKGvf9WKffnW0brnRQ1xCp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FpYVh15XZKhcENjTUinTA3SnkEZhZtMO+IzkRhPQeCet962agA2JUefL3CRitm0oA
	 xlxyYEOatzUTDERPDc/uNvYV68grV745yvzrW1EBBk/d92M3f18+A4PXJj0uehexVj
	 bDeKw01zwMXcvZG5SwTcxoPGnxPeyglIp+VlgAllqlPKPQ90RVK1yseNLcb3BA4s8i
	 MOmP3UJ3MqWmSMVFIeWUmGm44b3JOGtj/MKdTAUoN2OwO/zWJ2TVWJQV8AjaoAprDf
	 4i+5615NSxR0JQAFhr08Zq14dC8/cFnVrFOI1AyB6Ex2VEyw8tIK+2k0V4sYm9oAt2
	 FHc9p0OS9XSXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9756C41612;
	Fri, 24 Mar 2023 17:15:48 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <a329d2a9-9617-e00f-3bb8-3f5dcf07329f@suse.cz>
References: <a329d2a9-9617-e00f-3bb8-3f5dcf07329f@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <a329d2a9-9617-e00f-3bb8-3f5dcf07329f@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fix-for-6.3-rc4
X-PR-Tracked-Commit-Id: 66a1c22b709178e7b823d44465d0c2e5ed7492fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb7f5b41f8341148050fe63e27cf52aa4f1519ad
Message-Id: <167967814881.905.634782433585733452.pr-tracker-bot@kernel.org>
Date: Fri, 24 Mar 2023 17:15:48 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 24 Mar 2023 16:04:53 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fix-for-6.3-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb7f5b41f8341148050fe63e27cf52aa4f1519ad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
