Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E97384CED;
	Sat, 17 Oct 2026 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254362; cv=none; b=TfdhtpVpI7eDCvQWcWAFwHig9TqHivTCcPGzcDiRTGQvFwb4lpYRwaUkHJWumb4uM8n1r0f36VIv+FTODBxOc97YoiYDyZmrocizWfFlhAHefSdAH+8xKGvkkiWAKhjas/cmhwVqoXkQy2ZoGfB8WCh+lO7GrSKM/E76htQUIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254362; c=relaxed/simple;
	bh=VeW5LUwEqV/90vIQyrtUrxGOSq4NDzPsEnlV6C0eNj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh0LngvAhcCtmGKPpHtQYu0rqpVqPgLhZGbIHz+Jz7K6g5GhC2XEbcgCe/U5su+sbWThe3ZCcJ0EXQcaRj0j1a53IpTpmpBPvLk4PlSFhoDa5s3D6jqvjzvjroxw1wEVcc81y8QTahUaBUQJLf+DMS/vbAUTXHgBFlBP7gGHTuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdN92Qhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdN92Qhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26AC1F000C4;
	Sat, 17 Oct 2026 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254361;
	bh=KcWwselLDHjWyucpXKzMQJtYCnGGAmAju+qi5Bs2pCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdN92QhheNPNA21vAedr7/WJgc1vGCqYwTipDMN2aAkM5zlnB7GgUIAUlt/s4ZKwS
	 KwDLFWVuVMAHcsn1qeWp/L2N/BzeAoNjDKWWAhairk0QUDykvGJGfsdEbud3/jxqF5
	 iDvclKdvc8n1zjFtOSF0Yga+HgsHims4PjZsvapc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@h-partners.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 419/869] ata: libata-core: Disable LPM on Silicon Motion MD619{H,G}XCLDE3TC
Date: Sat, 17 Oct 2026 17:54:20 +0200
Message-ID: <20261017160047.880063313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6ce0dd9f54ea9773c0aedfaab7b858fc68a848ba ]

According to a user report, the Silicon Motion MD619HXCLDE3TC SSD and
the Silicon Motion MD619GXCLDE3TC SSD have problems with LPM.

Reported-by: Yihang Li <liyihang9@h-partners.com>
Closes: https://lore.kernel.org/linux-ide/20251121073502.3388239-1-liyihang9@h-partners.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 462775c62019 ("ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index caf77faf7a33f..e07f82ca68f18 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4226,6 +4226,10 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	/* Apacer models with LPM issues */
 	{ "Apacer AS340*",		NULL,	ATA_QUIRK_NOLPM },
 
+	/* Silicon Motion models with LPM issues */
+	{ "MD619HXCLDE3TC",		"TCVAID", ATA_QUIRK_NOLPM },
+	{ "MD619GXCLDE3TC",		"TCV35D", ATA_QUIRK_NOLPM },
+
 	/* These specific Samsung models/firmware-revs do not handle LPM well */
 	{ "SAMSUNG MZMPC128HBFU-000MV", "CXM14M1Q", ATA_QUIRK_NOLPM },
 	{ "SAMSUNG SSD PM830 mSATA *",  "CXM13D1Q", ATA_QUIRK_NOLPM },
-- 
2.53.0



