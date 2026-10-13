Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4A14F55DD;
	Tue, 13 Oct 2026 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893583; cv=none; b=elNetmxhZTuKT40vRPMVWcVd9jgza3Oy2tJ0+PuWQDcAfzs2izbALOxXge64+d3ZB7hnbPWAtFVWDBqOnxJCFrKpo1FwoB3O0AgakkgkSLNg2vDOTT02Dk6W+MgBJ14Yg6lUY9x6g6Tz4XzBdKB642aHmEBKFuiZTmIfQqe7c7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893583; c=relaxed/simple;
	bh=x8E9aJ93xS/cG6FxFsR7+oktwZXxdTyTxhkUraHyhWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZcSXzy0x/Cwmu1RZ1VW13jXp0nhpwPWuRaWW8xS+bNuHFZeq2g4G1tCVxU0UVL9kgAoBy96nCx5gBp2e2X0NpBW6T4BJqs2nq65CFEFwXBwLPf0Fw85PbLsiBncSXJr1G4/dzd4iPjWH6iV7BLyIQuPrHeQ7uIuJccGFeGAwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omqfTz6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omqfTz6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339391F000FF;
	Tue, 13 Oct 2026 12:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893582;
	bh=/7EkTlre9O5l80aSpfuXRkycPxR3ng6OMV8auFR7FFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omqfTz6AlEzdGosa6TjLGowHVSV9pRPyFFPvQ9KcqG7tClmJbx31hebYXgOGlFKGW
	 M7dDmHomSh5/Obt1QcE8BlQjqo1dIYRIvizgQ+G56BJB0GQ4fbuzZfMbyzBMsjXh/G
	 chx2xET1YtvsDxbx9brX51karQ/3ru/0z6axhh4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@h-partners.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/621] ata: libata-core: Disable LPM on Silicon Motion MD619{H,G}XCLDE3TC
Date: Tue, 13 Oct 2026 13:34:29 +0200
Message-ID: <20261013112927.363296679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index ef7f93aca36d1..44d53910b8111 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4281,6 +4281,10 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
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



