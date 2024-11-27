Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545EB1BC3F;
	Wed, 27 Nov 2024 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732732414; cv=none; b=GbNFtln/2iLmUenYfyLUINr51Bj1a4qdW67bDWVWWL8aDCkDl8EKhN+1zFHx2imnMVbypJd33hCocnqTRNq3Z+CeX0RzglnxJ/l3wE99s3EZtRHqHH3GXm401feJh+RfYnFQxrVHVrAX/5vXolMCyB7Y+9fi2BaFU0A29+T+4xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732732414; c=relaxed/simple;
	bh=eGFFwsQa9bBEQKwqZzR/QnOAW94wEiML8VUkw3AsYl0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lTLcY3wPuW8wbN6VJg1kSPDZWZ2g2kHdhu3u6WqHhKauC82aJqi9xN716YQHD6W1MUBvROzCPisXLDrh5nUieSFj0S/MVUb4S4tZwhpQgD5Qu7FKcLZOp1+Veu/x6/dEDtQfbNE+m4zY3MTYixpTk7NaUTMrjRdDj0ly0eetdt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQCtusnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQCtusnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC8AC4CECC;
	Wed, 27 Nov 2024 18:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732732414;
	bh=eGFFwsQa9bBEQKwqZzR/QnOAW94wEiML8VUkw3AsYl0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YQCtusnqyKr09sT47h0Dxh4GmExt/WDAswUlWOcLRoRL6Ubt9zf0xOaYmXAZAsZNR
	 tJoYOvRrxZthqT7R4T9msDZHJiflhiNlHw8r40Vq1vD2pthT3T4+LnASSxsz10vJwB
	 Qa6NPtSvDdQelpdzy4Md7iLJe1A1xudAlC/mrRhj79Ae/o/X0oXi6qytO2Jc9q/u9p
	 CpyTJQPXxJzHnD1PVzUWTe7IjH4pX0bkHYVRgv3IODm4QyXn7/MrAqk15qm8pxDldx
	 LcQJRnckQDoV2rOnVZbpk2Sg1pjoez1Xry6lyIdqyAWAej+Y0SU0Hsj3YJBY6DK6Pi
	 bwt/9N946sUSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 721C9380A944;
	Wed, 27 Nov 2024 18:33:48 +0000 (UTC)
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1
X-PR-Tracked-Commit-Id: 2466b31201424ccb7eda00277222302a4d6576cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b5361254c9027c2b3730be1bebcdb37eed42e9a5
Message-Id: <173273242698.1173535.1621384732319196426.pr-tracker-bot@kernel.org>
Date: Wed, 27 Nov 2024 18:33:46 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, masahiroy@kernel.org, mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 26 Nov 2024 17:10:32 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b5361254c9027c2b3730be1bebcdb37eed42e9a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
