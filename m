Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2590F6134;
	Thu,  2 Nov 2023 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSnQYQiF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9162CC433C7;
	Thu,  2 Nov 2023 07:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698909797;
	bh=TGEyMuVSbjIh/jEbfoCyC2DUpT+BmvyOKrikyBOWfw4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lSnQYQiFI6vQUes5Mch00GcxxB3qRRP4tIWo8n7MJeG7uFEvPMV0FSLeFjwx+OfpN
	 W5Z8rvN1r/fPGiF4KurjomGscSz6/5RY8EIuAEqrFAJsKrQpDfU/1sMPJqcFWOqLyA
	 RCGAY3aDrIYU1dBxFVKzUOw+6zjyZfX3FUZCFTAcxPralL83FH6nYRkQY+5eK314UB
	 iNgYU3McJ5imlgB2kGQl3nfLZR8Q1IhqHLx9etuCwy3hUA1B6uwwT0bVH5nW3XNe6d
	 1QNtpU9YMqZgPo4jJ6ZNqP4CL49WQVAs9Q8KILMQSn+p1KF7t45y+/UtpZ2jaGkCHr
	 rSIgVSG+AVz+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D570C43168;
	Thu,  2 Nov 2023 07:23:17 +0000 (UTC)
Subject: Re: [GIT PULL] Modules changes for v6.7-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
References: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-modules.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.7-rc1
X-PR-Tracked-Commit-Id: ea0b0bcef4917a2640ecc100c768b8e785784834
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 21e80f3841c01aeaf32d7aee7bbc87b3db1aa0c6
Message-Id: <169890979750.20895.63719470937187142.pr-tracker-bot@kernel.org>
Date: Thu, 02 Nov 2023 07:23:17 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, andrea.righi@canonical.com, keescook@chromium.org, zhumao001@208suo.com, yangtiezhu@loongson.cn, ojeda@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Wed, 1 Nov 2023 13:13:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.7-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/21e80f3841c01aeaf32d7aee7bbc87b3db1aa0c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
