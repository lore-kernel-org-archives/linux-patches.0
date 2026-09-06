Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F45634B669;
	Sun,  6 Sep 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706958; cv=none; b=p9bpB8ggu6EHvA1sAwVITmwmM847kaVb66VGWZWpBH8+rKLvqtdfBUEmJe+1EQy3LRfmnnZqdlc0/WsYefhfcZu3RufFeNkXW/NtC3anIG/K2Wdlo6ZXj7u82pVBrUoV9DJhxrTVU20/mPK800KigYtHURkJ4s8To2BPxNGce5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706958; c=relaxed/simple;
	bh=MUmnn83VSG43OwuUtlYeLYw3vgS2TPzN24PzVkSNaS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2RAXu9JjzwZId6tK70p+zhCKUQmrtRCj1Sdq6dWJ8WZ+OZjQOsItJD/4wc638Edgmx/a7ceya35DyBTDEdH38SP3tPQiYXjdAoIAVqGY0U8C/sRXVrxds75cLIRfszXYnxdG993oU/qi0noYUVRInOjUUXFVmX8gEX9ZyleCTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQGH6g1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQGH6g1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749CB1F00AC4;
	Sun,  6 Sep 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706957;
	bh=gEdc+3i6wTh14GtuWS3/qG7Eu3Ybt3buksdhTdfZKns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQGH6g1ejz9lEHgXkVgQHzRXrmyAtnvyG1bfn2CpkcxqIwzshYj/M0+dNYO6rXyyr
	 hU7G1H7LPRhxC2gmr5IZF0x7v/ixtd3J3Mvmsda265K5exboy10/CwePeut+XLy7zm
	 pNm5OCUHhYVCZMi1hkon+ayYLao2BEjwlhBCR1AXYppZjG+osl4pLT2u3XQtviFO0R
	 1ESjeUDRodw7WzW65h9wdw2E61Qw0FDi/KpJ7HWbhGXxX7zS5a4jxZeepiEyIKqCMl
	 65BsWkOTLmnV+8GE3eugGcCRNjpFMBmJ3/Cw0gglovvD2iIXM3QHwVbWa3vLNi/oGv
	 wMq4c9E/JuVLw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Max Lee <max.lee@canonical.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 296/403] PCI/ASPM: Avoid L0s for Realtek RTS525A
Date: Sun,  6 Sep 2026 11:02:28 -0400
Message-ID: <20260906180700.reply3-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <727fa752-98f7-40cd-bf3c-79b11ca551ae@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045741.576327723@linuxfoundation.org> <727fa752-98f7-40cd-bf3c-79b11ca551ae@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Without those prerequisites or a 6.12-specific fix, I would suggest
> dropping commit: dbccca7f5d2f ("PCI/ASPM: Avoid L0s for Realtek
> RTS525A"). Thoughts?

Dropped from 6.12, 6.6, 6.1, 5.15, and 5.10. Kept in 7.2 and 6.18,
which already carry the three prerequisites (4495bffd86ba,
575b98e39d81, 30579eebba6a). Thanks for the report.

-- 
Thanks,
Sasha
