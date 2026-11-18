Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056738;
	b=Vs+D/tMxDZoJr9dkceIdGkQjD2F2S9ZNzjJrI98EZgxI120/sSw6ipDNSxBrV+TJrvxB
	 HAKqDmAHZaUEQPeTlqV9r1JwS0XtnPYKsAmmQ1XoDDadjMSaDdG7p4H9Qem1I8oCnWD+0
	 3rFFubtAJ8bBGJU6lXl85DuTrFI7QbW60agQGTd+9BJSubRLQzuQEheOV9d7kc/feAPPE
	 Ov3i9fkH4PXRFJluxhgi2LcXpvK0wcl1PKk7BwDbRkWVKhqTgTWMMzcAu7ryLOWCd3nCl
	 2ClJD/44JHQnY3Gy1aZ0nlXM3Walao26w1iEq1rWUAHSuGKeKXqs2i/mKyM1hwCo+tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2rzv53N14cMAkPMfn9olgSzlIPYiN39TMy4j2LAOCH8=;
	b=CopuA+xaGbNU7RRSCODifUQUCod5S3QLoCt+RFR7p8tnw5btc9HYURfTjB5DpRzeEcTy
	 Lw2syPTFfnO6EAUhDX6KcPme1PPcd2/gdU/P6zHWPWHcbZrhXxP1tloeoZhc+ATTtAbyx
	 0DPbqmne3u9A/eJoBm2fkPIcI8D70Bp5Da6NPHLhAozPjL7VMuVPagHZsNJbbMs9mbgMp
	 66SeC7C13OtYXmKOkHrQ7FEeIGWKzguzVqw7SewV+OXm58gcjh/ORrRUUFaTxu9MhsPhl
	 ISX/FrHgY2uKgepYzqILsxjH2Xg1zwdkKAEqgka/zjlGtoEVlE2zi4IZHh5yZEMUkig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvSslyw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA2B606A320;
	Thu, 19 Nov 2026 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvSslyw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED84A1F000C4;
	Thu, 19 Nov 2026 02:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056738;
	bh=2rzv53N14cMAkPMfn9olgSzlIPYiN39TMy4j2LAOCH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvSslyw49gRpWxxEIwBnSdxr8IYddgKyGDStXE/GmrCsHTa0ziFC410l4okH+sKry
	 o1Foksocbc838PSTJPlAdXFM/PBo7VTqStnJwUcqweaXBOcQJDQaERksOY10gRN7tX
	 7Qh4Dy1esS8o8IceJ0io3VEAXgZXESMVAwOWGecM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2096/2214] ata: libata-core: Ignore forced transfer modes the host does not support
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150134.495202297@linuxfoundation.org>
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

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit ea5a5af9159cc89e8bcb7a95336e02c8b70aa3d2 ]

The libata.force parameter can force a transfer mode (pio0-6, mwdma0-4,
udma0-7) for a port or device. ata_force_xfermask() applies it in
ata_do_set_mode() right after ata_dev_xfermask() has limited the device
masks to what the host supports. It replaces those masks with the forced
mode without checking the host masks, so a mode the controller does not
support is passed to the driver's ->set_piomode() or ->set_dmamode().

Several PATA drivers rely on the host masks to keep the mode number in
range when indexing their timing tables. ata_piix, pata_efar,
pata_it8213, pata_oldpiix, pata_radisys and pata_rdc declare ATA_PIO4
and ATA_MWDMA12_ONLY, index a five-entry PIO timing table with
pio_mode - XFER_PIO_0, and index a three-entry needed_pio[] table with
dma_mode - XFER_MW_DMA_0. Booting with libata.force=pio5, pio6, mwdma3
or mwdma4 makes them read past those tables, use the values read as
further indices into the timing table, and write the result to the
controller's timing registers.

Make ata_force_xfermask() skip, with a warning, a forced transfer mode
that is not in the port's PIO, MWDMA or UDMA mask, and keep looking for
an earlier matching libata.force entry, as it already does for entries
that do not apply to the device. With libata.force=pio4,1.0:pio5 on a
PIO4 host, device 1.0 now gets pio4 instead of pio5. Forcing a mode the
host supports still works as before, including a mode that
ata_dev_xfermask() removed for the device or cable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 332673257056 ("libata: implement libata.force module parameter")
Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261015194935.1497-1-rand.sec96@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0896a9fd72d58..63e58c215b446 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -408,6 +408,7 @@ static void ata_force_link_limits(struct ata_link *link)
  */
 static void ata_force_xfermask(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	int devno = dev->link->pmp + dev->devno;
 	int alt_devno = devno;
 	int i;
@@ -432,6 +433,17 @@ static void ata_force_xfermask(struct ata_device *dev)
 
 		ata_unpack_xfermask(fe->param.xfer_mask,
 				    &pio_mask, &mwdma_mask, &udma_mask);
+
+		/* Make sure that the port supports the specified xfer modes. */
+		if (!(pio_mask & ap->pio_mask) &&
+		    !(mwdma_mask & ap->mwdma_mask) &&
+		    !(udma_mask & ap->udma_mask)) {
+			ata_dev_warn(dev,
+				     "FORCE: ignoring unsupported xfer_mask %s\n",
+				     fe->param.name);
+			continue;
+		}
+
 		if (udma_mask)
 			dev->udma_mask = udma_mask;
 		else if (mwdma_mask) {
-- 
2.53.0



