Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981401465A8;
	Tue, 25 Jun 2024 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308968; cv=none; b=eGto8GyHXQBAzr0bpeHhtytKA2dLijMkkqPER0l2iyaIYj/1cQFqIobrYFsrz1dSvM5WYqpMx5EG6qyJRULqoLvYEhoOCe0q0dSPl7yh9zVsqW/LFvXqtRdHL4Mac351FLdd4TzSAQ3TRFV/o2JuFmZsk388jqQQROURopcqD+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308968; c=relaxed/simple;
	bh=UHco1SL+fx0taciQ+p5a8+YrvOYqJ2foG/L9T5A2hnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bak7ZgWY0f5WDyIflDTXbeyhc4LZQfZStjdxypy4U6MmGSUhy14crfcotQB5nC8rc8RwEKVR3oHNB3aaexDokw5ZEv3bSnhX2tuALNOZ44Mleu4syOCcUR5M8xCv05bYfYa9n37xKmllNu0IPgoe0wccrqItfEEKZwUxX8Hz1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRxZcZ8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRxZcZ8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1DEC32781;
	Tue, 25 Jun 2024 09:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308968;
	bh=UHco1SL+fx0taciQ+p5a8+YrvOYqJ2foG/L9T5A2hnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRxZcZ8AWHh+pv5unpQsZe/RKoSnCQqA6B/BSjsKng9fwk6mWPpAEOtRZZGwdJrbb
	 A9UeQvL+GmBUCrBuXhomL1aIIdJ5ka2ai0YC65jUENX7d8D9Tfx8L7NxBNCkUgzAt7
	 8MheU3FUeG1RC8jF5naDqbBUFggVoH+glpRovnLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>
Subject: [PATCH 6.6 019/192] net: sfp: add quirk for ATS SFP-GE-T 1000Base-TX module
Date: Tue, 25 Jun 2024 11:31:31 +0200
Message-ID: <20240625085537.895060294@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 0805d67bc0ef95411228e802f31975cfb7555056 ]

Add quirk for ATS SFP-GE-T 1000Base-TX module.

This copper module comes with broken TX_FAULT indicator which must be
ignored for it to work.

Co-authored-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
[ rebased on top of net-next ]
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20240423090025.29231-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 8152e14250f2d..4278a93b055e5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -482,6 +482,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_F("Walsun", "HXSX-ATRC-1", sfp_fixup_fs_10gt),
 	SFP_QUIRK_F("Walsun", "HXSX-ATRI-1", sfp_fixup_fs_10gt),
 
+	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
+	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
+
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
-- 
2.43.0



