Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50587F
	for <patches@lists.linux.dev>; Mon,  1 Aug 2022 19:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D342C433C1;
	Mon,  1 Aug 2022 19:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1659383717;
	bh=2TqW5GGKgAnb//5ve7+nw+UYbVWuuggUZVUpH+HnM5Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FUab01FJDGVmsNwjnjt18+8oL6fsu4Ebqf3i4e9sT4nVv04wVrGkSgTBvqXobLfS4
	 GuglXdsgiIea2+DPHTFGjdFfu8GoJCOxarcL01o60e3cxdjGWMbP+7KZX+9REFHrWK
	 a9cY7iyZYd4LUcj9LS3jx5S1sjMo/3aQVd3ru//MT513+0aumM/XKpFwoygoZA6ys/
	 UAkP/XYS7B0Xghg3IEEiR/1nsD3cgbUQWlY4x9d756VvsLIfi8dY8wFuccK9Zz1Jyv
	 JlQES+/zc2CiK3+25hgd9SAyWwNIPdC6ZmwGPoo/LT5XdAdFkJBxtlDD+Zhxzda5cK
	 i+d+Dbz9bH9tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CC1CC43140;
	Mon,  1 Aug 2022 19:55:17 +0000 (UTC)
Subject: Re: [GIT PULL] slab for 5.20/6.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <9a5df89d-e27a-22b4-faae-be65f6c7f54d@suse.cz>
References: <9a5df89d-e27a-22b4-faae-be65f6c7f54d@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <9a5df89d-e27a-22b4-faae-be65f6c7f54d@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.20_or_6.0
X-PR-Tracked-Commit-Id: 3041808b522031dccfbd898e520109569f039860
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0dd1cabe8a4a568252ca70f7530c3ca10e728513
Message-Id: <165938371729.14399.15792906317724756271.pr-tracker-bot@kernel.org>
Date: Mon, 01 Aug 2022 19:55:17 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 1 Aug 2022 12:29:48 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.20_or_6.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0dd1cabe8a4a568252ca70f7530c3ca10e728513

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
