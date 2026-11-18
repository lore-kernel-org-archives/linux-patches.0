Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048199;
	b=eHIauTABbglwtCaFTWyklkCTGlTjAPpJ3NjJk6ZhBfUBKxQ2SolrmZ21JLP8rB/ZqOMw
	 adssSr6qYVMP+VPV5LLKYWfLpOHklq3PaGPcGu6XUJtZGR+TpHbd5Qjt5oWRNAD+EgGIx
	 X0ICOQs+YA0VY/+oNgmSkwjunn0LYveXriI3DoaeN/D3SbAnlKuX+PT6+Svrb33vz8AQD
	 MUR8rTsRkEu3D/yotnLFlMTTJsz59gsgGBOGZBcjmFUa+eA7wZapTmXn6ciuLFJyxeAwM
	 NZoeWTYd0zXjrZ09jt1e0itfs+hWjRoEVFe93xj4MJYKKr0D7z0g2GSFoMR7Q+thAmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FmAzeRKcdHaXhIocb+sPv4N88zq/7wfexxD1kN0veR4=;
	b=D/KWKxh8bdE5FBulNy734IMvFRfu3CqiKswW/yMYJ2ZGKVuFKv38OCEWwYLVROhS3yj9
	 GGgwlskqmstaxC2p2iiiPGoE9sjJ5v6A9cKJ3Q+DyyVgY8MgWNMlgMDrTgPqhvzCcWrly
	 nHj/HDNs+RDibtHaaKu2qICoQEItx1evqjepBPQ37+SrkAm2jqvSnGcDcIW3nsfcLK438
	 JXhKupqsWAriOO17EumfLW+dZL9apPPe+4b1gv2pPyuIE09qyC5MXZLp0gf9hTs/5g7So
	 0W9+q3WtbNm2q87xeKgpUjbCW4Z280zRoCVgwSYmfXy+3bnUHDtTONJUJyx4Jb1vpaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnrhYB+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742F9606A320;
	Thu, 19 Nov 2026 00:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnrhYB+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93611F000C4;
	Thu, 19 Nov 2026 00:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048199;
	bh=FmAzeRKcdHaXhIocb+sPv4N88zq/7wfexxD1kN0veR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnrhYB+dUD6A7+UBxZ4Wcc7Gyj7OaYDgH3pLqneDQcJ39DGXZzRJ0wVVE17TWEZoX
	 oBGOQtWGxejXsGcTtDX6gpR7Eyj7l7lojLeZ7EFm9zdx8dUmq5sSvmhAlz2NUI3emR
	 Zy5vaJjqdCTTmahhgtof72Mwe/IJ42ey3jQkuU9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1911/2857] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:49:05 +0100
Message-ID: <20261118150310.026530158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 87ef473d22791..c9706ca86ac49 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4559,7 +4559,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
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



