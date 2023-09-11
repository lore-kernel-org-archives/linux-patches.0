Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C531170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA9CC433C7;
	Mon, 11 Sep 2023 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441711;
	bh=RgZvhWmK0NnEGqV9vMA9lC8R2E0ef3gUlfW8BtUPtkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aS3B2b6UDpEmPBPxURk2CDzpgByKUyuEP2EQkycjzCs6kYYptWMX2gXGPD0eZAfW
	 HAtrQjcUlnwxmuCYoP7BetxXD/nYK+DiEQgxu93oLKcaDJX+qh9J3ic9ZdLbCHr9lK
	 y5oO/lXXiEWcYuVxvyYDcMwdRBXPoNXcHcdDknIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 510/739] bnxt_en: Share the bar0 address with the RoCE driver
Date: Mon, 11 Sep 2023 15:45:09 +0200
Message-ID: <20230911134705.372887360@linuxfoundation.org>
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

From: Chandramohan Akula <chandramohan.akula@broadcom.com>

[ Upstream commit 61220e098e858951f1926d66c1490a96351e1c85 ]

Add a parameter in the bnxt_en_dev structure to share the bar0 address
with RoCE driver.

Link: https://lore.kernel.org/r/1689742977-9128-3-git-send-email-selvin.xavier@broadcom.com
CC: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: f19fba1f79dc ("RDMA/bnxt_re: Fix max_qp count for virtual functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 852eb449ccae2..6ba2b93986333 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -345,7 +345,7 @@ static void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
 	edev->hw_ring_stats_size = bp->hw_ring_stats_size;
 	edev->pf_port_id = bp->pf.port_id;
 	edev->en_state = bp->state;
-
+	edev->bar0 = bp->bar0;
 	edev->ulp_tbl->msix_requested = bnxt_get_ulp_msix_num(bp);
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 80cbc4b6130aa..6ff77f082e6c7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -81,6 +81,7 @@ struct bnxt_en_dev {
 							 * mode only. Will be
 							 * updated in resume.
 							 */
+	void __iomem                    *bar0;
 };
 
 static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
-- 
2.40.1



