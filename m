Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621445;
	b=dvTdxu0713bVkJboJZB4wtLNAV/37cJlKeMueDB89cqe0/C2NmWu8wbNugIS/+y1lriu
	 Ap61VGWDOVxzKoUUD/RajJ357QhWVZ59+g7V9xXrI3z+nKphrGSoZHdBbN3nHZzbFCcmn
	 oVEmglmpMfX/zgE0a/iIBOyqyCF/FuYjQZx1aYSu2lp8gZ3SPm+cEHSmXoOqn2ZZ64PW7
	 m6npBkRTnqyboqRpy9NdD7CLoc4cJ/mxSuoEne3XYUCf2DWTsxjQemKS4QGcuW0VOyBEz
	 O0nYtuQWVErfJ1eoA9v7rx/5+wNzDv7x2Bzy5vc5FK2Z9jJL6w+daTOwYwU7dtpe3Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybeJQrTulISWA4oxN2f0YET8MDgpEyufrlSjtN3fIXM=;
	b=QyWMN6czRVPVJKftBIBifpy4vkWF2SA7vNDT68B1UCozauMiEmCH0QiJp2EW6K+duIfe
	 ynNN6wT+EKaQ1hQMS21Epj1MZDpRq9Pa3BlXDXSPGupOv8qprnMjZ9/OvtFiMWJEATI+e
	 KN1sZnOhcqrrC28sB8ioCFbx/70mr4yPRnUWpPASk7zo6EZcYMn0I7EF0qHMptUwH16MO
	 B934gajICDpwsPqq3Tv/fUjEKzoddXSy2j3bFIJXiLZi6QVy0w/PDgh6FZXA1Pv/pco2e
	 LrkE+T8QivND6y98bR9a6fuKw9+xgiHDMtzmonKH74zaBlcBRPXWZSgJ9zXSg56Ludg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx0Ua3oW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B8606A329;
	Wed, 25 Nov 2026 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx0Ua3oW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AEA1F000C0;
	Wed, 25 Nov 2026 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621445;
	bh=ybeJQrTulISWA4oxN2f0YET8MDgpEyufrlSjtN3fIXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx0Ua3oW9d5G2lThNF0qcBfup4276jySV8668OySak6u4nN+I4MAln89CxUzwqgek
	 sKE9dFrF0OkuKKjY9BUcA1rzHzM9nmvIHka0y3j/P6oXCQDfUMhtt52ryGUwDZ3dYr
	 fwdiqQe+WNLuxXZIglOOqiGBNCPamFsIt34HevS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/990] nvmet-loop: do not alloc admin tag set during reset
Date: Wed, 25 Nov 2026 15:26:34 +0100
Message-ID: <20261125143827.407573472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 233bbeb4a47cbead8c0471c0b8daec141033eae4 ]

Currently, resetting a loopback controller unconditionally invokes
nvme_alloc_admin_tag_set() inside nvme_loop_configure_admin_queue().
Doing so drops the old queue and allocates a new one. Consequently,
this reverts the admin queue's timeout (q->rq_timeout) back to the
module default (NVME_ADMIN_TIMEOUT), completely wiping out any custom
timeout values the user may have configured via sysfs and potentially
racing against the sysfs nvme_admin_timeout_store() function
that may dereference the admin_q pointer during the RESETTING state.

Decouple the admin tag set lifecycle from the admin queue
configuration and destruction paths, which are executed during resets;
Specifically:

* Move nvme_alloc_admin_tag_set() into nvme_loop_create_ctrl() so it
  is only allocated once during the initial controller creation.

* Defer the destruction of the admin tag set to
  nvme_loop_delete_ctrl_host() and the terminal error-handling
  paths of nvme_loop_reset_ctrl_work() and
  nvme_loop_create_ctrl().

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: bc2170d36586 ("nvme-loop: delete the controller if a reset fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 13bb80582b578..c096953194a00 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -272,7 +272,6 @@ static void nvme_loop_destroy_admin_queue(struct nvme_loop_ctrl *ctrl)
 
 	nvmet_sq_destroy(&ctrl->queues[0].nvme_sq);
 	nvmet_cq_put(&ctrl->queues[0].nvme_cq);
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
 }
 
 static void nvme_loop_free_ctrl(struct nvme_ctrl *nctrl)
