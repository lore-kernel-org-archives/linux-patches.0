Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D143C1081;
	Tue, 21 Jul 2026 22:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671676; cv=none; b=c42PazSsnmEdHB0p7ZsODS2V3CQq5Bwpp9Y3qHjZmK6M+O7j1fNERr13f3Zy/ITobSWUqivqiZ+hGpX+0DT764mAUfX+PzhwREFWZFFa/434rHl8PTwLbyAgAO70Oh8yclYQlhQ5cMurYrdh0Tk0mQJMBNFRsgNHLNaNxvv9pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671676; c=relaxed/simple;
	bh=CGV2vkWlunn/yFke2VkLm4DmgIXUjbMz0I9B1t9UXNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDIEUS+Qhp7la0KUNujwN97+M5VpShEalemO1HI3kJETTXvPd3a0u4nbM/VRzq+DVmbJ/Rqble5M9DA4dmfS4HfWvKOKa4fagwTMU4dKWkek8G807yj0M2jaHLkhyYXIP4DMagx02bjJKxLU4k2hIos0EpVq3lV8FICGUJTZAgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEzTxu1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEzTxu1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A264D1F000E9;
	Tue, 21 Jul 2026 22:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671675;
	bh=Oa7VDMOzWsHOvKHYKuMfkoX6SZfubBaI4rB/dhbeIV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEzTxu1sgHCIfqgoRbWWrcjM8/Qa+MzMgtWBqGwKh249QOrTfVKOTythdIJ+o8hh+
	 t7KACzppUH0Tc6p8VyB/eGERF/K1W9NMx4o2Vw1uvBHE/nQyTakiHMTWOcPvVcfTcM
	 ksg2KSn5UowPvSstgsi9grv+IeTiCV904mxAIeBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/843] RDMA/mlx5: Remove raw RSS QP restrack tracking
Date: Tue, 21 Jul 2026 17:19:31 +0200
Message-ID: <20260721152413.579523459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 666031fed8f0fdfc29b20d125a628c1b0a04cdaf ]

Raw RSS QP restrack tracking wasn't working to begin with as it was
only tracking the first raw RSS QP which was added, since at creation
the raw RSS QP number is reserved so the QP number for this qp type
was always zero.
The following raw RSS QP additions were always failing silently.

Since the fix isn't trivial and there were no users that required or
complained about this issue we are dropping this for now instead of fixing.

Fixes: 968f0b6f9c01 ("RDMA/mlx5: Consolidate into special function all create QP calls")
Link: https://patch.msgid.link/r/20260607-restrack-uaf-fix-v1-2-d72e45eb76c2@nvidia.com
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d58ed4a09cd939..f15b89be3b0b92 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3000,6 +3000,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int err;
 
 	if (params->is_rss_raw) {
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_rss_raw_qp_tir(dev, pd, qp, params);
 		goto out;
 	}
-- 
2.53.0



