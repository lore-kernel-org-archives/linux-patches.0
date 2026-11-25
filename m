Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624768;
	b=vXbAWJkvkWQQkE1b15QousDrqfC2CenoqV4g1tcEjB8STjnl3T8Ax8u9bzwFFhpx6pXR
	 YPiJMdSedBGM/t9IILHkwd0MHgVSFe3PvUpihTJgRag7kxFP1+UEOdPrmNxwpE89d+fbW
	 UJH9912W9HA0KC/eZ6SvAsn7qv6dzDrStGVtRpUEyQpKHxmR0vpIK4aewyone+OVSHeWO
	 6PegYen1M/I/RK6hKHmiUjoAjE8d0cY39kanKoODGJM76xO0lISJbNy/02OK6qf1NZJ0+
	 xSw9ZPj96q/0eLRFOx2mDf4rWXWStJpvFWY/viwjhv+X0gO51WH0OE5nU+qDEbO/e7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExkgRmUHJ/TcDzCxARwSdyuu586GInj24vxvr3qUmZI=;
	b=i7k+Z4b6Yjjr7Rz6EZ34bZhln4O4R5Csa6avi8yTbObJVKCb8WMF6nZoMfxpKu9nJ9Xb
	 J87XgsNQRRk7TC94NOvtZ7ld/8Pug3faAo+7CShcQnI21WzeylVSBpFq7UBu9UMx1iIEj
	 veKwjNmGSn61y5fwDpjlPKf5rXcU22lKHzXkmcb62xuS5k1GNZFkbUPo+S8gISppAGKBP
	 YaYGAx8huPSrZPA6qESeROACcHpDitIBBlTNceO+K3mbMrIigdjpj7A86Seci/QBng7Fu
	 lhzAK2xoe1PBnvPSTNz7s/lOq/MXEPJi0P6K6rmo9sNw4GplOhg4qjX62Rk0CNVJQiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKYhN7D6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E3606A33C;
	Wed, 25 Nov 2026 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKYhN7D6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E01F000C0;
	Wed, 25 Nov 2026 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624767;
	bh=ExkgRmUHJ/TcDzCxARwSdyuu586GInj24vxvr3qUmZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKYhN7D6JNZ86zppHq4ZUGOZ7PY5km2uIIkgNSSGGWUbwerBxlJUE30Y0K8B0X9Nc
	 uMJdIBpQIBHMNXBsgQXS81NBlqgEhGUCLR1QYDl/amayJB2wxKVrlcmkk37h3YR9eg
	 V/rVHdhUTstzRySX4uHYUgFibeLg0xTLtKgkNp+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/816] ata: libata-scsi: do not accept subpage code FFh in MODE SELECT
Date: Wed, 25 Nov 2026 15:30:22 +0100
Message-ID: <20261125143855.553501096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b29c40dc150b0b4218c4d6844770892eb6b2f6b5 ]

When the SUBPAGE CODE of the mode page in a MODE SELECT parameter list
is FFh, ata_scsi_mode_select_xlat() rejects it for the control mode
page, but accepts it for all other mode pages, i.e. for the caching
mode page, the only other mode page that it supports.

However, FFh is not the subpage code of an actual mode page: SPC-7
(7.5.2) only defines it as the MODE SENSE request code for all
subpages. SUBPAGE CODE FFh only means "all subpages" in requests, i.e.
in the MODE SENSE CDB for mode pages and in the LOG SELECT CDB for log
pages (see SPC-5, 6.8), while the SUBPAGE CODE of a mode page in a MODE
SELECT parameter list identifies a specific mode page. Also, SAT-2 and
later versions of SAT define the Caching mode page with the SPF bit set
to zero (see SAT-6, 10.4.9), i.e. without a SUBPAGE CODE field.

Remove the ALL_SUB_MPAGES case, so that SUBPAGE CODE FFh is rejected
like any other unsupported subpage.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-12-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d6b1cdf4dec27..2f70f1c228945 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4344,19 +4344,11 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	}
 
 	/*
-	 * Supported subpages: all subpages and ATA feature sub-page f2h of
-	 * the control page.
+	 * The only supported subpage is the ATA feature sub-page f2h of the
+	 * control page.
 	 */
 	if (spg) {
 		switch (spg) {
-		case ALL_SUB_MPAGES:
-			/* All subpages is not supported for the control page */
-			if (pg == CONTROL_MPAGE) {
-				fp = (p[0] & 0x40) ? 1 : 0;
-				fp += hdr_len + bd_len;
-				goto invalid_param;
-			}
-			break;
 		case ATA_FEATURE_SUB_MPAGE:
 			if (qc->dev->flags & ATA_DFLAG_CDL &&
 			    pg == CONTROL_MPAGE)
-- 
2.53.0



