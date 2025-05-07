Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADC29A0;
	Wed,  7 May 2025 19:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644599; cv=none; b=N0IN0C5CQ2uxubEO2t+KgnQuwEj8Q2yIiLAdcL59ielNq+Fog/0+jjNANJnzVC3MdxvrVCOndAKTPrtleBa/YJdHhZ17Y7KuVVJpne6wYc5b23J1RSYPjFmp57wCEu7Tyl8YF48hEWmAd+6mORNbyq7zomjxLBQXuSi9R8Sf9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644599; c=relaxed/simple;
	bh=g/IfcBELyvLSgAYNm56umpOrumAJezdf88x59O5YgMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNWCBHxnCBexpn/BTdnF4NBiBDhsU5lWp8q65iAEtnDFb3lBAaBaFzj6x55AZEFBk1pkZJlbiO6AUyKf7Bo3tt0KCUOWOCaFVUsJEy+NVsJN3xDoK3gKRA4ikjh1upxq3RHiICWGcBRnwsYjVM23CKSXnlROQs4hQ4j9yYhHOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TveQS/WA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TveQS/WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E2CC4CEE2;
	Wed,  7 May 2025 19:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644599;
	bh=g/IfcBELyvLSgAYNm56umpOrumAJezdf88x59O5YgMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TveQS/WAArhy9LmkGvqVsHklS/8fzV0n2aMsNEvqO4P3GyYSZv5W4CYhJ6eEyhafy
	 iYDUOEYN331kPnlnuOVL9F47KQwAEN+0pS2r1Z9uru3g4/sI8DUU+qRSlf1Q9NZWZ2
	 izzgCdT6AyA6+JUfddbrF7/c3QocACYUpRustcJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/164] pds_core: make pdsc_auxbus_dev_del() void
Date: Wed,  7 May 2025 20:39:33 +0200
Message-ID: <20250507183824.526183746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit e8562da829432d04a0de1830146984c89844f35e ]

Since there really is no useful return, advertising a return value
is rather misleading.  Make pdsc_auxbus_dev_del() a void function.

Link: https://patch.msgid.link/r/20250320194412.67983-2-shannon.nelson@amd.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: dfd76010f8e8 ("pds_core: remove write-after-free of client_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c  | 7 +------
 drivers/net/ethernet/amd/pds_core/core.h    | 2 +-
 drivers/net/ethernet/amd/pds_core/devlink.c | 6 ++++--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index b76a9b7e0aed6..d53b2124b1498 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -172,13 +172,9 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *cf,
 	return padev;
 }
 
-int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
+void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
-	int err = 0;
-
-	if (!cf)
-		return -ENODEV;
 
 	mutex_lock(&pf->config_lock);
 
@@ -192,7 +188,6 @@ int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 	pf->vfs[cf->vf_id].padev = NULL;
 
 	mutex_unlock(&pf->config_lock);
-	return err;
 }
 
 int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index ec637dc4327a5..08b8280437dcf 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -304,7 +304,7 @@ int pdsc_register_notify(struct notifier_block *nb);
 void pdsc_unregister_notify(struct notifier_block *nb);
 void pdsc_notify(unsigned long event, void *data);
 int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf);
-int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
+void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
 
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index ca23cde385e67..48a7c22fe3320 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -56,8 +56,10 @@ int pdsc_dl_enable_set(struct devlink *dl, u32 id,
 	for (vf_id = 0; vf_id < pdsc->num_vfs; vf_id++) {
 		struct pdsc *vf = pdsc->vfs[vf_id].vf;
 
-		err = ctx->val.vbool ? pdsc_auxbus_dev_add(vf, pdsc) :
-				       pdsc_auxbus_dev_del(vf, pdsc);
+		if (ctx->val.vbool)
+			err = pdsc_auxbus_dev_add(vf, pdsc);
+		else
+			pdsc_auxbus_dev_del(vf, pdsc);
 	}
 
 	return err;
-- 
2.39.5



