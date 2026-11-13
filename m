Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590201;
	b=vtT3dV1brWaQrpmr9MjGx+CSUfd3Z98Ch0FLprXu5vT+9gZ/vz4XT7vWEhavaJHJNlHn
	 FypizGlFMnMcUxH4rnFuC8BcQzLucz3rkltpWI9wENfhZp6WKP1t2GXGhqehYMIee3gOa
	 /fw9k4IgxROQosH3L03xMKXqvkCdlmuSbpshlpYkWr2QCram2+gugGZYA52XOOZLpJG7U
	 izcKO1ooMGJnOhxOwcpJdX7fWw6gTxqcUh+C9HszaUkHsV7DaRM1ZkK8eDSm4GjGzo0hg
	 J8HYZkjQDC7i4BZWeKiFFMGOiPTqY4yz4JwPO9HbuI30odu8MG0glcvgI65pVh4k1ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HesEwvdKDM0XmJwk8qb/6cNRX8S/N0L/HhfOvWJCuPo=;
	b=nf0qS0DfxUMRMZPlFmvlc/Tp8dkM/gKM3MsLuTJHBF9oGot5t0wLLG0yezlec71XYtNQ
	 QOdH0fkyT1xYBTBO00Z8lQjVf+OzYlnhjc6dG4ucL5OivfDtmvbmcJZ8BanRubJ5HKDBU
	 f9c3WkWSjvjHsjlrys3c8qVK6Bm7bZJzG9LLQJcDKR3QoClp2LCUh7DAD/7wj45GjSFeH
	 XZEzcDmB4N6kgYMOJSOPXWaTIsFky8H1sUWIG/cOVpIDQ6gL6rGdIhx3At2e5gcLj04nH
	 usY7lGwF8qgM7bc4L04e8Bc49UD7aifErP55WFDbJrS3M1eFSuX9tWW+2+xnaciiGLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATeDnfR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD07606B370;
	Fri, 13 Nov 2026 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATeDnfR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC141F000C4;
	Fri, 13 Nov 2026 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590200;
	bh=HesEwvdKDM0XmJwk8qb/6cNRX8S/N0L/HhfOvWJCuPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATeDnfR40C/Hkabsf9IH4V7IBCtjPu7PMVXFuSb+gT7Fzn1UXPFKlKO6QcoaBldwS
	 vISLMGBl45qZCrA8xBafeBAM4vA2rAuLZHiLfMWIB1arf/Sy5tAqtxBHiDV1hag+xm
	 7jd/4LYMSyJuOfSqrC6Hf0mLPfnKjhyWd2eX9F3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Andrew Luebke <andrew.luebke@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/686] scsi: aic79xx: Fix NULL pointer dereference in device reset
Date: Fri, 13 Nov 2026 10:45:39 -0500
Message-ID: <20261113153828.017464593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Andrew Luebke <andrew.luebke@gmail.com>

[ Upstream commit f057a8bfeb6ff89c65e95540b8700a53c66d4a31 ]

Since commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI command
when resetting device") the device reset SCB has no SCSI command, but
ahd_linux_dev_reset() still sets its residual, and ahd_abort_scbs(), which
completes it, sets its status. Seen on an AIC-7902 when a failing disk
triggered a device reset, which killed the SCSI error handler:

  BUG: kernel NULL pointer dereference, address: 0000009c
  EIP: ahd_linux_dev_reset.cold+0xee/0x26e

Add NULL command checks to the accessors in aic79xx_osm.h. Also skip
autosense for an SCB without a command and complete it with ahd_done()
right away: the REQUEST SENSE path can clear SCB_DEVICE_RESET, after which
ahd_done() would dereference the missing command.

Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Andrew Luebke <andrew.luebke@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20261026172032.749756-1-andrew.luebke@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |  4 +++-
 drivers/scsi/aic7xxx/aic79xx_osm.h  | 26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 6b87ea004e537..ff7efba29adac 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8942,8 +8942,10 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 		}
 #endif
 
-		if (ahd_perform_autosense(scb) == 0)
+		if (ahd_perform_autosense(scb) == 0) {
+			ahd_done(ahd, scb);
 			break;
+		}
 
 		ahd_compile_devinfo(&devinfo, SCB_GET_OUR_ID(scb),
 				    SCB_GET_TARGET(ahd, scb),
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 793fe19993a90..3bcfcfe18f08b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -499,6 +499,8 @@ int	ahd_linux_show_info(struct seq_file *,struct Scsi_Host *);
 static inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
+	if (!cmd)
+		return;
 	cmd->result &= ~(CAM_STATUS_MASK << 16);
 	cmd->result |= status << 16;
 }
@@ -512,6 +514,8 @@ void ahd_set_transaction_status(struct scb *scb, uint32_t status)
 static inline
 void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
+	if (!cmd)
+		return;
 	cmd->result &= ~0xFFFF;
 	cmd->result |= status;
 }
@@ -525,6 +529,8 @@ void ahd_set_scsi_status(struct scb *scb, uint32_t status)
 static inline
 uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return CAM_REQ_INPROG;
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
 
@@ -537,6 +543,8 @@ uint32_t ahd_get_transaction_status(struct scb *scb)
 static inline
 uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return SAM_STAT_GOOD;
 	return (cmd->result & 0xFFFF);
 }
 
@@ -564,13 +572,16 @@ u_long ahd_get_transfer_length(struct scb *scb)
 static inline
 int ahd_get_transfer_dir(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return DMA_NONE;
 	return (scb->io_ctx->sc_data_direction);
 }
 
 static inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
-	scsi_set_resid(scb->io_ctx, resid);
+	if (scb->io_ctx)
+		scsi_set_resid(scb->io_ctx, resid);
 }
 
 static inline
@@ -582,6 +593,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long resid)
 static inline
 u_long ahd_get_residual(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return 0;
 	return scsi_get_resid(scb->io_ctx);
 }
 
@@ -595,11 +608,12 @@ static inline
 int ahd_perform_autosense(struct scb *scb)
 {
 	/*
-	 * We always perform autosense in Linux.
-	 * On other platforms this is set on a
-	 * per-transaction basis.
+	 * We always perform autosense in Linux, except for the device
+	 * reset SCB, which has no command to return sense data to.
 	 */
-	return (1);
+	if (!scb->io_ctx)
+		return 0;
+	return 1;
 }
 
 static inline uint32_t
@@ -629,6 +643,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 static inline void
 ahd_freeze_scb(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return;
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
 		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;
-- 
2.53.0



