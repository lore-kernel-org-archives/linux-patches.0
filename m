Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020481;
	b=TWRvN0phqIJcm6M08Quxn5FwT1LKGsJ1y93Ha8nhxegUg/A2ts+KsnOSdmr/mkP+Ms3t
	 h0rGCggrvBLAE5srf4ToGo88XDBD5BkK5LbxrBpM7MmOJ/6faBMT2CV3wlRFce/8uv+C3
	 8mE51zG8Dca+AZTiTY5nR0c2c1Z3lK0R7FF/VtBslS+L/Nuyf0XPJZaGEdznL0n88aA2y
	 yuIP6Kdb1J6eLskkXiVAJpelkMqA/WWi+oCXgWq5c+OyXbGQMLHtMNFCeVxedPxdhQiF1
	 xp3ZDgJGHhfBUv/s+l74hx71XKaZ9QT/+49nEPISGI8f0o9DCizN1wXQiCuhio4ZuwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BmO05Oiit75wgULVdaexUPMDi5fyGtx6YUWwyAS90uM=;
	b=2VewGY++CSkYuSQ66VDt66dP0VunMu1Rtg2z41a0dyuBJrm/Pj1akl7JudTDBzBfA50W
	 4nbM1eUDzuxcl3sgmSgUGF7oquA9tLVvicjxCuEaF6svbrFrVLVFHTxzzJHB6Aaj23ng0
	 Y/7X6F+Tkys6UQ7BvvV8DG+aw2P2wp/rtqAMV222rZTp8VYyxFv72orH9veTeQ0nzL4l/
	 npQ6+2hKLgGDlPvLuSzXtsCB/nUaxmTdCEQdR5c7hGwFD0bJ6lCgA6nhii0CUcvJ0ZN4Z
	 ZIBDj5DBrKGCXzW+zZgkKZOVP6c4YfSUtl4IUR4PiravggHtRGPXFShCpk2DhlHfr5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd4zXPQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28133606A31C;
	Wed, 18 Nov 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sd4zXPQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30101F000C4;
	Wed, 18 Nov 2026 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020481;
	bh=BmO05Oiit75wgULVdaexUPMDi5fyGtx6YUWwyAS90uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd4zXPQxC1uNVxt7CSid1HhhFpo9HXfOIahdyVokCYW9IZMw/fGoUIv0rHjgpXuvs
	 1esgTcvT3/lNfeUTRWx52CCpkS0npUqrvcJ/9TMqb5tCRJ2x1BY/zVsyg416uZ6Sll
	 sXdoTGdx2gex0p7gaTCqneRhsCBx8+kzV0DZXoH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1926/2651] ata: libahci: re-enable FBS after error handling on a port multiplier
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150356.052230963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyrylo Biryuk <illofspeed@gmail.com>

[ Upstream commit 23eab9e877497397a0e2394ee9174d576816209e ]

ahci_do_softreset() disables FBS before resetting a device behind a port
multiplier, as required by AHCI 1.2 section 9.3.9, and re-enables it only
when that softreset succeeds. If it fails, for example because a
hot-plugged drive is still spinning up ("softreset failed (device not
ready)"), EH escalates to a hardreset of the PMP link, and nothing turns
FBS back on: only ahci_pmp_attach() does, which runs at the next boot.
The port keeps working with command-based switching until then.

Seen on a Marvell 88SE9235 (1b4b:9235) with Marvell 88SM9705 port
multipliers (1b4b:9705, in a Synology DX1222 expansion unit): after
hot-plugging a drive, the kernel logged "FBS is disabled" followed by
"softreset failed (device not ready)" and a PMP hardreset, and never
"FBS is enabled" again (twice, on two different ports).

At the end of ahci_error_handler(), re-enable FBS if a PMP is still
attached and FBS is supported but disabled.

Fixes: 89dafa20f3da ("ahci: disabled FBS prior to issuing software reset")
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261012103917.389-1-illofspeed@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index f3fd56f153340..222af8d9fc013 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2233,6 +2233,21 @@ void ahci_error_handler(struct ata_port *ap)
 
 	sata_pmp_error_handler(ap);
 
+	/*
+	 * ahci_do_softreset() turns FBS off before resetting a fan-out link
+	 * and turns it back on only if that reset succeeds. When it fails
+	 * (e.g. a hot-plugged drive is still spinning up), EH escalates to a
+	 * PMP hardreset, which never re-enables FBS, so the port would keep
+	 * command-based switching until the PMP is attached again (reboot).
+	 * Restore FBS once recovery is done and the PMP is still attached.
+	 */
+	if (sata_pmp_attached(ap) && ata_dev_enabled(ap->link.device)) {
+		struct ahci_port_priv *pp = ap->private_data;
+
+		if (pp->fbs_supported && !pp->fbs_enabled)
+			ahci_enable_fbs(ap);
+	}
+
 	if (!ata_dev_enabled(ap->link.device))
 		hpriv->stop_engine(ap);
 }
-- 
2.53.0



