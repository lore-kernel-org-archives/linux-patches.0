Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5361740B119;
	Tue, 21 Jul 2026 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649760; cv=none; b=AK0xrXmgj7H3EyPnGUEfv2notSvFhwP9BQEDlZ2kK7ehgLQ1UkeBoNhuzkNxFKoEm8MM2yAMcaLZkpIbOSPaVinWxZ20D9gqBCEaV5gPEuWKQIEU0Q2Hwty1Y+F3df0NlfcNaYtxzu0Y7M4Jzb7Asc80/xRX0R76TSo2aSOnV2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649760; c=relaxed/simple;
	bh=MGMR/pdWDYIWqs0W1t0xn57V23gUHcabVaznGMFhYVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMq6VigZP/zX6L421OocjTe60yRugYQO8eauJ7yv1m5ltrCREr69b7ic8VbNrmWz5aucFgoiaBtf8lYkKqZr7abG2kfU3w9j+X9fxfqt70XhuLADOkKaYJsDZj4NoCX0zaU85pakMb2aKhJaLcBGzvnnk0POGU60VOsGlJGyXsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWzeMCAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWzeMCAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F91F000E9;
	Tue, 21 Jul 2026 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649758;
	bh=Pxaqf4XYchnOjZl6Ztb70JVE9Yx5FBqka30ZaBDHbmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWzeMCAuMA/hPJ8NtSZdIB9Npa0MIquTjLRjIU29mg5SVzFeVovqase9VIsuq3dlM
	 6JuQeymDWtR7NXqUmvDbqnrwrDGCEV8AUp84i4N4JmZZUTMLjh2LosqLMYud512l/5
	 ZABFM52w94nflZqR06NXoO06yQqbl5Jh5hGj9YWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0697/2077] RDMA/mlx5: Remove raw RSS QP restrack tracking
Date: Tue, 21 Jul 2026 17:06:10 +0200
Message-ID: <20260721152609.234157389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f8cd69905a42f..767444bcbce5d2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3109,6 +3109,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int err;
 
 	if (params->is_rss_raw) {
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_rss_raw_qp_tir(dev, pd, qp, params);
 		goto out;
 	}
-- 
2.53.0



