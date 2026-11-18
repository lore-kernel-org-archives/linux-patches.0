Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055048;
	b=2epb4cW6xQFYRXJ4yMAYS0sBmEqYw7ilOhegQMSuMynveqBWGFWH4UWb6qm8LiQbCcUy
	 bNBEuZwFdDqFDaqYODArPyPreBJRWBLW1vmg5AQMzCk167J1jb6c6SVtVsPMtn/OsrHMt
	 ZFYplVQLimbQUDBvWx/PXQhdRl6gkSVRn7TmEgAqdUlMbCyoREUBQersyjGEuFo2Hb31m
	 lUa56ag+gUoZ/+HOqLtGDE3uYqbrIdLc/qginPPKM5SY2wBPHTZgLWJ1RsaWUt9KK8YqW
	 MqaZlFLymaJexUVyVFtprCbMCkQIL6rJGzdTRKDe1zy9sJQUbcO+06KIi2QqXHrXzRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ib02HL8B2CIBGbxFonnL2gSWzHgvjX2yG0OQ1kWcIQ8=;
	b=y74BjBzPqvzbLzv0flPqHzXTrveV7xbJntn82WwiFuLYbeHys5Ha0PNZGdXerxCmTxXF
	 d+lleffOEbYqo6sM2UD/ahzQvXH7h+cOb6gmdS1trCFjhpryglBb648o4loWA8Zwuy+ln
	 AZBTuI0tuK4Q5uQsVsAdwdxj75t9X2SCx6dhldbkGFPyx6WcHq/SDWtvbzS+fJvZaSWKT
	 kP1QmtM+TlY4FgFc1NZflK5mbEljq8P1Dtbxa464VYQPRlqPHajJMBe5mMu3qHoe+xZSS
	 dAcvticv7EycSfYMSfd0XbMz3FRTkHhXiXrJwDq8JruJKdvRWd2Lmtms6wmVZ+q4r2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T89QfORp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA2606A31C;
	Thu, 19 Nov 2026 02:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T89QfORp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD81F000C4;
	Thu, 19 Nov 2026 02:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055048;
	bh=ib02HL8B2CIBGbxFonnL2gSWzHgvjX2yG0OQ1kWcIQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T89QfORpuDHtmHgiYfCH24vKurey8sR1eSySXbXQUQvk6ls14JePgi6OLrs8g5Lq6
	 QcZOE4Hv2NODzYJMo02vo3WRet3zB47GGHrrtn4Mjm3jiAfnUqMwMnTkXT5VL/S1tC
	 p/Dg7ra7VxpeM81trzM4Wj4J1dtTmAW2YrWAEwNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1491/2214] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:52:47 +0100
Message-ID: <20261118150111.018437036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5915ab523e33057224a0240e27b88c6c2798b919 ]

The ata_scsi_remove_dev() comment misspells its caller as
ata_eh_scsi_hotplug(). The caller is ata_scsi_hotplug(). Correct the
reference, which predates libata's move from drivers/scsi to
drivers/ata.

Fixes: 580b2102327a ("[PATCH] libata-hp: implement SCSI part of hotplug")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260912101215.86413-1-kmehltretter@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 81ed39f68c148..231e1d2faa2fe 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4413,7 +4413,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
  *	ata_scsi_remove_dev - remove attached SCSI device
  *	@dev: ATA device to remove attached SCSI device for
  *
- *	This function is called from ata_eh_scsi_hotplug() and
+ *	This function is called from ata_scsi_hotplug() and
  *	responsible for removing the SCSI device attached to @dev.
  *
  *	LOCKING:
-- 
2.53.0



