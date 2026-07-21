Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD7472558;
	Tue, 21 Jul 2026 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656667; cv=none; b=tTDO4Q6AyhAo+8WE+8v3BYt19yDUnM5dmrP2vy9lX6H1sOIBS7Am//umlJ3zMUOacfLVG47C/b2lcYTQ3L3hcqkBh0zA/HvGX2ypSdiiz4LueYFQ7HK947AaPnY7rnOd0XmS3i2oioo/nAz8XO+//n/g/nGEpQgfOKN2JCQaoTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656667; c=relaxed/simple;
	bh=f3ZvkkpC0ZIMBjKyBEuBoPghtLAp285X9kA7tnAuOQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqQGxHg2LVhRvieJ4fly8AZwPfxOP81N398zFkoIjkC3JJgGKfp8CzGSVaqnfDytCwaRoGpAry59y0+O1wItzDCaKQI9waJCtER0BuWPut3rDKSQbMRdLqyPXuZyIrQyos1xpksFGHD3SA4p3vWoUOYreqPFDS0pdH2WP/NBfGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNmrRetr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNmrRetr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7731C1F00A3A;
	Tue, 21 Jul 2026 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656666;
	bh=Xb8thuneW+5zA7XfB5w73UiG1eufq2zp3Ck01Hgp2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNmrRetrKUEA/zKdPcrF4EktOv2Uc9brWDGHJkuVrr8GzpBGJhrhplV9TuBLnbD/o
	 KGqE3waxCnav59mDe0+lK/8zB/dgpBI3hrDeECSJcaCvcK9eh0UuomtfdYWODke8Od
	 yfX+3Jgk86tCWP9JpZx9guPsxkikwQ5tcWw9id+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0474/1611] RDMA/mlx5: Remove raw RSS QP restrack tracking
Date: Tue, 21 Jul 2026 17:09:50 +0200
Message-ID: <20260721152525.987712044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 67294cac625bfb..49566479f70474 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3105,6 +3105,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int err;
 
 	if (params->is_rss_raw) {
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_rss_raw_qp_tir(dev, pd, qp, params);
 		goto out;
 	}
-- 
2.53.0



