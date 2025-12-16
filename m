Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8412D8782;
	Tue, 16 Dec 2025 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888187; cv=none; b=RNHbRVpTqu+wmQrEtsFg88MgzaIPsouVwQ85s+b86uuf2wTLoufCiXIAgxerTjNGq2xj0ZlrSL395lue+5fiFLpEnIC82cPcwO/iT5OK9Yd32Qlc8JU/ipH9WR9FlmRTF3OIClqHcU3SLGhhGiNxsCR60CrzBNfUoEQihNtJVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888187; c=relaxed/simple;
	bh=h123Np+glL2TSPZq6oTHxM2FiYI7j13lY0P5ZTNz3so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZngl4jrLQTTTpEFKeCVNDri2TKTRN6QWCgIsunP8Ks7zQJHvfwrbKj3PzsC/oXQWHyWf3mJNHgbwSO1cES/+7xskr3kBQ3hZiOvdkYNw5PYwHjgKITKPWmy/fdzrThV3X/p9uIqvSoCazbaqWhSrVOjSG6/CS9daXilH0/O2WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+fumBLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+fumBLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9AAC4CEF1;
	Tue, 16 Dec 2025 12:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888187;
	bh=h123Np+glL2TSPZq6oTHxM2FiYI7j13lY0P5ZTNz3so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+fumBLDlnAC23Ivjpm2+OaUR6O0K8/LA8VJWlFze+caCm1vT0UnjeqmhktJZbG4m
	 4OM75xD+uSmnKrtHlIY4fR0Z5CkUeOhwx8Z7SNi6zNjstcTVXZLppgjtEhsKbu/dth
	 A3XyHH736mppYPPiU0ho9yWeYljzV4L+WXC8X3w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Samal <anil.samal@intel.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 425/614] RDMA/irdma: Add missing mutex destroy
Date: Tue, 16 Dec 2025 12:13:12 +0100
Message-ID: <20251216111416.771477079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Samal <anil.samal@intel.com>

[ Upstream commit 35bd787babd1f5a42641d0b1513edbed5d4e1624 ]

Add missing destroy of ah_tbl_lock and vchnl_mutex.

Fixes: d5edd33364a5 ("RDMA/irdma: RDMA/irdma: Add GEN3 core driver support")
Signed-off-by: Anil Samal <anil.samal@intel.com>
Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-6-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/icrdma_if.c  | 4 +++-
 drivers/infiniband/hw/irdma/ig3rdma_if.c | 4 ++++
 drivers/infiniband/hw/irdma/verbs.c      | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/icrdma_if.c b/drivers/infiniband/hw/irdma/icrdma_if.c
index 5d3fd118e4f81..b49fd9cf24765 100644
--- a/drivers/infiniband/hw/irdma/icrdma_if.c
+++ b/drivers/infiniband/hw/irdma/icrdma_if.c
@@ -302,7 +302,8 @@ static int icrdma_probe(struct auxiliary_device *aux_dev, const struct auxiliary
 err_ctrl_init:
 	icrdma_deinit_interrupts(rf, cdev_info);
 err_init_interrupts:
-	kfree(iwdev->rf);
+	mutex_destroy(&rf->ah_tbl_lock);
+	kfree(rf);
 	ib_dealloc_device(&iwdev->ibdev);
 
 	return err;
@@ -319,6 +320,7 @@ static void icrdma_remove(struct auxiliary_device *aux_dev)
 	ice_rdma_update_vsi_filter(cdev_info, iwdev->vsi_num, false);
 	irdma_ib_unregister_device(iwdev);
 	icrdma_deinit_interrupts(iwdev->rf, cdev_info);
+	mutex_destroy(&iwdev->rf->ah_tbl_lock);
 
 	kfree(iwdev->rf);
 
diff --git a/drivers/infiniband/hw/irdma/ig3rdma_if.c b/drivers/infiniband/hw/irdma/ig3rdma_if.c
index 1bb42eb298ba6..e1d6670d9396e 100644
--- a/drivers/infiniband/hw/irdma/ig3rdma_if.c
+++ b/drivers/infiniband/hw/irdma/ig3rdma_if.c
@@ -55,6 +55,7 @@ static int ig3rdma_vchnl_init(struct irdma_pci_f *rf,
 	ret = irdma_sc_vchnl_init(&rf->sc_dev, &virt_info);
 	if (ret) {
 		destroy_workqueue(rf->vchnl_wq);
+		mutex_destroy(&rf->sc_dev.vchnl_mutex);
 		return ret;
 	}
 
@@ -124,7 +125,9 @@ static void ig3rdma_decfg_rf(struct irdma_pci_f *rf)
 {
 	struct irdma_hw *hw = &rf->hw;
 
+	mutex_destroy(&rf->ah_tbl_lock);
 	destroy_workqueue(rf->vchnl_wq);
+	mutex_destroy(&rf->sc_dev.vchnl_mutex);
 	kfree(hw->io_regs);
 	iounmap(hw->rdma_reg.addr);
 }
@@ -149,6 +152,7 @@ static int ig3rdma_cfg_rf(struct irdma_pci_f *rf,
 	err = ig3rdma_cfg_regions(&rf->hw, cdev_info);
 	if (err) {
 		destroy_workqueue(rf->vchnl_wq);
+		mutex_destroy(&rf->sc_dev.vchnl_mutex);
 		return err;
 	}
 
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c883c9ea5a831..c884f2ce282f9 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -5500,7 +5500,9 @@ void irdma_ib_dealloc_device(struct ib_device *ibdev)
 	irdma_rt_deinit_hw(iwdev);
 	if (!iwdev->is_vport) {
 		irdma_ctrl_deinit_hw(iwdev->rf);
-		if (iwdev->rf->vchnl_wq)
+		if (iwdev->rf->vchnl_wq) {
 			destroy_workqueue(iwdev->rf->vchnl_wq);
+			mutex_destroy(&iwdev->rf->sc_dev.vchnl_mutex);
+		}
 	}
 }
-- 
2.51.0



