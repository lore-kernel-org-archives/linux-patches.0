Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027744;
	b=Mc5jq7dd4V3tXDHAgkZWgz+0LGSfZlr8DzAweuurpOLO+yXa+dailCUdzAc2TVP+ZpZ+
	 vZJUUqPjQ/Zky5ynpIJD+sCuhcPsr4FpZUC9/SJjU8CvbfjNie2J0W3LQEUOKfAHgb0xK
	 JnmyCHOz/J6616crMNRbwhBfTu+cwZb9qeEvSaIVPLnCvjUvFxPQyAqkrovw+JwwPpU58
	 qoJ0TeArhdWbUEQyhUatoAaWmdcnWqcfJvUFOkt8VWHP7jWIVb4IXPR+p4+P2jMG92mz9
	 s2g65aujYeNAXqJZsSmXbl544UWzUEpHboSQuPsXDkIPIO3gXJmUusQ9iTOm061SDQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V0r8FOaTli5fsVoEMyFYHcoz51l0eUePWsFIvK38TWU=;
	b=VcVtZ6xuSaPqw+m0dY2gcUSdxCAitjMp0s30jcUFcuXwuwb49wJgFVYDuGj5RNYdXKya
	 83LqkW+SAUJqsDgTDfjnBgsRte/03k5PdITfZ3Dpu10L4VE4suLoEHyGcohdZRSgGVj+6
	 77dXuFrf7hSkMUs2yx7GcXYxRe2CDqBaQ9RnPgEimtZxpYXnrAOGJ6bilhkN/Np8TiPfP
	 i0Si5IsPBNA5RUgfJhbcJCBB/EuuPUQW/TgVZMraRpQ1gmdt8gqKmTeLqqqGIs3SNpEEb
	 /zCsln4C2Mv4QqTxAiHvLlOAukLfrf6trVrvmug8pQgtlPILEbiAA5JQON5/PFSXUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzZZT38s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48EB606A331;
	Wed, 18 Nov 2026 18:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzZZT38s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C8A1F000C7;
	Wed, 18 Nov 2026 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027744;
	bh=V0r8FOaTli5fsVoEMyFYHcoz51l0eUePWsFIvK38TWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzZZT38sPy3XcGm5Y6XU3OFWY0QGKk0yHuqRxsjR8T0bNRD0mPxrteqeOxMrolDNj
	 E8hVBaIEYQyiZquhP7HU/h9PXSE9I+MnTDsdsEAo8IjHZZe5oE7Fp2jjiJx+HqzWW6
	 d60KVej59vdqD/jkCLyXZHpwlLw28jX4AO+OWNro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1897/2151] ata: libata-core: Ignore forced transfer modes the host does not support
Date: Wed, 18 Nov 2026 16:00:32 +0100
Message-ID: <20261118150230.897644667@linuxfoundation.org>
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
index 9b373830a7c40..29394d18e7e83 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -433,6 +433,7 @@ static void ata_force_link_limits(struct ata_link *link)
  */
 static void ata_force_xfermask(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->link->ap;
 	int devno = dev->link->pmp + dev->devno;
 	int alt_devno = devno;
 	int i;
@@ -457,6 +458,17 @@ static void ata_force_xfermask(struct ata_device *dev)
 
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



