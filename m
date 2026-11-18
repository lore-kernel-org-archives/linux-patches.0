Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025246;
	b=oHeAgCiPo9riY2f3t4t+zcl2F5spvaJLCf8i94yDS+dMELBC8kTrIse9qi4KbYkCCr6d
	 dDQBaDBuYRvaDg6ovvpljVYFIl7IWR4c0+Vyg6mR59g3DDGY6a8GovlqqbJsUK69fbpxI
	 sDUm3RMuKwUuUuclVDVSyUSxNOMOLVhxFICorowtfI9QsZNtHZsK7r7iDdGSir5408lJR
	 ZdlQkuCMVV5ZXm2h80wdR0RUNhubYCgH/mK30NZE2H9MBD92DsfFPeGoh3eRWiSzVKy43
	 +WtvSx2WZj55//876GxCI61oefsGDMd4rQjUtp+HlIv43pIkkOKWSKIb3uaAw4IgfZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iFXv5mC+ovgfC2W6zz6PyXVGSiFtW3/I4GvHGUXc8g=;
	b=vqTHOT7p9LhMM3mSgLQ3VtJA8aL2yOYP2spJ728VymJQG/lHyPHp6HC393awpxcuCsi2
	 fq67bkt9rcbTSIjdlHYM0qdv+Rzj9oKw0EGFrirtDBIW3y2CKyO/cdtnvGvkgmT/05aNB
	 nzsCwMJ9ME0X428d3hEv7cxfjmMtZ67r2FUdx2AT4lQNqkBX1yP7C5apqn63aABoPs3Im
	 PkubKzaQLVPr3BTge1X8/RvTkbKKUZMDXQpjDb51h8FVwOEAZWmuO6odBtDqoek4MH6PK
	 zdsklU6Ijmv3KK2Xl7Ay8t1u6Egq2HQart7GSMdjhV3Bcdxkt/jIO93LfGrKnn9qHWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvUtuEbL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39EF606A331;
	Wed, 18 Nov 2026 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvUtuEbL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14841F000C5;
	Wed, 18 Nov 2026 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025245;
	bh=7iFXv5mC+ovgfC2W6zz6PyXVGSiFtW3/I4GvHGUXc8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvUtuEbLgULW43yuhIDU83tx3oTcTXh4WBdOKlMlKKHb5kGuWsJ2dBNrRo9ADzERe
	 szj53J4bscfZewNYLToyQwY558CF/5qe++q+y4nfWttVl/re9G4PGy2fef9SWWxskT
	 4w4aox+sqhxvKGX+FKYuKtjPxg5CHcxaHaNflrt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1010/2151] scsi: core: Support allocating reserved commands
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150159.222566706@linuxfoundation.org>
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

[ Upstream commit d604e1ec246d236deff57ac7e89e073dd911d60b ]

Quite some drivers are using management commands internally. These
commands typically use the same tag pool as regular SCSI commands. Tags
for these management commands are set aside before allocating the
block-mq tag bitmap for regular SCSI commands. The block layer already
supports this via the reserved tag mechanism. Add a new field
'nr_reserved_cmds' to the SCSI host template to instruct the block layer
to set aside a tag space for these management commands by using reserved
tags. Exclude reserved commands from .can_queue because .can_queue is
visible in sysfs.

[ bvanassche: modified patch title and patch description. Left out the
  following statements: "if (sht->nr_reserved_cmds)" and also
  "if (sdev->host->nr_reserved_cmds) flags |= BLK_MQ_REQ_RESERVED;". Moved
  nr_reserved_cmds declarations and statements close to the
  corresponding can_queue declarations and statements. See also
  https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.de/ ]

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 92feb036a2d3 ("scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c     |  1 +
 drivers/scsi/scsi_lib.c  |  3 ++-
 include/scsi/scsi_host.h | 21 ++++++++++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a1055fe4922f6..2bd230e0fb0c7 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -438,6 +438,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	shost->hostt = sht;
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
+	shost->nr_reserved_cmds = sht->nr_reserved_cmds;
 	shost->sg_tablesize = sht->sg_tablesize;
 	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 31e1d74143df4..c6aa6401f16b0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2116,7 +2116,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops = &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps = shost->nr_maps ? : 1;
-	tag_set->queue_depth = shost->can_queue;
+	tag_set->queue_depth = shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags = shost->nr_reserved_cmds;
 	tag_set->cmd_size = cmd_size;
 	tag_set->numa_node = dev_to_node(shost->dma_dev);
 	if (shost->hostt->tag_alloc_policy_rr)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c02e2d42297c4..8f819453dc698 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -375,10 +375,19 @@ struct scsi_host_template {
 	/*
 	 * This determines if we will use a non-interrupt driven
 	 * or an interrupt driven scheme.  It is set to the maximum number
-	 * of simultaneous commands a single hw queue in HBA will accept.
+	 * of simultaneous commands a single hw queue in HBA will accept
+	 * excluding internal commands.
 	 */
 	int can_queue;
 
+	/*
+	 * This determines how many commands the HBA will set aside
+	 * for internal commands. This number will be added to
+	 * @can_queue to calculate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -611,7 +620,17 @@ struct Scsi_Host {
 	unsigned short max_cmd_len;
 
 	int this_id;
+
+	/*
+	 * Number of commands this host can handle at the same time.
+	 * This excludes reserved commands as specified by nr_reserved_cmds.
+	 */
 	int can_queue;
+	/*
+	 * Number of reserved commands to allocate, if any.
+	 */
+	unsigned int nr_reserved_cmds;
+
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
-- 
2.53.0



