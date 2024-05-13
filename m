Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46031E535;
	Mon, 13 May 2024 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621924; cv=none; b=NT54TMPON6qwRhPv9sIm6CGrGSq/NeIxF/fKO99hkiyiJpjZtbYz/szlLjP1Q/Bo7LRxuCZq6yqMWw9UzdtRIbRQK/AMeFcvpC028SToKypiG63Cw5A/6yFkyFk62fzcRrpZG4H0Sx6KPtM/0+od+ak12Y6QfS6JjqM0DEspRfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621924; c=relaxed/simple;
	bh=Ygo94jP9ZGm4eS4r6SSSZPis2QABqD6PzcVc7HJP5mM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FpXw/zjKf2c+wqrP7dQGw4zqIqf58V26QaV0pierLDJa+Zi3/chc63MRZPJ6eabOVVnrFjzVt859WQ84sL1hRSVbhBRBZ0VqlYV0yE4rh/RTNUp9XEnR9vtdLZdb3j+IlY+0PuBHevkSW/yNuhJ8KLqqecAJ/PLn8z17aHDm7Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkibyKLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkibyKLf"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71962C32786;
	Mon, 13 May 2024 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715621923;
	bh=Ygo94jP9ZGm4eS4r6SSSZPis2QABqD6PzcVc7HJP5mM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EkibyKLfKcjvO+FNr8fAhtabVKgEQvqNi6+oWBGzZ93Y7VbGRRNq0rdTw7qnG8CSh
	 zZEAz0mkA8eNuVbhtIeSQNz59QHHW2ymTvMXzkjICuYIE1nn6s1UlUGeWnesr7Gmwq
	 NHp1ShL9VoZhV8Ym2R3UXyP09ZvozwfHZOUW2QKL6xEfjYU2GnpMprn9D2cGRGocF0
	 CX98RM23X3LSi4m5kRMd2cBpiHIPTuZRU/H57XVy9848hfqGnHdWuQq7vAP2wMG3U9
	 m98JWbtUu1Ux99//gdc1nZvkeFYSXrTAYujk9JVAnoPfTqq0ApTKQXjqDXbVkRNsRc
	 mabjVyXtlzP+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6824BC433F2;
	Mon, 13 May 2024 17:38:43 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
References: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <587f5e6b-d543-4028-85c8-93cc8f581d02@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.10
X-PR-Tracked-Commit-Id: 7338999ca3468404f547b1540211114cbdb26d06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd97950cbcabe662cd8a9fd0a08a247c1ea1fb28
Message-Id: <171562192341.32697.12124885998031799117.pr-tracker-bot@kernel.org>
Date: Mon, 13 May 2024 17:38:43 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 9 May 2024 16:25:05 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd97950cbcabe662cd8a9fd0a08a247c1ea1fb28

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
