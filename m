Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AC8B1E
	for <patches@lists.linux.dev>; Thu, 22 Sep 2022 21:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39391C433B5;
	Thu, 22 Sep 2022 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1663883555;
	bh=YOz22V8asuitmkgetFBt4oCetDvmTaCAWuHPSQoOwP4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BeO6ggCdu4octpbflm4+l9Ce7b4inhYz5HMupft//djJ1LkQZnp2BZHnd12fqJyWj
	 Geee6qkumVbHXsqxBxWB20INvyhWwZxQO+q5Iods79iWhxcWm5PiEuibNJr+sG7ZDn
	 Zq25ZlZwYYDiHgUGdCfE5YaDcZkteU13yEOMV6A9b0XQOTcoQdK8+atYzWp8Z0sHR2
	 RTzJbUEL4BTHRe/QHiyQqBRuM3HHyho/JOeRFrm/Nd96OpOE4pgfY2NXWPLN4hZJ3l
	 V+PNfdNMUYgozkvTI5Scwwkd9/rXB0b4mWBIooG5qA2CAZEKZgL+K+ii2kxHYBINHC
	 ANVRmfpCrKUJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2428CE21ED1;
	Thu, 22 Sep 2022 21:52:35 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <9c0abd9f-5976-31e2-8802-e40270ad0014@suse.cz>
References: <9c0abd9f-5976-31e2-8802-e40270ad0014@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <9c0abd9f-5976-31e2-8802-e40270ad0014@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.0-rc7
X-PR-Tracked-Commit-Id: e45cc288724f0cfd497bb5920bcfa60caa335729
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3c0f396a386c81715e34472566cdd8f39dde5a6a
Message-Id: <166388355514.15587.4394762880683325339.pr-tracker-bot@kernel.org>
Date: Thu, 22 Sep 2022 21:52:35 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 22 Sep 2022 22:13:51 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.0-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3c0f396a386c81715e34472566cdd8f39dde5a6a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
