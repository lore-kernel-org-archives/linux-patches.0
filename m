Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57117B505;
	Wed,  5 Mar 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198057; cv=none; b=mZBXd48gWbjNpraq2VlcYftNtrW5NXaGEL4LI80ygfkBqPHZNQrIF9zykh7Fft1umTmVblv1jyjFCEn1No138E4U65yhaHeVMBKETsmkUc7qVhXsZZAQhABFk0lV1zHmjMmV8hqTnGM8AMqEPbzqg+aTlonnol0hMc4ub3iXz64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198057; c=relaxed/simple;
	bh=Z1NqYDyoZ6mjp8PsnEfIy5raIacj13Ew70H3YtJW+fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vqr7P0mjwYk7gWHvix28tImd/1voyHZyfLU/ArhfkYcUt/e2FpbkAJhBpAHvTw8ZiF8A3QMzlD7C+CgszP/bZ1FXYBVeDHDo7Szr+zMeLdNrwb76Y3k6nYIAMH3ZMPQV5Zlhg364z3Ihz/ar8hLa+0+FMP0FuNARlIJBTbq6C2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08nur/Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08nur/Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1258FC4CED1;
	Wed,  5 Mar 2025 18:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198056;
	bh=Z1NqYDyoZ6mjp8PsnEfIy5raIacj13Ew70H3YtJW+fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08nur/Bp/NBkW48pKqMjced5gU7BsLg5QKYjTh/K4G01ga52GOkTDbN+3oa6YX3yv
	 thqv5ZMGN3bIXdmIYMOkcea8lnxK7GycbiroM+ZGMPgXVF6L0lrMsmj89p3BY4n4fC
	 eH4/kIiJhz8VrMb6E2g7+T0CjZ84iz/S5K5Nr9lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/150] RDMA/bnxt_re: Fail probe early when not enough MSI-x vectors are reserved
Date: Wed,  5 Mar 2025 18:47:16 +0100
Message-ID: <20250305174504.101818506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 65ecee132774e0f15cd76a766eb39ec21118bffc ]

L2 driver allocates and populates the MSI-x vector details for RoCE
in the en_dev structure. RoCE driver requires minimum 2 MSIx vectors.
Hence during probe, driver has to check and bail out if there are not
enough MSI-x vectors reserved for it before proceeding further
initialization.

Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Reviewed-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1731577748-1804-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f0df225d12fc ("RDMA/bnxt_re: Add sanity checks on rdev validity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h |  2 ++
 drivers/infiniband/hw/bnxt_re/main.c    | 22 ++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index e94518b12f86e..7a1acad232c5e 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -154,6 +154,8 @@ struct bnxt_re_pacing {
 
 #define BNXT_RE_GRC_FIFO_REG_BASE 0x2000
 
+#define BNXT_RE_MIN_MSIX		2
+
 #define MAX_CQ_HASH_BITS		(16)
 #define MAX_SRQ_HASH_BITS		(16)
 struct bnxt_re_dev {
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 8abd1b723f8ff..32ecc802afd13 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1653,6 +1653,18 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 	}
 	set_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags);
 
+	if (rdev->en_dev->ulp_tbl->msix_requested < BNXT_RE_MIN_MSIX) {
+		ibdev_err(&rdev->ibdev,
+			  "RoCE requires minimum 2 MSI-X vectors, but only %d reserved\n",
+			  rdev->en_dev->ulp_tbl->msix_requested);
+		bnxt_unregister_dev(rdev->en_dev);
+		clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags);
+		return -EINVAL;
+	}
+	ibdev_dbg(&rdev->ibdev, "Got %d MSI-X vectors\n",
+		  rdev->en_dev->ulp_tbl->msix_requested);
+	rdev->num_msix = rdev->en_dev->ulp_tbl->msix_requested;
+
 	rc = bnxt_re_setup_chip_ctx(rdev);
 	if (rc) {
 		bnxt_unregister_dev(rdev->en_dev);
@@ -1664,16 +1676,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 	/* Check whether VF or PF */
 	bnxt_re_get_sriov_func_type(rdev);
 
-	if (!rdev->en_dev->ulp_tbl->msix_requested) {
-		ibdev_err(&rdev->ibdev,
-			  "Failed to get MSI-X vectors: %#x\n", rc);
-		rc = -EINVAL;
-		goto fail;
-	}
-	ibdev_dbg(&rdev->ibdev, "Got %d MSI-X vectors\n",
-		  rdev->en_dev->ulp_tbl->msix_requested);
-	rdev->num_msix = rdev->en_dev->ulp_tbl->msix_requested;
-
 	bnxt_re_query_hwrm_intf_version(rdev);
 
 	/* Establish RCFW Communication Channel to initialize the context
-- 
2.39.5



