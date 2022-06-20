Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF2E2562
	for <patches@lists.linux.dev>; Mon, 20 Jun 2022 14:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1ED9DC3411B;
	Mon, 20 Jun 2022 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655736279;
	bh=BNeslKVmd3jvxQWIBQe1ylqJrzC04i9s7he5Fynox0M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dCNqyivp5vSaY/lYdisTmi5hMpBY8kcLfLzPOQEvfP4xWnGjDxHCC4HT9BambMhfZ
	 jQ0OBsuCmJF2ntkYQsqrrvmZXh07sVO7Z5VX7UHAg3rWv040KfXXRrvhLt3mIVn+C6
	 8bbj9AgaDxCRPubVjhcHHuF+JVcdOAy8TS6BrXS/IiAlv5S44GIQ3dSpGsyiFewHI/
	 ZDU1BIBjEHv+Zq4x2aVYPyRdg0DB9hxvkr/hYrO+eYEj8YA9x3aRq8eRxNAfFUb3Nm
	 MoaR6ssnAML+W3fq8IfWby1+agjb1lgArlVLAduQ/yoGPb9PwPppZCfDf9E2Ei1zEe
	 YwvYiguP6g2Pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A70BE737E8;
	Mon, 20 Jun 2022 14:44:39 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 5.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <a8082f00-3e00-f781-f5f0-20b4853b3335@suse.cz>
References: <a8082f00-3e00-f781-f5f0-20b4853b3335@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <a8082f00-3e00-f781-f5f0-20b4853b3335@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.19-fixup
X-PR-Tracked-Commit-Id: eeaa345e128515135ccb864c04482180c08e3259
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 59b785fe2abbe21267516799f6c584cf4fe5f08b
Message-Id: <165573627903.17677.13888569351342590014.pr-tracker-bot@kernel.org>
Date: Mon, 20 Jun 2022 14:44:39 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Mon, 20 Jun 2022 14:02:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-5.19-fixup

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/59b785fe2abbe21267516799f6c584cf4fe5f08b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
