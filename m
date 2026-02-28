Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CF9270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302198; cv=none; b=ESwup271JWlxl+eEriPKNdOrmHsrfZMADB0abBvs3Yq+zeyo0CPm+D9d+9dfyqXXlKW2zSq3ZoITDSP0dXeFJrglKi0AgKQWvOnz2DYBBSY/uqZyopaUfFzStl9Xta5gSLFk8q3B1G1M2NOPk+Fgz7tdoAhmVH5CsrCReIh4Xn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302198; c=relaxed/simple;
	bh=BC1iNI8x3gduPjpFAi9hml7+vOAuf+yA4L+GygD18q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uit+xmKC9x5JbezrRAnd6jxpibn4v0acvu2vMGBNW55U1NMuGnmMrcuHSsU5i7qPc1FLTj4VF7JMp19MaMeK+D3nttK3V2GJ10sd0MHzs6/2O2xduToBpbueHqXI1azmtyxAMsXED+huJsKSx+IkwZRQ1bVYVvyyGflutIg1aog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsZIKN0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsZIKN0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBECC19424;
	Sat, 28 Feb 2026 18:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302198;
	bh=BC1iNI8x3gduPjpFAi9hml7+vOAuf+yA4L+GygD18q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsZIKN0XXGqkyXc/tJb2S0nqwuno27G5oegWu9AXrt9mXklM+HSULDXCLkFKpNE3P
	 r0tfnHCk5/v9MygFIQMpLaq32SCLsKNrhcPfrsn9Ry8oqjI1kl/snF66yrHZB4cnqY
	 wYJGGWspopOwq8+pndLziGGoTV4K3pKqH/Fe7I+M5vAPbTNd5IX0V4o45/FrvPGJZ3
	 QmaxdyXPkCm5A3FFSaKGFDaxV8kA3z2kdSJq9WhrLhuvdGLsetCmY+0e/Q7CamQn/6
	 NJUFqOHj0JtRsou35yAbtefpdOiuOOqo2IJVEZu/3bUoxm6Cs3zRVKR0PgmqHO81rQ
	 myiNRqmFdZo8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/283] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Sat, 28 Feb 2026 13:05:44 -0500
Message-ID: <20260228180709.1583486-202-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

