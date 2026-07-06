Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19366378D76;
	Mon,  6 Jul 2026 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346912; cv=none; b=bo7S5qY+sKZ7ltDRAnql+HwoRRDluNh2sMR+V4vlduP88Zo97i1AAOfX0LqiUsVyUPWk4WXVmxfjPMO+f7hg4SbA2rurPkJD4si1lyBqn93no2lk6O8aR/pKcrTZirb+EX6LnBere3Q/N/FkRDXRnuzCXRJ1JQEQKkA4gNJTqww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346912; c=relaxed/simple;
	bh=HvQhDRGEbXASDitLcYtvHLvgKjj1+r2Z4Z4E7Eatp1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MppFb77cPMzo56wwSyl2XmGxAdgTJB7dyPF2COsgsb1ANXuXvDEpPrXB/yjJ8yJwtwbjTLs0eoQjFb02J/4rpIj3h6xrKb0TjRJVnrLT6d0YmVyrSXikJoZwVdhKyITdi6ErtiuLve54cVYPJrxSCSNOiJ7KY/Jv0ovJraJHN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkSXdDUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkSXdDUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999741F000E9;
	Mon,  6 Jul 2026 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346910;
	bh=8M5fBpMa4WYLrMLZ7/qkHUo1NNQJNLS8VFNofstRWEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkSXdDUguhUKIIAyXzty43yBeDvyKVFolhLybpKDmaG0XcSvdeoo20SXD6nTVAgWx
	 +XXxBnSxaaiHMPdcDsL1if48DOZWWNJBb1YsB5wsrl/6DlqaqZEiWCPG5p6Tq+TEzh
	 FF8JKG2eo/x52JipX493dgHR8cc1qHlOOnGigKqB5SPEQBLX/B8PfBxU70dRu0zk9d
	 ABGjUUJaVHnCL5ZMaDNQv5ZC1woqQk7ynHtdhDOj8tHclOdGUNt2oMzVcf7cm6VCZL
	 fzRJcFbpibM1DYjiYmLjR76P/UlQYzS7s3KnTd0u4R01EzzWjqfcuZjy/WRLL3i3Mp
	 NWHdg43dj2tqA==
From: Sasha Levin <sashal@kernel.org>
To: geert <geert@linux-m68k.org>,
	Ben Hutchings <ben@decadent.org.uk>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	wsa+renesas <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>,
	Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH 5.10 94/96] mmc: renesas_sdhi: Add OF entry for RZ/G2H SoC
Date: Mon,  6 Jul 2026 10:08:21 -0400
Message-ID: <20260706135124.draft-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <OSCPR01MB14315350989F1BD556CA5B1E9AAF12@OSCPR01MB14315.jpnprd01.prod.outlook.com>
References: <OSCPR01MB14315350989F1BD556CA5B1E9AAF12@OSCPR01MB14315.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Thanks for pointing that out. We could drop this patch from stable 5.10
> and I can backport this patch and commit 71b7597c63d2ddf6 to CIP
> kernels <= 5.10.

The patch already shipped in v5.10.260. Since it's behaviorally a
no-op there, I don't plan to queue a bare revert.

Prabhakar, could you send a proper 5.10.y patch adding the
sdhi_quirks_match[] entry Geert sketched (.soc_id = "r8a774e1" - note
the missing '4' in his line), so RZ/G2H actually gets the ES3.* tap
quirks on 5.10? I'd be glad to queue that.

-- 
Thanks,
Sasha
