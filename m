Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F445009;
	Sat, 28 Sep 2024 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541908; cv=none; b=oFJXlIjzVjR8ebYUi9MrhA84uZI6CzTXaYkrkptbbY+7Z4YWL7vRjLhR58EE6Kq2RoOo6De3mZgCbjbbC06VPK6j0Dz8vrFGlO1YTPnygk+S3LgdIiLoKZp7n9OkdTiKqRusNCgrfozTR04mI5Fcavsnd4+Qdx7gSr2z9KLFOlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541908; c=relaxed/simple;
	bh=ERtCtS0fQs7KR5xgzlrxodSeCITZlOCFrL4gvMPGbsE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K94p7jlZuiW9nXkk8/znC4hZlIpRGWSezvLR9gYvLzl5sZuO4TNFq1d7oS7Cd7VBYT25lq3B0wfYagzsrvxFWQX8tBxALZNNCH8NBP5MbSTCxePQKmHkVwXhN8BRBOgC1jemLH6BJb5LuTg230DDU1XMOhbsKlBKErCAt2l0mdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkG1UP63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkG1UP63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886BBC4CEC3;
	Sat, 28 Sep 2024 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727541907;
	bh=ERtCtS0fQs7KR5xgzlrxodSeCITZlOCFrL4gvMPGbsE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GkG1UP63/1GHgi7pUv4XlBdHLzm7GNz0LEKaGE+gBlxsGkQz1s3ZVQkxyftARk91K
	 V7GXJN7k3tOd7N9JNZKhQNIm+RMmudySmeUn2oJxPciEE8Va9nObib3VyaWQsv65HX
	 rRfdJVUtmUPuAEyc+kFF6mWFdducdaqdOznbyiKBNPctbooj+vGYEwKqiz1ge7XtoE
	 VJZZOIo1bwM/6jWMOAOlDunZ3IB+VmK6Qm4htl2gb1gFr6WxLcvMHcGkMZ3zDUjeO9
	 CpDVBldN/IIrYsfw1PkiXeB7wLHZYiuWzZa63XGGNIdSgTIqvUC1VE8g7tHKo/cdAa
	 VR42sfZiASaRw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F503809A80;
	Sat, 28 Sep 2024 16:45:11 +0000 (UTC)
Subject: Re: [GIT PULL] Modules changes for v6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZvcjnE9Me0hCy4yK@bombadil.infradead.org>
References: <ZvcjnE9Me0hCy4yK@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZvcjnE9Me0hCy4yK@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.12-rc1
X-PR-Tracked-Commit-Id: b319cea80539df9bea0ad98cb5e4b2fcb7e1a34b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f81a446f86106c68630032e114024ec7a557077
Message-Id: <172754191013.2302262.17894339790402930398.pr-tracker-bot@kernel.org>
Date: Sat, 28 Sep 2024 16:45:10 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, vdonnefort@google.com, song@kernel.org, catalin.marinas@arm.com, chunhui.li@mediatek.com, xion.wang@mediatek.com, masahiroy@kernel.org, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Fri, 27 Sep 2024 14:29:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.12-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f81a446f86106c68630032e114024ec7a557077

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
