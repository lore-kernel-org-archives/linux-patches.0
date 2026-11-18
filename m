Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025260;
	b=CcCBOu5wu35J5m+LEsOlEnzoal6aSZwvcZmS8cCUIiNv5zeRi152x6npH4hG7K/JGtN6
	 c2mVYcKRjzqane5ryt4Frxkcq5arnl4B2A/cN9qs8vzawgOMDpnEqqvC8qeeV9Jp3d7Jt
	 xErJrJ3V3przDfmJ/shQpkmqSsTpZp1boXsUVxUq8hPkq1nGyWoCemJ3SfDatzLPfpBXs
	 S4wfscJuqsLBSqVzVoOf52bl6HUMUtJ8OClIh7GyWtu3atw4t2lTBdwmcqRDCHcF49seg
	 6t2gIru8Ta0CKmPNTAKgoM7lrqPoMZewTJYFIZEai2Ph6jZpTpUCZJFTVCfEYxJbkPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x2Clim1/Yd44115fYPm79NMtPAK2g4lfHvIKgAdfcgo=;
	b=b5a7cNNt1qeGZBGKVY9HrPBfw1wgSN9Y1lUKlq1uDM506s654KEIAA8YywjECye7B3ku
	 Yeefln/SsLUcSHrHhthlAy3z+LM6tNtnOR0MzaZAYdQmvDXfmSdBKkj2pkSLGI30k1hND
	 uwW/w5p+7iuxlTy/z1yAoEIZlnEBm6A8VNkhJTi4Mrpp6DyllSCIpJBIEY8KTYiCgOWJ5
	 ibr46WtZEgAygBEdZetrGEfOoURLfOPu/Vt/a9OZQwGQt4RZKS7EB0oY3h08EcKppxDpS
	 2DcljJ5w5HQujF9EnBb4+IEKm/ZFo+mNe0MWypvka0qYujDFe3UfNsGEqfiAi8Sv0pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egMhGzYj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57FA606A33D;
	Wed, 18 Nov 2026 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egMhGzYj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C61F000C4;
	Wed, 18 Nov 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025259;
	bh=x2Clim1/Yd44115fYPm79NMtPAK2g4lfHvIKgAdfcgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egMhGzYjEWMdyPxjyNjimLIBlqo4V3VhwSyCFXaIqJ6MUo39NSHA5ibwBaZOE65qD
	 7VuxGcovvdSBritsvWyYYvR22YBIQWc3pNin9yugwNbULjyds606pLwF1RJdBilZI8
	 iRESM08mOfJa9sojnI3lb7a2e4lOBz/S4SzfpZ0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1014/2151] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Wed, 18 Nov 2026 15:45:49 +0100
Message-ID: <20261118150159.356531725@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit a2ab4e33286de37f3fe8f28f86f5f71d6b0ae3b0 ]

Add helper functions to allow LLDDs to allocate and free internal commands.

[ bvanassche: changed the 'nowait' argument into a 'flags' argument. See also
  https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de/ ]

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-7-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92feb036a2d3 ("scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c    | 38 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  4 ++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 496cbff59c0ab..8ed392efe5fc0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2162,6 +2162,44 @@ void scsi_mq_free_tags(struct kref *kref)
 	complete(&shost->tagset_freed);
 }
 
+/**
+ * scsi_get_internal_cmd() - Allocate an internal SCSI command.
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
+ *	BLK_MQ_REQ_NOWAIT.
+ *
+ * Allocates a SCSI command for internal LLDD use.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags)
+{
+	enum req_op op = data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT :
+							   REQ_OP_DRV_IN;
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+
+	rq = scsi_alloc_request(sdev->request_queue, op, flags);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd = blk_mq_rq_to_pdu(rq);
+	scmd->device = sdev;
+
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
+
+/**
+ * scsi_put_internal_cmd() - Free an internal SCSI command.
+ * @scmd: SCSI command to be freed
+ */
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
+{
+	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
+}
+EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 21549c6dc5a0f..c2915bf170660 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -558,6 +558,10 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     const struct scsi_exec_args *args);
 void scsi_failures_reset_retries(struct scsi_failures *failures);
 
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags);
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.53.0



