Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3199A450EE;
	Fri, 29 Nov 2024 19:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732907994; cv=none; b=duMsZyTmo7/b/Rx92dpcE6kYHTywak2cvpXyIE8pUJXd9bg4MhIO5Zu0FDrnyMHPtiSKvTMi6HEr5aZGb7Do7e8OujqD7Gga6mMP47OSMf1YF8Cs+r1K9pWbUghikP6QxGi7Qzhv8OT2OZAQP+QtWcWRQbSBN2LmMIqpmzauHT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732907994; c=relaxed/simple;
	bh=N0R9fuHuP+Aam5eKycEo6pKAy95ex427QgL7eTS5U1c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pzqp57i8T+gyrbr8LXPUrsW4sD7lmGIc3fwOcgkv2pNrP4mx9XNJ8J62pPWCOELI9jRt/CZz6x+gXYWhximQujrLH9nRFiXv+1B3YCQ1FuXrsqqmeGSsf9rGFJpMT/LEzdLTGp0bkeCBkJs9bvCTSZu+xbFIdgr9tSFd4mZiKgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9OF0Rpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9OF0Rpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D46C4CECF;
	Fri, 29 Nov 2024 19:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732907994;
	bh=N0R9fuHuP+Aam5eKycEo6pKAy95ex427QgL7eTS5U1c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f9OF0Rpvs0rqL7QqjcDt0cYkXXR8qSKMbD+Vv6HwAbqP+vh6wmtP6atdiR9p/qNng
	 XfvHNLCifKUV0fB35xnKy9HZ7Rr9Lzzj417kj/E0Y2M5W5OrrcmkkAqAfsCA6YkB6R
	 4sFnM24kjXCZvGY3PsicmWsN7dowbDW6qH/f/UYSzBl/EBEfiJ8jPfNN5DJZzL6Mij
	 jpsOLOeSo2FFCTD2kjS18gf13ue9i5iLW62arfw9KiZIvj+FZOtQd7Pc2wHE4wTi6S
	 TJIOna/j5B9jP1St4/CPQw7BDNPIspVF7ATekNscEG92PczLNjcaq40yVFI4V6P1yg
	 sKt1tuLeQMOaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE2F0380A944;
	Fri, 29 Nov 2024 19:20:08 +0000 (UTC)
Subject: Re: [GIT PULL] Modules fixes for v6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
References: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
X-PR-Tracked-List-Id: <linux-modules.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1-v2
X-PR-Tracked-Commit-Id: c5efad88a94613cf60fed010b96dbc3044389316
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 93e064ce854abfacdeb0ac526a13ad29d093e813
Message-Id: <173290800727.2154162.7216402406203444354.pr-tracker-bot@kernel.org>
Date: Fri, 29 Nov 2024 19:20:07 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, geert@linux-m68k.org, masahiroy@kernel.org, mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The pull request you sent on Thu, 28 Nov 2024 11:27:00 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1-v2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/93e064ce854abfacdeb0ac526a13ad29d093e813

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
