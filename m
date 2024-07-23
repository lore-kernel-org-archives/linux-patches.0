Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE841803E;
	Tue, 23 Jul 2024 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721761425; cv=none; b=jR1byMDllcdwZQWpwMh578XLdYIFMvDemO8keSyZtUDT7MQguXlcQsDXDN8Gg6WM1CXxCfr9Fqx7BJmS2vdl+ZV7kmVTEuFgIgD6OJxQltP0pXxrQ+GEu5gDz0PVnIFYdxQRNS/VW1wDEQvd3j3KJEuWil8v1TzxWheKk1h6wJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721761425; c=relaxed/simple;
	bh=W9rjHqk3tVYIaj87CZl4OK/lXQOk5Wr/Y5fP7ydjT9g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oqhYOs6iqX0nR/Sux9EWuUTDF6oj4tGoZRP5byMqhFv+o8YqhZLcxw2WHb7GrHwoK2W5Mk3yl8oyXz8xjHIy5NQQHVJWVswyDSuSP/rfN7wpuqpJVOqEZJtgqjaDZ+Fjt6dq14+7dgUU7+63lRpPjAqfP+PH+TwIN7nLxVGDuLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgTUj0IC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgTUj0IC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C565AC4AF09;
	Tue, 23 Jul 2024 19:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721761424;
	bh=W9rjHqk3tVYIaj87CZl4OK/lXQOk5Wr/Y5fP7ydjT9g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FgTUj0ICF/RhsNYuBp/Ugf+WJ40oEPYxI0TgRpsHBreuaDDdDlm5aFF/d57uQFXK9
	 PRDVE9jUEqGP+43YL9XGi7m4CT0FV7sz6vA8euFgmQM8zf0Xz5zwEMnLmojja+qO+/
	 nGalskRd6iUrEd/vxSK1yUro0RdsGqHXhlWt07lYjDamMgtk9OPA61GnUPWPhMXzIH
	 GrX5r17IDQnZk6hlo9h0CMtIFWayJo55WEAabWq4BMRva3rzawPiHhtOti5TtNd8dy
	 bPGXeVZ449hVa6zxcZFdnX6B20itN6637rrby2lCradI7U9DvtgTE8LKksPtjYTw5n
	 hmeTwayI9tYmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBEBEC43443;
	Tue, 23 Jul 2024 19:03:44 +0000 (UTC)
Subject: Re: [GIT PULL] Modules changes for v6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zp_k2XEViIlDavXX@bombadil.infradead.org>
References: <Zp_k2XEViIlDavXX@bombadil.infradead.org>
X-PR-Tracked-List-Id: <patches.lists.linux.dev>
X-PR-Tracked-Message-Id: <Zp_k2XEViIlDavXX@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.11-rc1
X-PR-Tracked-Commit-Id: 61842868de13aa7fd7391c626e889f4d6f1450bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f488790059fe7be6b2b059ddee10835b2500b603
Message-Id: <172176142476.11519.3165189063000430046.pr-tracker-bot@kernel.org>
Date: Tue, 23 Jul 2024 19:03:44 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, jtornosm@redhat.com, lucas.demarchi@intel.com, mcgrof@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Tue, 23 Jul 2024 10:14:01 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f488790059fe7be6b2b059ddee10835b2500b603

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
