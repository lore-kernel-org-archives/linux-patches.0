Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026822;
	b=aCZliGry/CbSP6woi7YMnT1xERrwJDC70KKSHqD0jQNFENBE5/BIUkzxGUuGpZql+tFe
	 esP4e/5j2JPO3EU0x6Ifpvgxsquy5iWs2O8DLWnSXhoTfe43l3lMSMu66DSpdOqhQqqzp
	 vONawvhO+qu5p0bGnZFL/TC8wf/r2O01TYDGjryzKRwqqrq93HbH9HJSHf/cYvfW5BUU9
	 u5juHMS9muW5qblIoshehB+yK8Hfy3kq5cj8lOsGDZYC37wYfyGLIpJWwp5QRDkyzvyhm
	 sms3LcWHP5WmiiLqvKGFFhsl8rGS++G3TwYQLG/r6PqCAr/Q1rVP4JN1EoB2D9rfTZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bvUPorIEMJZYwLcSPMszT1cfiMH88Xgf2sN6z+FNcmg=;
	b=WSz2sCGvIOvMolxADsBIrAQYyYMJrblwB51ouJzXqzibWJmxsL79LdPnGps9ZRkLpEmR
	 BULBgNJmly4+kWgB/2/bnssPqegaCka6eY7B3rj2K8jyRUHLi+ycZC+3vUhLnmehDX6KZ
	 Ikme1nZtXa2B12TUGB38FCuPhwESstL8hsZwYTH13Lv9WyuSQwDymbSsluUyJKmJJSIMw
	 mWytLEl+9bgM/q05C1tbzhL0O2Nf7KzfSTGhfQ/FhZQi0q2zwBQbMpZUWmOlfXKt1HdG6
	 IofYrNP6tgvG1zJZ0PoY5MpKm+1UjlzM6f/lqsf9vDzt41P0Nh135AGiZugTDKbWuGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiA28LAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86E7606A32F;
	Wed, 18 Nov 2026 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiA28LAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF111F000C9;
	Wed, 18 Nov 2026 18:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026821;
	bh=bvUPorIEMJZYwLcSPMszT1cfiMH88Xgf2sN6z+FNcmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiA28LAsQ++WDMt3/CcYRaGRKq4S88qQLKF8cT6NhMNgp8DAq6RP4F9/Wt0fcLX7r
	 GbcqWX27XwqsZsz9cga9L3sJk1l8/MwMMFIRk22nxE1jDjUbSBXoBHCu4Z0SJVJ94R
	 NuNtqNVbueTdANKleA8VB5pDHkHw2OUmWbZH/T9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1572/2151] ata: libata-core: Quirk INTEL SSDSC2KG480G8 max_sectors
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150219.149508775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 5f64ae1ef639a2bab7e39497c55f76cc0682f108 ]

Commit 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") increased
the default max_sectors_kb from 1280 KiB to 4096 KiB.

INTEL SSDSC2KG480G8 with FW rev XCV10120 times out when sending I/Os of
size 4096 KiB.

Enable ATA_QUIRK_MAX_SEC, with value 8191 (sectors) for this device,
since any I/O with more sectors than that lead to I/O timeouts.

With this, the INTEL SSDSC2KG480G8 is usable again.

Link: https://lore.kernel.org/linux-ide/176839089913.2398366.61500945766820256@eldamar.lan/
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Stable-dep-of: 4153718a215e ("ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 76e829ead608b..a4f50f7910964 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4118,6 +4118,7 @@ static const struct ata_dev_quirk_value __ata_dev_max_sec_quirks[] = {
 	{ "LITEON CX1-JB*-HP",		NULL,		1024 },
 	{ "LITEON EP1-*",		NULL,		1024 },
 	{ "DELLBOSS VD",		"MV.R00-0",	8191 },
+	{ "INTEL SSDSC2KG480G8",	"XCV10120",	8191 },
 	{ },
 };
 
@@ -4383,6 +4384,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 
 	{ "Micron*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Crucial*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
+	{ "INTEL SSDSC2KG480G8", "XCV10120",	ATA_QUIRK_ZERO_AFTER_TRIM |
+						ATA_QUIRK_MAX_SEC },
 	{ "INTEL*SSD*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "SSD*INTEL*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Samsung*SSD*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
-- 
2.53.0



