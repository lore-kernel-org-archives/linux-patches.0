Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A86E44AB62;
	Tue, 21 Jul 2026 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669196; cv=none; b=j++PyIPtmX78ejnUOBLO/mIgDIPNI0A/IdvPM4kJpFE9PX9qUOAYMelpJCQKrp+ZD3tdur310NuKVQRdrR4ORwmebvY50AB75OS75h5rDPcUuTICbZFliYcQXjCEbbUObBdYgVuHSHst04Gr6VetL2UxM9jjG65Vt0ok1/AR3sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669196; c=relaxed/simple;
	bh=4SdgtU4q/Mc6e6Zk3/9q/CsUGQ9y2aiLcs5x9WmTc9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBbbwnts6QdahxqlHa5o6lNH9aUGYughkZKWASw2hLzwzhf6sJ87lK82R1QSgLzPwPK66fDNcCCgcmN+0Ss9WBycyJ2yVS1GntNUBjSey+zqoKzjidmRwQ3NCEIe/CTNFPGPRvi4MDqrJIC3p8jb+Udh4EUcAdSs+czkoKjZsqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVecjhMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVecjhMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09491F000E9;
	Tue, 21 Jul 2026 21:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669195;
	bh=kGMQm+47jFfB7PxCmw//9DHyVc1JSDV1o+GEj40KpyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVecjhMjPbeZUxOXfBZHb+D2VIzE+ijVosydCsgQIBcOMPEixS6chc5ItZRozPlMZ
	 WXrDCHkAQ1UlmZSl9X65mGnHoY8cqDXg/XeLX0skVQRO3TlsGoFaDslWFr+jOVmx+A
	 dsYY55gcevADCrcBxpo91swB2jymerGctXltoYHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0426/1067] RDMA/mlx5: Remove raw RSS QP restrack tracking
Date: Tue, 21 Jul 2026 17:17:07 +0200
Message-ID: <20260721152434.150876905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d782a494abcda6..25d3d657889f46 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3005,6 +3005,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int err;
 
 	if (params->is_rss_raw) {
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_rss_raw_qp_tir(dev, pd, qp, params);
 		goto out;
 	}
-- 
2.53.0



