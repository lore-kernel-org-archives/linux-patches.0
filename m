Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5A12C234E;
	Mon,  7 Sep 2026 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788744160; cv=none; b=gfkK6oJ64lMqhGFPfxNQkHgcjwbmSxMTE0hyvrp2atP8WeR8SliFnGdaVgNDCCvRa4MJiaq0AKwdX4kSdhK9XOCtngn6xNW/tDsrg6yqozYkHc96lmWYiAizWdsGF+Ypz3pbbpEsRjWBjus55nFkSO5Jp061V9RlQ70wG4J9ujI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788744160; c=relaxed/simple;
	bh=LAXs1XKHKuqFE2NnTaTndYwCNsYF3izcMgMsuDmyX4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ/j45IZpFPkzWd42wqCA9M5XWYtqHJUS84UzrwZiKLUbxnO5Vyxh6mxZQuo4uj8Ti53xyyBjvyZfxTSRaU7TRaDK1Df1bAgaMtg9/J+JHfgRLI3e43epUJEdKJz+tldaI5O/iXhM890dU/2jf+cUgH94T7DXL9jgiud2B3phwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6tpGoOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6tpGoOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EA61F00A3F;
	Mon,  7 Sep 2026 01:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788744159;
	bh=+WQ79gPOTZ/Xf9j8tRcNeQCHW+7wYVBY2AB7HgsQGUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6tpGoOMfQiyqrRwcj8l8WpxLEY/wpEdnMWeUhDXE4wmBA+Ck9IyM8wAPaeG3/1ok
	 Hwl4y9m8S24IP80ACX2kBJL91Pdzn7wl/c8u47dKunk+J/gDG5ykRo8ll3v4EPFIkt
	 8Z0LybA07ysOt/ylaOjbTkTS/1x6ch86m0T3VMpP8qLp4Zvch1tHAltrAuwflGUDU2
	 qw+rSd5mTB/lR66XxMbA2c/xPyNCl114XyVB16Adu+n+Tn0PWzq6Aw7JnPPkkh01O4
	 PrGiEchRvUmF9gc4VjXhZH6Q8cP8wfb6KBkvsFFTwtyoHM6Tp9A5aj2EqSWU4FNSUJ
	 omUxByFCzgJXg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 348/403] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Sun,  6 Sep 2026 21:22:32 -0400
Message-ID: <2026-09-06-daily-reply-0002-ntb-tx-enqueue@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7da02d81-ebfe-4448-b6d1-9209cb9282fc@oracle.com>
References: <7da02d81-ebfe-4448-b6d1-9209cb9282fc@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses commit: 8aaa47351db0 ("net: ntb_netdev: Fix TX
> busy and drop handling"). So we should either pull in the prerequisite
> or drop this.
>
> Thoughts?

Same gap exists on 6.6, 6.1, 5.15 and 5.10 too, not just 6.12 - thanks
for flagging it.

A backport of that commit would be appreciated!

-- 
Thanks,
Sasha
