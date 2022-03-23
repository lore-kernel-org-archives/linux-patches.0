Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6E566C5
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 19:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A04CC340E8;
	Wed, 23 Mar 2022 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1648065050;
	bh=O3iYQzZDFKFaYEai80v14IX9o5YoNsm8i6KJUIkzXZU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cKtC4SvyRdUtveHA/I6PWwd6iDz3wOe7FTBAw/i1wxB6pDfi/918Py0VLKJOlNVsr
	 EY7GiF48x3SXsZnnniAQqpgF3YlXwQ3ZBULHq5UZU8JEpBSvTjEbYW+0aq088QY7xx
	 bIXFywyiG30HEVnRr6EnAZK0rQheAIyZPvI/4diTMJCsvwXnFZG1BZ6dHm77feLVhs
	 oYAfTMbVyLvQbEYlfTOsj7Z67whHTf+UoT/i+5QZCNSw7gQ2dfQ7FkagD8VMEAexDp
	 5sR0FBkDJRxCotcGjkoKpXKnOOc3p0c+i9eNRmicNCPczlmtydek9Pcorfg8Crm48H
	 jG2lACOqOadDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0490CE6D402;
	Wed, 23 Mar 2022 19:50:50 +0000 (UTC)
Subject: Re: [GIT PULL] slab for 5.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <ee1fe9ee-c560-9f7c-c8d1-bd48c608ba90@suse.cz>
References: <ee1fe9ee-c560-9f7c-c8d1-bd48c608ba90@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <ee1fe9ee-c560-9f7c-c8d1-bd48c608ba90@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.18
X-PR-Tracked-Commit-Id: 94fa31e99b57ce4a56e93815421566d483186cb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5c009e2503d4c027591c65b49a98f420cb4fa56
Message-Id: <164806505001.21505.5331298391907150342.pr-tracker-bot@kernel.org>
Date: Wed, 23 Mar 2022 19:50:50 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 21 Mar 2022 20:02:58 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5c009e2503d4c027591c65b49a98f420cb4fa56

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
