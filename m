Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42D1841
	for <patches@lists.linux.dev>; Fri, 27 May 2022 00:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86E01C36AEB;
	Fri, 27 May 2022 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1653611576;
	bh=HSuH8lQkNnQvGfRavnp/3y3zXzXllGHmcd834/c/yBk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Lr5WuaeWBuCMbGojH1h0EPHBBoaQeh+t+QncjMqbzhSBrZrXBtIeTfP3lhyP11xQn
	 oDhtEjqeksrnz71Lsd5curaNhC5Z3iBwAHeaNER+QLv8QYd9kjC9yeRAjrVmGZlmZE
	 J7OWr1umkswLKOCSIAiu3VVeSXa0EwVOjnZC96IZpxoYQklrDRDCkV9lCgWP8qTJTr
	 XTlXAPAnSHl7qNcfljIpCvg1JDyugCQDpT+fEsp6cQDNN+q+ZIBVsgYAjBnw8/7aT1
	 C+PXAG93Z6JxrlHg3iHBkFpUituJ4jBJaTM0V1qF13fEuUS+zJI3xXwThhzaa+MT2b
	 UWLHc+ZPuGcnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71A80F03942;
	Fri, 27 May 2022 00:32:56 +0000 (UTC)
Subject: Re: [GIT PULL] sysctl changes for v5.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <Yo6x6uatAbdsn0JJ@bombadil.infradead.org>
References: <Yo6x6uatAbdsn0JJ@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Yo6x6uatAbdsn0JJ@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-5.19-rc1
X-PR-Tracked-Commit-Id: 494dcdf46e5cdee926c9f441d37e3ea1db57d1da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44d35720c9a660074b77ab9de37abf2c01c5b44f
Message-Id: <165361157645.27205.15620664423908667724.pr-tracker-bot@kernel.org>
Date: Fri, 27 May 2022 00:32:56 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, patches@lists.linux.dev, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Zhen Ni <nizhen@uniontech.com>, Baisong Zhong <zhongbaisong@huawei.com>, tangmeng <tangmeng@uniontech.com>, sujiaxun <sujiaxun@uniontech.com>, zhanglianjie <zhanglianjie@uniontech.com>, Wei Xiao <xiaowei66@huawei.com>, Steven Rostedt <rostedt@goodmis.org>, Yan Zhu <zhuyan34@huawei.com>, YueHaibing <yuehaibing@huawei.com>, liaohua <liaohua4@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, Vasily Averin <vvs@openvz.org>, yingelin <yingelin@huawei.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Konstantin Ryabitsev <mricon@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 25 May 2022 15:47:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-5.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44d35720c9a660074b77ab9de37abf2c01c5b44f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
