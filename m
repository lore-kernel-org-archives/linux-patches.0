Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C3FD506
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 05:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg7BX7z9"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B67C2C433B8;
	Tue, 31 Oct 2023 05:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698730963;
	bh=fXjJabqEutx6kAr72Ev7BNb6tL822p/XDSi4+ZXat88=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Kg7BX7z9STCHjkf7As4hHviQsgO7grGMFJo6K2/VPzl/7LUnOOaetkJvcnMoIx9UK
	 XmZ83GSrr90hzeviKid2K72K+5yJNdncmA7oyXdSjvXaAFV9jeHLTbz2N8uBSe6PpE
	 qFd0n3COaLThmyWUX1yjsV7G2BN2TfZ7orcz+34XFN32gNWgWLu8PbAPNEeFn9NeUw
	 AjX12txv2VDS4HPqqVBF/2aHpbyx5k82V88uYbByeEuckRKsy7TDJfKGSo+WKESopW
	 /PwdDvi/OC/p+UbJe35Dp9SkUASUfI6OQV7c/otC8evaEZoUb6Y+IqbFHdBHeSwCQ6
	 M8ryZETK02gIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4B75C4316B;
	Tue, 31 Oct 2023 05:42:43 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.7
From: pr-tracker-bot@kernel.org
In-Reply-To: <7f4cd48e-492c-24f7-6fef-e3b50eace6ba@suse.cz>
References: <7f4cd48e-492c-24f7-6fef-e3b50eace6ba@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <7f4cd48e-492c-24f7-6fef-e3b50eace6ba@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.7
X-PR-Tracked-Commit-Id: 90f055df112162fd9e093c16be1c21f38c35b907
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fdce8bd38037a4a2b2961ca4abffaab195690b30
Message-Id: <169873096367.17204.4045017742877657426.pr-tracker-bot@kernel.org>
Date: Tue, 31 Oct 2023 05:42:43 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Feng Tang <feng.tang@intel.com>, Jay Patel <jaypatel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 27 Oct 2023 16:38:19 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fdce8bd38037a4a2b2961ca4abffaab195690b30

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
