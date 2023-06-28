Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B910EE
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 23:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5A0AC433C0;
	Wed, 28 Jun 2023 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687994145;
	bh=jQtG4oSQAoL4fFfOh4CXrO5qW72f8Y4h+6N2u/DUTnU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UBN6HVyNJ0eKxeA7gCr2Tyg0GQbxiMyB03lH5xqzckkEDlK7nbOB3Vj/eqN7moo3j
	 AAr9fmVddbpBMIOR4Z0u7qx+DG0YM7uW6fPFrF3TjiQeyIcp1jzWlfAuq3Yk5bX55d
	 WGbI/FK5RepIGmo517wYOLsD6tp49ayItDI4MlPTajrA9Oudj6yHWZLdL8B7TnyWsV
	 xyTRwj1wtOvSBVXR4qQ4kL80XHwgKgE0IqRQUgtfUfa3tmgehnRLh1RODpNTN8A37l
	 q0Ycr9PH8TjzEGoWFwHuAClpNHoYHegH+5LuqyYP0VPrIFBRuCt8QOxb/86N+ifQ84
	 3WaSltBzW8YqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E0A0C0C40E;
	Wed, 28 Jun 2023 23:15:45 +0000 (UTC)
Subject: Re: [GIT PULL] sysctl changes for v6.5-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZJx62RvS9TwjUUCi@bombadil.infradead.org>
References: <ZJx62RvS9TwjUUCi@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZJx62RvS9TwjUUCi@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/v6.5-rc1-sysctl-next
X-PR-Tracked-Commit-Id: 2f2665c13af4895b26761107c2f637c2f112d8e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a8cbd9253abc1bd0df4d60c4c24fa555190376d
Message-Id: <168799414556.32317.4109949634442251096.pr-tracker-bot@kernel.org>
Date: Wed, 28 Jun 2023 23:15:45 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 28 Jun 2023 11:24:25 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/v6.5-rc1-sysctl-next

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a8cbd9253abc1bd0df4d60c4c24fa555190376d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
