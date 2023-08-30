Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72CE15B8
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 03:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACE4FC433C7;
	Wed, 30 Aug 2023 03:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693367894;
	bh=8eJm2umkBvn6T+8obX8Fe/8clowchwHQAEIUxR9hPf4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Nh9j1H/EsI0xm+ObwygKrU9tQD9abAxLFn14aY+qFi6QVoQmZS063Mln7i43vE56g
	 dBS8Y+Vi9ceCQIfP1rnyl8GwCDKDBeSEMtDgjunoxUnaUJdOzE/8V75NApSpQ/Cjv5
	 /s6WaJHf1OXY6lcmsMWZZ39uOu9z56VTCOUQWjbwlUOEYKqwvzZw2rp0ek7lEt1Q9P
	 AAvE8NHwMknt22+Y/J+oa0MGYqqSEbVLVHm42VrvunadFlyCcVwLwQNU0j/4cm6bc/
	 wpetxY5B0f1dAoW/pI1N77W8AiViKJTWSbVc+K5LGwfIzS4m5TWjc6NoZiBvQ0iM53
	 blagCdrmNw/NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9ADD5E29F34;
	Wed, 30 Aug 2023 03:58:14 +0000 (UTC)
Subject: Re: [GIT PULL] Modules changes for v6.6-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZO5M45JsJYzNF59H@bombadil.infradead.org>
References: <ZO5M45JsJYzNF59H@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-modules.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZO5M45JsJYzNF59H@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.6-rc1
X-PR-Tracked-Commit-Id: a419beac4a070aff63c520f36ebf7cb8a76a8ae5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: daa22f5a78c27412e88d31780c4a6262cda559cd
Message-Id: <169336789462.6268.1786295356990012160.pr-tracker-bot@kernel.org>
Date: Wed, 30 Aug 2023 03:58:14 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, gregkh@linuxfoundation.org, manuel.lauss@gmail.com, kuba@kernel.org, kumba@gentoo.org, palmer@rivosinc.com, masahiroy@kernel.org, rdunlap@infradead.org, zeming@nfschina.com, rongtao@cestc.cn, arnd@arndb.de, pmladek@suse.com, chenjiahao16@huawei.com, christian@bricart.de, peterz@infradead.org, song@kernel.org, keescook@chromium.org, thunder.leizhen@huawei.com, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 29 Aug 2023 12:54:11 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.6-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/daa22f5a78c27412e88d31780c4a6262cda559cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
