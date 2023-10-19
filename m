Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B43354E2
	for <patches@lists.linux.dev>; Thu, 19 Oct 2023 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJxKvPeE"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA8ABC433D9;
	Thu, 19 Oct 2023 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697740576;
	bh=M0IOD1bLhffOCN7lz+jWIRSmTB9VtAvHCtNSB4MsfIQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dJxKvPeEGS2do7WL0z4DQxHInZipw4qsKzQ6tADAwQWBWXJ6Y+LYFdKH9iWLR5Rni
	 +btMHhPbfGBKdIujcr8rdJJBWU5TwViwOM78EuTPG4zZ1EcL8nUrmcRRj7G96fMQgl
	 PEr5ZPJfVEpWwmuL0/1hn400xBZxr5o4lCKmZ/ggdFI6956CP6vfoHJ0D55rxNGAb2
	 6mNy4mvKQcdfiriqNBWMJ1cYe6qRVwIo7HIVqXsTMPVuDu6pf2Tiizjheh3s1IladR
	 BA5VJOIb3oYGdzRbqO7sADMyu29WrrVSum57WOVDxTC9KJ+Yyv7eHYK22HfasTC4JJ
	 vOuqpeqMcXz5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C384BC73FE1;
	Thu, 19 Oct 2023 18:36:16 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.6-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <06eb77e9-a058-6b0d-d0f6-2f4733e6ca00@suse.cz>
References: <06eb77e9-a058-6b0d-d0f6-2f4733e6ca00@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <06eb77e9-a058-6b0d-d0f6-2f4733e6ca00@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.6-rc6
X-PR-Tracked-Commit-Id: c15cdea517414e0b29a11e0a0e2443d127c9109b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 54fb58aec47a49a80534d2ccabd319334d6b0ef8
Message-Id: <169774057679.20290.12852615009577377755.pr-tracker-bot@kernel.org>
Date: Thu, 19 Oct 2023 18:36:16 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Catalin Marinas <Catalin.Marinas@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 19 Oct 2023 17:20:00 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.6-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/54fb58aec47a49a80534d2ccabd319334d6b0ef8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
