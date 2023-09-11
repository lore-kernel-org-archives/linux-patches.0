Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FDC121
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C061C433C7;
	Mon, 11 Sep 2023 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441722;
	bh=eFlbqUB9LKO+x3Z+/4qQvx2+NhGkztABUHkINfkXXdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoDA1wLFRx9incjOKlI44/EZkxOWUcF4P3LswB0XZsJNn8bliWQgkx37e1EU2ai4l
	 EB41kCjuWacs7x0Y1Me+XSEoOnRHZZJP9ESYJx1y/vALD66CZoC4lg1GZ3jgF1CL4J
	 76rypKnBvm4s8zpIihFfM9cQBjEt8uBEOm2JiS50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 513/739] RDMA/bnxt_re: Remove a redundant flag
Date: Mon, 11 Sep 2023 15:45:12 +0200
Message-ID: <20230911134705.451138943@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit fd28c8a8c7a10e7b53851129c6d8dc5945108fe9 ]

After the cited commit, BNXT_RE_FLAG_GOT_MSIX is redundant.
Remove it.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1691052326-32143-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h | 1 -
 drivers/infiniband/hw/bnxt_re/main.c    | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 1543f80a1b5c4..5b6d581eb5f41 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -138,7 +138,6 @@ struct bnxt_re_dev {
 	struct list_head		list;
 	unsigned long			flags;
 #define BNXT_RE_FLAG_NETDEV_REGISTERED		0
-#define BNXT_RE_FLAG_GOT_MSIX			2
 #define BNXT_RE_FLAG_HAVE_L2_REF		3
 #define BNXT_RE_FLAG_RCFW_CHANNEL_EN		4
 #define BNXT_RE_FLAG_QOS_WORK_REG		5
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 3e6fbc39eeb11..120e588fb13ba 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1296,8 +1296,8 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev)
 		bnxt_re_net_ring_free(rdev, rdev->rcfw.creq.ring_id, type);
 		bnxt_qplib_free_rcfw_channel(&rdev->rcfw);
 	}
-	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags))
-		rdev->num_msix = 0;
+
+	rdev->num_msix = 0;
 
 	if (rdev->pacing.dbr_pacing)
 		bnxt_re_deinitialize_dbr_pacing(rdev);
@@ -1356,7 +1356,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	ibdev_dbg(&rdev->ibdev, "Got %d MSI-X vectors\n",
 		  rdev->en_dev->ulp_tbl->msix_requested);
 	rdev->num_msix = rdev->en_dev->ulp_tbl->msix_requested;
-	set_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags);
 
 	bnxt_re_query_hwrm_intf_version(rdev);
 
-- 
2.40.1



