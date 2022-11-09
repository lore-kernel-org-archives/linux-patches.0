Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1858D107B6
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 21:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4F9CC433C1;
	Wed,  9 Nov 2022 21:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668030186;
	bh=SBI2U8Oiw5cPX2Imz+FgPuDE28UreagZAZu8rzbUVFY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BqOHEAf+58y9x40lO2Iy3FbM/A3qSNY0eJmtpGZrQpY3sIrcn5jf1grHZDhlbK1PM
	 AwGdj9GItB/cohcTCb2ZPOej4blZX+7h0bqJs90/ccGiC6e/ZJcQhLWa2Nwv1VZK6l
	 xe3psX7QfhET4b0/8l5k5gr41D+WZXzM4jSLMZLrU0RAVBipX2DLWzIAemxBPBhrEH
	 2mTj4Sq0KXv7AGtv2vkn+wqrRCGbC+X/YfexuwAelFk6PuZRdunv7B6ngq0YhGyTxG
	 3AlpI7J5Xm5LyM2hcaYfbYn0iNjEz5lMRvubnXu+EqRUTKRHCFuxpjZwrkbV7SlfhN
	 R5JFf13gtKjoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F9D2C395F6;
	Wed,  9 Nov 2022 21:43:06 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <87a751bc-34be-b96e-f157-9c841d153f52@suse.cz>
References: <87a751bc-34be-b96e-f157-9c841d153f52@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <87a751bc-34be-b96e-f157-9c841d153f52@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc4-fixes
X-PR-Tracked-Commit-Id: c18c20f16219516b12a4f2fd29c25e06be97e064
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f67dd6ce0723ad013395f20a3f79d8a437d3f455
Message-Id: <166803018664.15129.2926975971526216006.pr-tracker-bot@kernel.org>
Date: Wed, 09 Nov 2022 21:43:06 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Kees Cook <keescook@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 9 Nov 2022 15:48:10 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.1-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f67dd6ce0723ad013395f20a3f79d8a437d3f455

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
