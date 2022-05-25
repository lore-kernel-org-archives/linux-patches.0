Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916BE7C
	for <patches@lists.linux.dev>; Wed, 25 May 2022 18:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EBFAC34114;
	Wed, 25 May 2022 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1653503857;
	bh=55P97EI1sLAlykvLY61Yl1lUBMxk37aA+RZ+wKeRITI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mU2WO+Fh9WoOeJU+SVnq5jyzhC8G85h8wImw9BPI9FbDVHW8CnVMy2regjugGq+Ll
	 5FSidDAtKxPbR0R0zp8CK4Psl13sdepKlWOJaF9tbYM8nCRwqOAO8l/A4y14BKaGBI
	 oIdpSilYGcrtlP9UOG33zKH2JtwbfX8PezBlPbYS3+YlIY6SHhXD/8qw5rF7AnHthI
	 s3ejE0uvD7vNGJfF0XGJgOXb4HRUKlWQXoLLsuYbizHVxRbB6nc5t6cebR1t46vIsH
	 4Xl7RBlv7EIzUbV3cPqpx/nQk/sQft23qyc5LIz2tw6bki+72PGFlqH1y2UhdDs9Yv
	 3iGHJsS+fG+EQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27E15E8DBDA;
	Wed, 25 May 2022 18:37:37 +0000 (UTC)
Subject: Re: [GIT PULL] slab for 5.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
References: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <8062f61e-5a4d-00a5-be1a-7921d3277e9d@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.19
X-PR-Tracked-Commit-Id: e001897da62eb543ef79bf173f145c2c9677f66c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e17ce1106e04a7f3a83796ec623881487f75dd3
Message-Id: <165350385715.15754.10929787075579258153.pr-tracker-bot@kernel.org>
Date: Wed, 25 May 2022 18:37:37 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 23 May 2022 11:54:08 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e17ce1106e04a7f3a83796ec623881487f75dd3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
