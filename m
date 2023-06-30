Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F9646
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 00:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9553C433C0;
	Fri, 30 Jun 2023 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1688084593;
	bh=4D80tJAtN1aaG+JPSSDIV/UPKKZefMl3hzH2wq2ZLEQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gsNj7MbFL+buphbRQTuTjLuh2PKUf3yhWOYkQV8TQD0btV6FOwa8tu5SzaIsEK2/R
	 UrJCxb9p4+cJn4z1zv2GJL/vIHug0vSSGMlQWfon+HTqeYQy8V8nMJjbkKkUACv8q9
	 hIZVFro69TT5R9mQVR0cW0/wYPtSqv3Z6DVjLPOiTzlLm7L2QWg6FBR32rU3nB8Vmc
	 zwk3aS4gsFqLxGpWpA5lwzOXVjxlMfeGVqHX9su0VHpiYATjQRdtxrVKWLKOEa01Zn
	 gXeubc2zRC3MbaD9L9hnwCyUBO9HOhGUqfr9CBwMWcm2QtreFdjV3eYM5Oc5KkFAS7
	 bWO7aAzGmDy4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5E9CE5381B;
	Fri, 30 Jun 2023 00:23:12 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.5
From: pr-tracker-bot@kernel.org
In-Reply-To: <1c39c9b0-ec37-f910-2b09-cedf7acf6e91@suse.cz>
References: <1c39c9b0-ec37-f910-2b09-cedf7acf6e91@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <1c39c9b0-ec37-f910-2b09-cedf7acf6e91@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.5
X-PR-Tracked-Commit-Id: 7bc162d5cc4de5c33c5570dba2719a01506a9fd0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 632f54b4d60bfe0701f43d0bc387928de6e3dcfb
Message-Id: <168808459286.18676.11809401059160966086.pr-tracker-bot@kernel.org>
Date: Fri, 30 Jun 2023 00:23:12 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>, David Sterba <dsterba@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 27 Jun 2023 09:37:55 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/632f54b4d60bfe0701f43d0bc387928de6e3dcfb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
