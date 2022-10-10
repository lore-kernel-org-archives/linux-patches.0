Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA153C2C
	for <patches@lists.linux.dev>; Mon, 10 Oct 2022 18:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB0CBC433C1;
	Mon, 10 Oct 2022 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665427676;
	bh=D/TusV1wGqDf5oe2lHafYWpJKfX66C/hbrzmj6zq79U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bKDyhRUIBSJAlEoh0Q4pjsAE0gwNQh66BcGLG5Hps8/SvYYs3kcx5zLqiuytStYNy
	 9XKdwZmDr0QSMaQNmbH/fUphEuJfuuzEb9loGrQ0BW6BqrsCurV2UAqeXPRnp5zcWV
	 xDUdkLBDl28T8yeo8yKSJW28Ns7DVgUT13XGKpwUJcU00oIJV4SI6Bu0HSqpezlx26
	 dsC6M0f/DtUWCFLYvhfNvXdGnwWeCLxZUSVhVXlel6fg+yF9mhrKPBG/c5Caol+ZXx
	 MwpqmZqOsncHL+nFnNf8wzvO1msPJYi1zrtnBzT2X6DGw8+AWVLZ6e53MDGOBEePmU
	 JaUfiEByIPHtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6F9DE4D022;
	Mon, 10 Oct 2022 18:47:56 +0000 (UTC)
Subject: Re: [GIT PULL] slab changes for 6.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <d1eaa4f7-6b88-9c14-91d2-84cdbd4b8a31@suse.cz>
References: <d1eaa4f7-6b88-9c14-91d2-84cdbd4b8a31@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <d1eaa4f7-6b88-9c14-91d2-84cdbd4b8a31@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc1
X-PR-Tracked-Commit-Id: 00a7829ba8a44d720269e8a7562b51d4c68c03f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52abb27abfff8c5ddf44eef4d759f3d1e9f166c5
Message-Id: <166542767674.29715.15484058473718161771.pr-tracker-bot@kernel.org>
Date: Mon, 10 Oct 2022 18:47:56 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>, Feng Tang <feng.tang@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 3 Oct 2022 18:06:57 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52abb27abfff8c5ddf44eef4d759f3d1e9f166c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
