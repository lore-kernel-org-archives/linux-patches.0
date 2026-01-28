Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17E2E2DF4;
	Wed, 28 Jan 2026 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615984; cv=none; b=muj4R/QkGm4GlY+rTQciRYr3Q+QRsk4YsevyHrqna/BHHYHeedM6DjzY2IxE3+FnSyqc3vjOhaIpxw8bzWR/gy/5z5KnqK5gNDWOCREpVuonpBfW0TS7jBtNr/atBlbF6oQwjqZpkCJ+Kv3sL8S2B2qLlxnPVY63Ty9O6uAcJHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615984; c=relaxed/simple;
	bh=c7p+zTBO7YnQTke28NpFtFiZOMNV7xCnddtJtLxpCQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvBkAuY/Hx2D8Ll7zzlRjpVyZ99iwX0yS74GSqFCjkwf64gnpn4lquuYGKSsCbjIGXUkiGwsauzYhc1BazgbRE8DkywYMFOfg0meEPumi1tjOctLDUPK96tSUhw9nNbHRWPgFJO0ytRXP14wAtI1phUdpt4tPtLLxXyO2BdRECU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBVeZlI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBVeZlI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECFDC4CEF1;
	Wed, 28 Jan 2026 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615984;
	bh=c7p+zTBO7YnQTke28NpFtFiZOMNV7xCnddtJtLxpCQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBVeZlI7lGHP+sOAU0OgnpX+WViIM1XHuo//0LcunyAAi0H4EMhMfaluL7gTubfF1
	 ohCAsdbjdavxglx579ZHJ4KvFeUZMg/bkSMuX9lcFZjLqPt0nLZtW685Y+Qg3mN2mf
	 UKJYPq1eUSPXwsMh5F7fc5oYQeFru5JIT5sUpxYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/227] net: pcs: pcs-mtk-lynxi: report in-band capability for 2500Base-X
Date: Wed, 28 Jan 2026 16:23:05 +0100
Message-ID: <20260128145349.497854726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit e8ca461f7d19464b47c64fe4cf2f83162421bcc0 ]

It turns out that 2500Base-X actually works fine with in-band status on
MediaTek's LynxI PCS -- I wrongly concluded it didn't because it is
broken in all the copper SFP modules and GPON sticks I used for testing.

Hence report LINK_INBAND_ENABLE also for 2500Base-X mode.

This reverts most of commit a003c38d9bbb ("net: pcs: pcs-mtk-lynxi:
correctly report in-band status capabilities").

The removal of the QSGMII interface mode was correct and is left
untouched.

Link: https://github.com/openwrt/openwrt/issues/21436
Fixes: a003c38d9bbb ("net: pcs: pcs-mtk-lynxi: correctly report in-band status capabilities")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/b1cf26157b63fee838be09ae810497fb22fd8104.1768961746.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-mtk-lynxi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
index 149ddf51d7856..87df3a9dfc9bc 100644
--- a/drivers/net/pcs/pcs-mtk-lynxi.c
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -93,12 +93,10 @@ static unsigned int mtk_pcs_lynxi_inband_caps(struct phylink_pcs *pcs,
 {
 	switch (interface) {
 	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
 		return LINK_INBAND_DISABLE | LINK_INBAND_ENABLE;
 
-	case PHY_INTERFACE_MODE_2500BASEX:
-		return LINK_INBAND_DISABLE;
-
 	default:
 		return 0;
 	}
-- 
2.51.0



