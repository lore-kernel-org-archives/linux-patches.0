Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E01D4154;
	Tue, 15 Oct 2024 11:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992915; cv=none; b=Ga4UdMvGTUGh+koCCbcdPHLuTCh206OsQHu+pxJaPhfXL828FOYba1jW6sWF3lZDXMA4J//NFOPkZU9dQ2JOT8SDCK3G+zR9HUsSjzv+UwaxAS6z8+hI2k8hjs5/272jRusqe/CY9dnqY6lEMdh0gtGz+psyQ+krFmUmpk5f9sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992915; c=relaxed/simple;
	bh=nyTwTPYiLaGISJhWvp3C4jNisZD0Kkk8cX8n1LLVqlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZQrVIdfFZRqTaPzlMdhYOGll+RJN6mZl+0Kfq1ZsBsPlkrM0sl31p/SEuHG4SlOsnPdzkfh7QOpIrBo2VpOKkDpToPXV7t+SgUb3T5CpMhSPiMMf8ndET5fsweSFWLi35KTAX90VbmL8QB8popGj7mGKRKWwOip/RUQ/SHYdkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mi5Vwcam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mi5Vwcam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C347CC4CEC6;
	Tue, 15 Oct 2024 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992915;
	bh=nyTwTPYiLaGISJhWvp3C4jNisZD0Kkk8cX8n1LLVqlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mi5Vwcam66zaT9BKXEh5pc0b1a602J0vTDMBzEkgLXPR/fd6Pt1CKmx1lMk0757on
	 7YnIAApMDtzeI3F6CHsZPzH6raZxJX6o40Wc7EEZ9y1tfwGfRN1U1e9TjNReor/lda
	 rCyP2hYul7QQYD7eGmxi2dgzgEu4anW0UHROtK58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/691] RDMA/irdma: fix error message in irdma_modify_qp_roce()
Date: Tue, 15 Oct 2024 13:23:25 +0200
Message-ID: <20241015112450.551030845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit 9f0eafe86ea0a589676209d0cff1a1ed49a037d3 ]

Use a correct field max_dest_rd_atomic instead of max_rd_atomic for the
error output.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Link: https://lore.kernel.org/stable/20240916165817.14691-1-v.shevtsov%40maxima.ru
Link: https://patch.msgid.link/20240916165817.14691-1-v.shevtsov@maxima.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index d43833e141a02..b2bf147883edb 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1258,7 +1258,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->max_dest_rd_atomic > dev->hw_attrs.max_hw_ird) {
 			ibdev_err(&iwdev->ibdev,
 				  "rd_atomic = %d, above max_hw_ird=%d\n",
-				   attr->max_rd_atomic,
+				   attr->max_dest_rd_atomic,
 				   dev->hw_attrs.max_hw_ird);
 			return -EINVAL;
 		}
-- 
2.43.0



