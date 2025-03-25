Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9128B2571AC;
	Tue, 25 Mar 2025 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906105; cv=none; b=qsuyXwG0YXJHv15R8xMyjD8jZnRjDnHd9VqTSR6T6K+uXhnyJd4YaMUt0g4cha9xLgGS8OGqgtxeCWX8YfmAf6uGO8aVwKgtCNX/4BWk3CQ++4IceJ8KJ76onD1gBjN95PjuGn6nmwl7IlQvp4e1G1CkH1BiyanC9mqg+HXzW7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906105; c=relaxed/simple;
	bh=NOLNjKZKj0S1NOcTcl38Kc0gUePuHMD5DgkmMV4+rtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WH+RhDS3Ll0uh80+st/OPZmwQJH5Of2oskXjYoJu8mHLxCGafiFlRly5WLyc8BhBGG10unQe94rH7as57PwjcdNXPDeKd63GwjDIQXftda/5RCqplZmgpTPAdZiLAyxsHJLT0I1tA81++syuxb/cujKBjjPsYLbLpkgZw7A8cLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e53H0bMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e53H0bMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC27C4CEE4;
	Tue, 25 Mar 2025 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906105;
	bh=NOLNjKZKj0S1NOcTcl38Kc0gUePuHMD5DgkmMV4+rtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e53H0bMn2C1gXibiw1FUBaduAe+oVRle0IplOqtB8mNnFPJXnk7G7YBEsJRXRFoWL
	 fCj+3PuFfUAAegA2xOvtYEJSdMeib75h6EPVehfmos9uJfLfZFb27gM5RQgW5cLzlw
	 d6kj+eAcGPdd4ehk4AH+A9HKaWEndQl5lzRLSLWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/77] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue, 25 Mar 2025 08:22:13 -0400
Message-ID: <20250325122144.823027826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6b5e41a8b51fce520bb09bd651a29ef495e990de ]

There is no difference between the sge of READ and non-READ
operations in hns RoCE. Set max_sge_rd to the same value as
max_send_sge.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index c8c49110a3378..dcd763dbb636d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -182,7 +182,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 				  IB_DEVICE_RC_RNR_NAK_GEN;
 	props->max_send_sge = hr_dev->caps.max_sq_sg;
 	props->max_recv_sge = hr_dev->caps.max_rq_sg;
-	props->max_sge_rd = 1;
+	props->max_sge_rd = hr_dev->caps.max_sq_sg;
 	props->max_cq = hr_dev->caps.num_cqs;
 	props->max_cqe = hr_dev->caps.max_cqes;
 	props->max_mr = hr_dev->caps.num_mtpts;
-- 
2.39.5



