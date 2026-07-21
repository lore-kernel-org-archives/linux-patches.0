Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727104302F8;
	Tue, 21 Jul 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662239; cv=none; b=NxTEzE6sn1d9RLTz1ar3jMW9gC+PsZGokLA/oNI0KlHFwhxox06R+h2yB1B4ns1SSSIyrBjp9Te2/eTGg++8+a9w63tDDgu0O+DIor2DbTHNosx7PgOIZWTD/XbvsvcQEXwMQsUyWSmb6tf4BLJGZIQZ8T9JWJHctGmApH4LwcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662239; c=relaxed/simple;
	bh=hlo0aa9cAPjgQDEnEFuNAP4wwK/aJWTjgQeaUOUyj08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+98Vn+ou99xHzY/fSaRRke1y2YmXmXZci42xESKSuXyb2HJYaqjh7iN5lL2nFgpiCxzlYakgpnGxAM6uAf67lIMMXUqIJsExGSLcPkMuudoafYDJ/YA8U3M/+ZJMEMRrn/e5jrzKQvGC5tRqmPEC2r8hzHTr5BI6RxNXci+0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9Z4tW+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9Z4tW+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83701F000E9;
	Tue, 21 Jul 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662238;
	bh=fNJznthVyckS9CkgIjsj31HHBvyffNc6TxmhoPbGytw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u9Z4tW+HNsf3sm4k90c09DbZIK41Q6uxTt5lAR4djaRUGWoq6ypKfVR1ULS9EUUEq
	 cQnURqwCkXmNek1DvdnRHhdorOI8g1vQk0LX8fMj85mH8CCjTu8QKgJLrbuUQ4sE2g
	 m2w37KAwAkf45kxZLD6ky3LEVYTKpMDvs8m9ALlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0326/1276] RDMA/mlx5: Remove raw RSS QP restrack tracking
Date: Tue, 21 Jul 2026 17:12:49 +0200
Message-ID: <20260721152453.391804475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ae0c3a24a1c9e6..ba704c723c6e4f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3078,6 +3078,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int err;
 
 	if (params->is_rss_raw) {
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_rss_raw_qp_tir(dev, pd, qp, params);
 		goto out;
 	}
-- 
2.53.0



