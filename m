Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED48653
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 12:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3B7C433C8
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 12:47:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=phytec.de header.i=@phytec.de header.b="CRYYAGcL"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 16 Jun 2023 13:46:59 +0100
Resent-Message-ID: <ZIxZwywNyzmBdWPq@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 14 Jun 2023 14:08:08 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=BLRj=CC=phytec.de=T.Remmet@kernel.org>)
	id 1q9QEI-002AhM-5r
	for broonie@sirena.co.uk; Wed, 14 Jun 2023 14:08:08 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 585EF63CD3
	for <broonie@sirena.co.uk>; Wed, 14 Jun 2023 13:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id C5CF7C433C9; Wed, 14 Jun 2023 13:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A2AEC433C8
	for <broonie@kernel.org>; Wed, 14 Jun 2023 13:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 3A2AEC433C8
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=phytec.de
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=phytec.de
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a4; c=relaxed/simple;
	q=dns/txt; i=@phytec.de; t=1686747170; x=1689339170;
	h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=W4aY2dtVSQrTCXa8xdenfZv/tWJRpvPvBQU636eWqd0=;
	b=CRYYAGcLHk2xIk6mNrj1F7eWN9cavT0dVv+vKrWIb7bd/s6S3Y6xMSa8TnsNK6NO
	MjhmXjtiFo2UNKcRAbBmBN8lkbJhpBgKgQibQaYhwVePtSQSKzeIZ7oepmf9Jt5U
	PccXiQkUOamd3I+ceQpU6NB1eRYmIUFfAxf/c0GMl3Q=;
X-AuditID: ac14000a-917fe70000007ecb-5c-6489b822b1fe
Received: from berlix.phytec.de (Unknown_Domain [172.25.0.12])
	(using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(Client did not present a certificate)
	by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id 27.84.32459.228B9846; Wed, 14 Jun 2023 14:52:50 +0200 (CEST)
Received: from augenblix2.phytec.de (172.25.0.11) by Berlix.phytec.de
 (172.25.0.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 14 Jun
 2023 14:52:50 +0200
From: Teresa Remmet <t.remmet@phytec.de>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>, Robin Gong
	<yibin.gong@nxp.com>
CC: <linux-kernel@vger.kernel.org>, <upstream@lists.phytec.de>
Date: Wed, 14 Jun 2023 14:52:40 +0200
Message-ID: <20230614125240.3946519-1-t.remmet@phytec.de>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.25.0.11]
X-ClientProxiedBy: Berlix.phytec.de (172.25.0.12) To Berlix.phytec.de
 (172.25.0.12)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRpKBR1dpR2eKwaE+K4upD5+wWfQuPcdq
	8e1KB5PF5V1z2Cy636lbdG84y+jA5rFz1l12j02rOtk8jlxdzOrR393C6rHx3Q4mj8+b5ALY
	orhsUlJzMstSi/TtErgyrn3fxVzQyl5xpXUXWwPjC9YuRk4OCQETiQXNT9m6GLk4hASWMEns
	X/GOEcJ5wiix4eE6FpAqNgENiacrTjOBJEQE5jJK3Hq/HqydWcBOYuLKq0A2B4ewgKPE8ldV
	ICaLgKrE+uPyIBW8ApYSX2Y9ZINYJi8x89J3doi4oMTJmU9YIKbISzRvnc0MYUtIHHzxAswW
	AorvunSSEaZ32rnXzBB2qMTWL9uZJjAKzEIyahaSUbOQjFrAyLyKUSg3Mzk7tSgzW68go7Ik
	NVkvJXUTIyi4RRi4djD2zfE4xMjEwXiIUYKDWUmE96lGe4oQb0piZVVqUX58UWlOavEhRmkO
	FiVx3vs9TIlCAumJJanZqakFqUUwWSYOTqkGxoWqXqnKG97dPrX9xeR+FbP5IjtWh/yv/xsa
	tlwvYzr3632HPJo+fCnSlLp4fvmh2KeXPX54nf38Y01URkN04UHZudrf1IsMu9J2OxzqfnSV
	OVP/xKKAb7K8mset1x5IKjyalRZkKVoZlFgYPWfFQbuqNXEl+zLLeXYXX3z+8iWz1fOlV2Zt
	UVFiKc5INNRiLipOBACL9VPIXAIAAA==
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=BLRj=CC=phytec.de=T.Remmet@kernel.org
Subject: [PATCH] regulator: pca9450: Fix LDO3OUT and LDO4OUT MASK
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: ErNSQUUFgxI7

L3_OUT and L4_OUT Bit fields range from Bit 0:4 and thus the
mask should be 0x1F instead of 0x0F.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Signed-off-by: Teresa Remmet <t.remmet@phytec.de>
---
 include/linux/regulator/pca9450.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index 3c01c2bf84f5..505c908dbb81 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -196,11 +196,11 @@ enum {
 
 /* PCA9450_REG_LDO3_VOLT bits */
 #define LDO3_EN_MASK			0xC0
-#define LDO3OUT_MASK			0x0F
+#define LDO3OUT_MASK			0x1F
 
 /* PCA9450_REG_LDO4_VOLT bits */
 #define LDO4_EN_MASK			0xC0
-#define LDO4OUT_MASK			0x0F
+#define LDO4OUT_MASK			0x1F
 
 /* PCA9450_REG_LDO5_VOLT bits */
 #define LDO5L_EN_MASK			0xC0
-- 
2.25.1

