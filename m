Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5C359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302424; cv=none; b=e+VomIBJk1KUN/qmoS5Nwxf4PT3IE0ToTjljh+vovTD5wnD5VRjutPm6NAhAZnMwUnW9Xi2MDpcJg2dePQS/xFNaHRpNhVi5ugvxFcdasxi43hLC60f6bT6xD+DdeAsSGylyltcim8B8jk3vuzmHzOWyEH6gW9rUlAsfx7qm/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302424; c=relaxed/simple;
	bh=BC1iNI8x3gduPjpFAi9hml7+vOAuf+yA4L+GygD18q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNobD7dsHVULDulJRGnK42W+h5jdGoPfsebbLPiMHD8OKC9+iS1o5gPulyB8qvyPhYv6hKCBIrPsCM1a0bwpfkMdYLN5x/iSX/Mpuhd8TmRjMxEiepZ2iVaN+U7Umu9wFx1zWyMsg2UUrFZvqRWiRGqFhQl82jg6qxyDCazozvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNWvskmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNWvskmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D034C19423;
	Sat, 28 Feb 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302424;
	bh=BC1iNI8x3gduPjpFAi9hml7+vOAuf+yA4L+GygD18q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNWvskmGc6UTJNDDPauoep2i27bmgENyK8nH7AS10iWOOXHR1D4IjIysagGASfqal
	 gw4ILEOGAIxHyS529XBTHgXwhviesqYqoUamzAXhJYR+C9RNIpnIdUrcs5gLhCBsKB
	 W6tKOdVkX6IVP9qPh5kRo/lA6i/L4MolYc8aj7eW4ZKim13rT31pICadnf6Xhn+O9d
	 8ZAh9AYmZpLcVTL5mPZBF2K10hb3H8hzPRWayFmYm3adBp8UeZxV5zM3tiwIyBc1D4
	 LXapHCPyfWyn1tp7qXgzxIkb5yPm+OrGZHX9ISFz0xQ1eBy/uH+AVctr86KRDxbEQ0
	 HFtZWZqJ9NjDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/232] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Sat, 28 Feb 2026 13:10:13 -0500
Message-ID: <20260228181127.1592657-160-sashal@kernel.org>
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

From: Yi Liu <liuy22@mails.tsinghua.edu.cn>

[ Upstream commit 58b604dfc7bb753f91bc0ccd3fa705e14e6edfb4 ]

Since wqe_size in ib_uverbs_unmarshall_recv() is user-provided and already
validated, but can still be large, add __GFP_NOWARN to suppress memory
allocation warnings for large sizes, consistent with the similar fix in
ib_uverbs_post_send().

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
Link: https://patch.msgid.link/20260129094900.3517706-1-liuy22@mails.tsinghua.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2ed51a7df60fd..2e4265ba35b7f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2223,7 +2223,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0

