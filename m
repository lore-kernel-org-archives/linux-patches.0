Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D083E359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302412; cv=none; b=kACAdMOxaZIFtJg47r7mTXKQzlhoquQwEaWFkNIaCg2C7PQB5BVsZjrF6M8NW9gX+zeZ2scYInDS5FDzrbLtmfJ79khrgZNimHVvLAlkEz4p6GZdKxmtakv3ds6RnNOmrPdMP6ygiHBwDMm8xXlfuDvl42WSIIZR94LQFvdIKYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302412; c=relaxed/simple;
	bh=2O2HWrYcknT7ju7vF8EJokqpkB7OuQ2vYwjNV5rogJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+lrH9sJhi24ZSeusYW1hE15g+fq40aRHqa/fNcGRJBfjnsftiw4MLcMzUWIbcIJrPkYMZ7K+R/U6MA0lPRP3AtB4amZHaF4qtRAY88NTTyBBBd4ai2b6wVJNgy3ahDbTClSmiN90Pr44TArFSugkHV1DrTFZM/80QL1cDvsimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHkhVl8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHkhVl8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295F5C19423;
	Sat, 28 Feb 2026 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302412;
	bh=2O2HWrYcknT7ju7vF8EJokqpkB7OuQ2vYwjNV5rogJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHkhVl8pslZoozqGso+EEBS3b9noavpm3x4onvxOWCMqqxkiWdI2283gn2NRyOq7L
	 zfc+GSvIMOJTvxLe8NmW/Bea023BGG4bbj6D6zq4o/dLHIBrTiYr54vOHcmcFbZs7G
	 7AT24romPcqCNl3EOyPG1cYuKpVsOqrGf7g4xixDIvWuuCojNgqHjchEK3YQyXUDfa
	 bLnJWW0uPglIcJlKIx4b6bqFg1271OgswuYTiB0sv/DG2h4iM7g8mYRuhDL+tWuI5v
	 8KBoHnQ7Ep+27DVtRVnhJxEQS3X29y4tTNE/Sw0r/vD+YZ3ejsctIFuRBrVDBNfTje
	 fbuCVy//EYOdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/232] RDMA/rtrs-srv: Correct the checking of ib_map_mr_sg
Date: Sat, 28 Feb 2026 13:09:59 -0500
Message-ID: <20260228181127.1592657-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index c7f4dc7f2f7da..b0d5ee6d15224 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -620,7 +620,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
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

