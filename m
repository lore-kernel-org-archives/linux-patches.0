Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AAA15749B;
	Mon,  6 May 2024 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715017500; cv=none; b=Qbqd1O5X66okXX5/9I1IqvWDUe92dSlWRX20U5r9/Y3/IqSu4IhRUS6fDzT+bhjeeo4HYPlyr8dZGK4mPO5EWqTKeq1UdKHhOdW8oTra+g5/Ihc+KHAOVeuvamTvWFBKDxH5kSRvxbgL/K9lueUsL/Q9/zzt5Q6XYVVpHn4QWjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715017500; c=relaxed/simple;
	bh=D4w+D4H9B5FgKfUeBJnwbBIIjf7Fdp1Gec6yJvtU8so=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=k279QFqwW5NWmVaoun/I8ZG4Qy/dlbQDqzXMaSpmJZmzHDVRPRRU+qCx/s5mKF6hWZG88M5aUbvILvQpBW0x0fzmDYaKa3IQx8VlT0Hx7fiq+sYaKsNwfq/a7Rz2rgikf+YBZMFUO0sP20Ih6K8mqXk7S7UUhPy1MdaXjnv3f4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+3wChS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+3wChS0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5713EC116B1;
	Mon,  6 May 2024 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715017500;
	bh=D4w+D4H9B5FgKfUeBJnwbBIIjf7Fdp1Gec6yJvtU8so=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=E+3wChS0uSo7N/UUsFkR8gUuxg0q3CqJ3pTCIcaQcWwm5i5fYYBr+mKR7Ez66Cf8V
	 dTR3sXg3mWqDBVCe+HPom5swakWaexOIaSFozu5wv3cQiQ3c8SwVMYWCLHFskM6Ffp
	 Ew+Vy5NmbL9KCeuLpc4pyDHyQdeOge7FwxWw+HSVEv4N9dATdZnsUUbu/P2mBMMDCP
	 5uxXQcsYd2JwMHpz96RPhltum90YrJaucKMTShWyoWxNN/DIfK7HQMnVO8cccFqm4p
	 FzZXJGJDbzd2v8BaxYf0MYpnWtf13S2pzOK9I+DPCMTLfq+eQ/gaaOC0rFJe6YDogg
	 NvDebQ6lQhUtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B65DC43334;
	Mon,  6 May 2024 17:45:00 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.9-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <eea90337-bea4-444b-8f92-576ee242a497@suse.cz>
References: <eea90337-bea4-444b-8f92-576ee242a497@suse.cz>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <eea90337-bea4-444b-8f92-576ee242a497@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.9-rc7-fixes
X-PR-Tracked-Commit-Id: cd7eb8f83fcf258f71e293f7fc52a70be8ed0128
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ee5b455b0adae9ecafb38b174c648c48f2a3c1a5
Message-Id: <171501750029.5526.8089414495054360166.pr-tracker-bot@kernel.org>
Date: Mon, 06 May 2024 17:45:00 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 6 May 2024 12:03:11 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.9-rc7-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ee5b455b0adae9ecafb38b174c648c48f2a3c1a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
