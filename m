Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5388B39B976
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302596; cv=none; b=a8zQT/53nl0VyZjgl3uiu4Q2BN65EsA5S7l3uKjMmfUhVOpaJGVrZq41o86hn8t/mzNJemoibu+5Qb26rO1HaCoI3XEjoCScvwUNKpwaPRn6Dt8w0S7jnYH2ZEgP4wdA1BCkclc5Qckl7EOc0g6mlFDQ5+PWC+PUM7Y9SF+Kmjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302596; c=relaxed/simple;
	bh=f5F3f2koXaml3O2TQ1Th0evA7XiIFcOsw9N21osplyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN6Xp5WpOmj4lFwoHBr3FRMd94CLcs0CuT34v7zui+6wr19+lH6WjtIvhv2OHSok7HjqynMIvSD4RORGTd5zJmum5/mkT3A9ztYvWgakUW9LL0wROnbExmUC7zEuBCjmIr2nQlk/4kUMK1mwfSy7h2RfQ9lraihQtx4u5hOiMc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1v5isKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1v5isKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16F9C116D0;
	Sat, 28 Feb 2026 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302596;
	bh=f5F3f2koXaml3O2TQ1Th0evA7XiIFcOsw9N21osplyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1v5isKKeoLV43BxQ2EyiIMI0y9Mx6edxcaQ+2jUryfD013u1R0ERg6qsbk/v34dw
	 4ynzVLkLvUmZcauwJO9goCK717VwSxtdHdcPNAs7gRQB2O3Asb6BXar7FeJiRfmJ2+
	 pyrU5g7ejANWU+J85W4cprhE1GmY3/N7LSJjUq/FYmCsSg7wpxvhe1R9zK9u9I1vH5
	 GsVcqeFjv6xhRChciQtt0S4sIVGT9gUgtVQOsHLuSe0zbMnIsnG6sA7Onb30RoB226
	 8geXeFNrKvHFncZC63ovKgV6YUvdNWBWfUrVPa/4m7QKwMkimvCEa9pJuBAb5jvBEI
	 vnKrq3fs2uGYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/164] RDMA/rtrs-srv: Correct the checking of ib_map_mr_sg
Date: Sat, 28 Feb 2026 13:14:07 -0500
Message-ID: <20260228181505.1600663-108-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 102d2f70ec0999a5cde181f1ccbe8a81cba45b10 ]

We should check with nr_sgt, also the only successful case is that
all sg elements are mapped, so make it explicitly.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20221117101945.6317-4-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 83835f7c07b5 ("RDMA/rtrs-srv: fix SG mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index d2ac3a37f46e1..b5f3cbf0fd79c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -627,7 +627,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		}
 		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
-		if (nr < 0 || nr < sgt->nents) {
+		if (nr != nr_sgt) {
 			err = nr < 0 ? nr : -EINVAL;
 			goto dereg_mr;
 		}
-- 
2.51.0