@@ -373,25 +372,18 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	}
 	ctrl->ctrl.queue_count = 1;
 
-	error = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
-			&nvme_loop_admin_mq_ops,
-			sizeof(struct nvme_loop_iod) +
-			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
-	if (error)
-		goto out_free_sq;
-
 	/* reset stopped state for the fresh admin queue */
 	clear_bit(NVME_CTRL_ADMIN_Q_STOPPED, &ctrl->ctrl.flags);
 
 	error = nvmf_connect_admin_queue(&ctrl->ctrl);
 	if (error)
-		goto out_cleanup_tagset;
+		goto out_free_sq;
 
 	set_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 
 	error = nvme_enable_ctrl(&ctrl->ctrl);
 	if (error)
-		goto out_cleanup_tagset;
+		goto out_free_sq;
 
 	ctrl->ctrl.max_hw_sectors =
 		(NVME_LOOP_MAX_SEGMENTS - 1) << PAGE_SECTORS_SHIFT;
@@ -400,14 +392,12 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 
 	error = nvme_init_ctrl_finish(&ctrl->ctrl, false);
 	if (error)
-		goto out_cleanup_tagset;
+		goto out_free_sq;
 
 	return 0;
 
-out_cleanup_tagset:
-	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
-	nvme_remove_admin_tag_set(&ctrl->ctrl);
 out_free_sq:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	nvmet_sq_destroy(&ctrl->queues[0].nvme_sq);
 	nvmet_cq_put(&ctrl->queues[0].nvme_cq);
 	return error;
@@ -432,6 +422,7 @@ static void nvme_loop_shutdown_ctrl(struct nvme_loop_ctrl *ctrl)
 static void nvme_loop_delete_ctrl_host(struct nvme_ctrl *ctrl)
 {
 	nvme_loop_shutdown_ctrl(to_loop_ctrl(ctrl));
+	nvme_remove_admin_tag_set(ctrl);
 }
 
 static void nvme_loop_delete_ctrl(struct nvmet_ctrl *nctrl)
@@ -494,6 +485,7 @@ static void nvme_loop_reset_ctrl_work(struct work_struct *work)
 	nvme_cancel_admin_tagset(&ctrl->ctrl);
 	nvme_loop_destroy_admin_queue(ctrl);
 out_disable:
+	nvme_remove_admin_tag_set(&ctrl->ctrl);
 	dev_warn(ctrl->ctrl.device, "Removing after reset failure\n");
 	nvme_uninit_ctrl(&ctrl->ctrl);
 }
@@ -595,10 +587,17 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 	if (!ctrl->queues)
 		goto out_uninit_ctrl;
 
-	ret = nvme_loop_configure_admin_queue(ctrl);
+	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
+			&nvme_loop_admin_mq_ops,
+			sizeof(struct nvme_loop_iod) +
+			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
 	if (ret)
 		goto out_free_queues;
 
+	ret = nvme_loop_configure_admin_queue(ctrl);
+	if (ret)
+		goto out_remove_admin_tagset;
+
 	if (opts->queue_size > ctrl->ctrl.maxcmd) {
 		/* warn if maxcmd is lower than queue_size */
 		dev_warn(ctrl->ctrl.device,
@@ -634,6 +633,8 @@ static struct nvme_ctrl *nvme_loop_create_ctrl(struct device *dev,
 	nvme_quiesce_admin_queue(&ctrl->ctrl);
 	nvme_cancel_admin_tagset(&ctrl->ctrl);
 	nvme_loop_destroy_admin_queue(ctrl);
+out_remove_admin_tagset:
+	nvme_remove_admin_tag_set(&ctrl->ctrl);
 out_free_queues:
 	kfree(ctrl->queues);
 out_uninit_ctrl:
-- 
2.53.0



