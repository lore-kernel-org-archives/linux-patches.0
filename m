Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F938187571;
	Mon, 12 Aug 2024 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479914; cv=none; b=DT4jnwRtO+OjSXCgSHMCHjOkCQPkQqIyTHqMTB5sut0a9MqJIQRbLARPTRMlTKjroEgiuCkAHF3CobL/C85zaV4+tmXVL4fiFMO51Vz6TSpYY3LLKjTvEy49qZAbgOV8CUiyfP4M1n8TgjAB3jB4yMr3J4hFA/hhyJulQSiY6So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479914; c=relaxed/simple;
	bh=Au79qXyRJUK48UwDxAUcHfXfmzyXB8KJoJOWF2ZixpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpMGL7207WHFCZ2cNoWg6EISSet7ZO5+btGMqd3dJNjXxnq477U9czN2aPz90D/2R3KtSBoJWdNI2ZUIabj4cVi4ekoXd8srTHElVwzqKGnDFzvWaAW472UUuH7Lu9t/F7loNi2Ed/HZ+udqEon5tDfBwI5EtX8JsaETUC4Uc9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxLkaEuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxLkaEuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983D2C32782;
	Mon, 12 Aug 2024 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479914;
	bh=Au79qXyRJUK48UwDxAUcHfXfmzyXB8KJoJOWF2ZixpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxLkaEuTFcXv4Akka+h8p1krJqCqNcLNDVUy7piCt/8rwe0XreHQafYopES2bp44M
	 8HtBqFgsN84e93tf+pMgs273OoaqTCS8c2zB7Gg9+GBaYmR+dQwkgOeZjpUkL9OXSX
	 wTS4ups6ow0KSlaD6oWUpLhdP8GEztbn2oNfgY7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Whitaker <foss@martin-whitaker.me.uk>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Lukasz Majewski <lukma@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 039/263] net: dsa: microchip: disable EEE for KSZ8567/KSZ9567/KSZ9896/KSZ9897.
Date: Mon, 12 Aug 2024 18:00:40 +0200
Message-ID: <20240812160148.041308238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Whitaker <foss@martin-whitaker.me.uk>

[ Upstream commit 0411f73c13afcf619d7aa7546edbc5710a871cae ]

As noted in the device errata [1-8], EEE support is not fully operational
in the KSZ8567, KSZ9477, KSZ9567, KSZ9896, and KSZ9897 devices, causing
link drops when connected to another device that supports EEE. The patch
series "net: add EEE support for KSZ9477 switch family" merged in commit
9b0bf4f77162 caused EEE support to be enabled in these devices. A fix for
this regression for the KSZ9477 alone was merged in commit 08c6d8bae48c2.
This patch extends this fix to the other affected devices.

[1] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ8567R-Errata-DS80000752.pdf
[2] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ8567S-Errata-DS80000753.pdf
[3] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9477S-Errata-DS80000754.pdf
[4] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9567R-Errata-DS80000755.pdf
[5] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9567S-Errata-DS80000756.pdf
[6] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9896C-Errata-DS80000757.pdf
[7] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9897R-Errata-DS80000758.pdf
[8] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/Errata/KSZ9897S-Errata-DS80000759.pdf

Fixes: 69d3b36ca045 ("net: dsa: microchip: enable EEE support") # for KSZ8567/KSZ9567/KSZ9896/KSZ9897
Link: https://lore.kernel.org/netdev/137ce1ee-0b68-4c96-a717-c8164b514eec@martin-whitaker.me.uk/
Signed-off-by: Martin Whitaker <foss@martin-whitaker.me.uk>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Lukasz Majewski <lukma@denx.de>
Link: https://patch.msgid.link/20240807205209.21464-1-foss@martin-whitaker.me.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 077935cf5e381..3103e1b32d0ba 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2578,7 +2578,11 @@ static u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 		if (!port)
 			return MICREL_KSZ8_P1_ERRATA;
 		break;
+	case KSZ8567_CHIP_ID:
 	case KSZ9477_CHIP_ID:
+	case KSZ9567_CHIP_ID:
+	case KSZ9896_CHIP_ID:
+	case KSZ9897_CHIP_ID:
 		/* KSZ9477 Errata DS80000754C
 		 *
 		 * Module 4: Energy Efficient Ethernet (EEE) feature select must
@@ -2588,6 +2592,13 @@ static u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 		 *   controls. If not disabled, the PHY ports can auto-negotiate
 		 *   to enable EEE, and this feature can cause link drops when
 		 *   linked to another device supporting EEE.
+		 *
+		 * The same item appears in the errata for the KSZ9567, KSZ9896,
+		 * and KSZ9897.
+		 *
+		 * A similar item appears in the errata for the KSZ8567, but
+		 * provides an alternative workaround. For now, use the simple
+		 * workaround of disabling the EEE feature for this device too.
 		 */
 		return MICREL_NO_EEE;
 	}
-- 
2.43.0



