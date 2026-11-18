Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062000;
	b=Xh23k+PI0w0tML3Dp/XpsyRbMCJi0u+63ugfOY6sHqxgKbMTZDSamkVsrDgVxbTDzzU1
	 fQvOPIV2M+2K+I9JI2harQhW1maYDN6ZEU1cdEwb7TXqMphZGL0GZX9meTdWUXZetkpDh
	 m4XixJbwTuLCPkfk27zTbYUe2jqBnvaHHWwo7DXkBwZoCXm8hedRLKg4Aj8qx6IhXQaHM
	 wojgUIeFQlCm+couhJe9dfsWYsluDDjEgK+ZiG3MP+Jp79v4yT7f/p+UiCUq/UEqyyTgW
	 3fzikqOS/8AR1n5D57nD0t9J6JZbcxziYrsz4sZLhuqHKoq9kOXxhJHuMuCd8769N0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WMoDiA+9cdMY6bQTDHxwDxcjY8KVFeDqzb1tstUZoW8=;
	b=jrt46o2gtEhJyQfRnajcpvKOk8qB3G1QyTQsigcV4tLkQYtmUVUMv3DxmNIlN9x9aj0+
	 uMbF3TBfNSo1o+wIT0gsKTtYYzV8AKPulBdly0l77+Bdnyuz6MYKzMnj1EuicuvBkCdGe
	 PwtjN7Asi0aMDy3op74vKqhaB56aRM3igqJrSv59PPLNDK5oCZ6ktf39V6TVpRBhRx+lQ
	 8aA3/1ukjM38WMl4+MTbcC8O4VS/B7z0CeZr19aPzP5Lue/leC0zxYJz+FKkgEHk5pzXW
	 l7DQJU5lFYa9VkFOqpH/sNoJ+5mlaY6IDzkZR1+1auDhvnuLGcDjUh+d0yQqVpp7Ljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2UXJmy5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772CF606A320;
	Thu, 19 Nov 2026 04:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2UXJmy5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D4C1F000C4;
	Thu, 19 Nov 2026 04:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062000;
	bh=WMoDiA+9cdMY6bQTDHxwDxcjY8KVFeDqzb1tstUZoW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2UXJmy5VPWsg37tcmkfBMG09GTKPwpbjzuJ0w+hahw4W2yLV5vjBaRJO1h1SEkYp
	 95vFRqt40yiqlEY0C1fZLahjIqBPTztAf0oMcvXa/sqBwiDkDXdxMAZj06WGeOEdP7
	 cmVx69JxyB4XlvMK768BJHxTmYR+vlg8YdIcAV2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1754/1848] ata: libata-core: Ignore forced transfer modes the host does not support
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150032.888047108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0eab4898e835d..103f00f65d19e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -402,6 +402,7 @@ static void ata_force_link_limits(struct ata_link *link)
  */
 static void ata_force_xfermask(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	int devno = dev->link->pmp + dev->devno;
 	int alt_devno = devno;
 	int i;
@@ -426,6 +427,17 @@ static void ata_force_xfermask(struct ata_device *dev)
 
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



