Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029328;
	b=LjF33fROGySUJnclD0b0lkvt3J+k5OP4UJAu7VnN/X6UiqolsFEz6gSrFUdd8bO6qoLU
	 srnpI3C+0eRJWb+Syj1Uj1Fmj4JBDYsoL4FQDix4Yd4240N7WHZgEJJFWakHOfVtnJWpZ
	 bqeGWtdkhss3OhiMBz+SRWYiNhd/yTkWbwTd9EE9Uo/+lmELdiSruu6XOIenBi8pQaqLv
	 0bnDAOQIzTbAzrLc1hO8JXkmHSGOi0eYyNgOdJ01xr7krWqMfYRBiLZf+45s7NDC19j4w
	 lbilhlXHxWrw+vJH5tqNG6Ib138Cl2Ypgfjl8B1Rk0EQrNbtr90qs8IMi5nZE4Jr8Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/h1KR8TtBDYn7vp1VA8DtJ/jly7r3wb40Ea6/0tKais=;
	b=IpMFa8B98/fC7xPTiv3zJYyMUW8KqLFRNZVQWpj1nKEWZafduKwhoxPRwVGPMIhQyS7k
	 GeAgcpPRDidSnm8X7068i+hFuSAICG/+lOgBMINvA9Xq3yfMkOrvScx/w+veDYYBsVt61
	 HFB6uTRfQfRH7FkUSRV/hpmc3dGGEx7K6iVMdJnh5pVvh34VXYTyBar8neSYFrB8tdeiC
	 BU8pJSwi/0GpvmyYB1zhdXSnnvezgZiMt+EwFcnfBrjI1ODhaMGKP2+90e5+F4ZEs7j87
	 d+55kpdguomR7A9uhBxZwbvh5FjXJiGRypI00t7ehXjBfKI3NJQOJlGnAW/6Wwa9xnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2ZQ2MsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5BB60A2600;
	Wed, 18 Nov 2026 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2ZQ2MsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488981F000C4;
	Wed, 18 Nov 2026 19:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029327;
	bh=/h1KR8TtBDYn7vp1VA8DtJ/jly7r3wb40Ea6/0tKais=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2ZQ2MsDolRjz9G5Wot9WsQLk8YpgRCYMVCbIDdPCAOCjz9CRQwx4vYfX5a4rpCG2
	 4ke/7B0oIoKbA+tnHHrrDGoJwrrHf5Ork1KWna8u2unKU+TFqwCTJ49w/yXmiViCTz
	 lacvpuAcdUM3VAxs44rI3E6rRTcJ+7f02ZBXvInk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0309/1756] scsi: mpi3mr: Fix device loss during enclosure reboot due to zero link speed
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118150020.634816929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit d6c8e8b7c98c3cb326515ef4bc5c57e16ac5ae4e ]

During enclosure reboot or expander reset, firmware may report a link
speed of 0 in "Device Add" events while the link is still coming up.
The driver drops such devices, leaving them missing even after the link
recovers.

Fix this by treating link speed 0 as 1.5 Gbps during device addition so
the device is exposed to the OS. The actual link speed will be updated
later when link-up events arrive.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20250820084138.228471-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 77554f01187d ("scsi: mpi3mr: Fix out-of-bounds read of event data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 03bbc9bfa6941..53408fb9fc407 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2049,8 +2049,8 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	if (!fwevt->process_evt)
 		goto evt_ack;
 
-	dprint_event_bh(mrioc, "processing event(0x%02x) in the bottom half handler\n",
-	    fwevt->event_id);
+	dprint_event_bh(mrioc, "processing event(0x%02x) -(0x%08x) in the bottom half handler\n",
+			fwevt->event_id, fwevt->evt_ctx);
 
 	switch (fwevt->event_id) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -3112,8 +3112,8 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	if (process_evt_bh || ack_req) {
 		dprint_event_th(mrioc,
-			"scheduling bottom half handler for event(0x%02x),ack_required=%d\n",
-			evt_type, ack_req);
+		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
+		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
 		sz = event_reply->event_data_length * 4;
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c0364fb5b0c5b..97e8947b46d16 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -413,9 +413,11 @@ static void mpi3mr_remove_device_by_sas_address(struct mpi3mr_ioc *mrioc,
 			 sas_address, hba_port);
 	if (tgtdev) {
 		if (!list_empty(&tgtdev->list)) {
-			list_del_init(&tgtdev->list);
 			was_on_tgtdev_list = 1;
-			mpi3mr_tgtdev_put(tgtdev);
+			if (tgtdev->state == MPI3MR_DEV_REMOVE_HS_STARTED) {
+				list_del_init(&tgtdev->list);
+				mpi3mr_tgtdev_put(tgtdev);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
@@ -2087,6 +2089,8 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
 				link_rate = (expander_pg1.negotiated_link_rate &
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK) >>
 				    MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT;
+				if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+					link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
 				mpi3mr_update_links(mrioc, sas_address_parent,
 				    handle, i, link_rate, hba_port);
 			}
@@ -2396,6 +2400,9 @@ int mpi3mr_report_tgtdev_to_sas_transport(struct mpi3mr_ioc *mrioc,
 
 	link_rate = mpi3mr_get_sas_negotiated_logical_linkrate(mrioc, tgtdev);
 
+	if (link_rate < MPI3_SAS_NEG_LINK_RATE_1_5)
+		link_rate = MPI3_SAS_NEG_LINK_RATE_1_5;
+
 	mpi3mr_update_links(mrioc, sas_address_parent, tgtdev->dev_handle,
 	    parent_phy_number, link_rate, hba_port);
 
-- 
2.53.0



