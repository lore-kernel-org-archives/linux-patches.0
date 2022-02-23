Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945696AA3
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 20:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 481DEC340F0;
	Wed, 23 Feb 2022 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1645646898;
	bh=rPvsHk9rO11ss9D+hCqp2bK02KgpNSQcTHp8HbGr4GY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=W4BRfXY2Ymt3eevB8M68rNwwpStykkiZwQ2K6QauRnyeAgfOlxJ3yH/D4CoTNHU5v
	 I5CQw8Aa4gloiOw3lUfNuXb5sNKWjkn6grS7s6r4464K0dWX6ZyjcoApvId2WAJiT3
	 EsgQTiOiv/Hwt/pu/BxGKuFLPxDAimdaneFsu+LMwXAGrweDAiHvd+p9Ek8wHeKtL8
	 M9RyXZ6oPx9ptMRPZUAJMESJsNp2CFUCH9l8Ol8NVOCDiV5hQTQ/ExIn7wb3YDgwmo
	 dPhH6CXp49IXE3hYVi65Mu65i5SZp2EINd2Pu87KK2+deP0FKy8347zwsHn8pdIUdB
	 zKV3TXQdttEQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 364DEE5D09D;
	Wed, 23 Feb 2022 20:08:18 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 5.17-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <02623bc1-fc54-bc5d-8879-e62d548924fd@suse.cz>
References: <02623bc1-fc54-bc5d-8879-e62d548924fd@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <02623bc1-fc54-bc5d-8879-e62d548924fd@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.17-rc6
X-PR-Tracked-Commit-Id: 221944736f66f38e9bdbce52c616d10df7f15c54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4eb0a7c8e195d4549221f9df3a0313254c493949
Message-Id: <164564689821.4348.3420955279683855883.pr-tracker-bot@kernel.org>
Date: Wed, 23 Feb 2022 20:08:18 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 23 Feb 2022 10:44:19 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.17-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4eb0a7c8e195d4549221f9df3a0313254c493949

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
