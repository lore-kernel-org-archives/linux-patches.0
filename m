Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC57149C60;
	Mon,  5 Aug 2024 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722890661; cv=none; b=J06CDWtstuEHIs8dwWLE703YJ1FDO9Y/wilbL2MHkEC5i6QfEYRQkEIHcILBLTTSeRumWh4v6+JMedSc03M+UwofMOMYD/ci8uJN8jd69/cGnMoLmgKsjz+K95ur+nh9GZtEF/kcyZ9CCW7v5ssZUB9gJuMHYiqViYQdrht9QW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722890661; c=relaxed/simple;
	bh=Vla3+Xd8tqswmHzQh3qdpWDe0XZXwVu7NpYynU7IqV0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XhxljfV6ZlN3fQ98yo90JaDNBAO74W6yZl+oarmfO8/KSbzBgUHviqxMI1nnK2FIZN8GqKQBLGanVzIp3pD47JnEpkbCNrKs93n8XlJTNSmk1VDThUPl/8FkKWi2BwKx25o6TDC4noAnQ4ZN4p6keUURT7uM0wJ6JaQJpbiaIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1IgVlSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1IgVlSq"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7DC7C32782;
	Mon,  5 Aug 2024 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722890661;
	bh=Vla3+Xd8tqswmHzQh3qdpWDe0XZXwVu7NpYynU7IqV0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d1IgVlSqxpqnfdwyuOQMJHWaydko8lREgC4BkS3mpGyIvqb4BNVxzTCXnoHfIBy4n
	 /2/uec8/oRd+LRbMQbCSaOyl6q028pgNcV+zyVSduo7hRuq/Cpwt/OA8PuuRmDQmmH
	 aH/hJGu1a4bgZMAXMQM3rHzhRq3X27l4OGToEVDtgagu7I/Uff6wDp0XGevJNLoaAG
	 PTBVfYq1OUOS4nEgHyReV0y7YWilHVlQgrrRDldJfhfgaUG0idAiFil/DScxGmlUhR
	 MtlKWXH8z0+gHdKetBRL/MMejNHZUJb13PXbO+YHYaAfKLXzCtZK6l1xpGIA41l7Dk
	 FWAj17ZZvt1xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C22D1C43337;
	Mon,  5 Aug 2024 20:44:20 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <983737e7-7894-428e-be51-355c959ac31b@suse.cz>
References: <983737e7-7894-428e-be51-355c959ac31b@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <983737e7-7894-428e-be51-355c959ac31b@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.11-rc2
X-PR-Tracked-Commit-Id: a371d558e6f3aed977a8a7346350557de5d25190
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c813111d19e65b6336a6352eae9c1ff5c40f722f
Message-Id: <172289066063.27723.4496627071268199582.pr-tracker-bot@kernel.org>
Date: Mon, 05 Aug 2024 20:44:20 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, Rik van Riel <riel@surriel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 5 Aug 2024 12:00:33 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-fixes-for-6.11-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c813111d19e65b6336a6352eae9c1ff5c40f722f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
