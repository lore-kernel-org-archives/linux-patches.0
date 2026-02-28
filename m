Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4A139B97A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302606; cv=none; b=nqxsPdwFfk8+Mm9nDCtFFfJB2iG/VM1xrwYOkqyss9OrWQQmqgYkzxAcksXI8u5CbU0THFMwUr3cVdq8iVXyg9YCQytU639MA4CpeAMual2KNmWJQJcEPYCaNuDpGcPI41wRvtEXFtJjNnHyzKSFMv+xhjPVR/XORn4nO7IXNUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302606; c=relaxed/simple;
	bh=hdjATZPXBJLgvdH67/QienOJcmQVfzO1O7JCdPSQwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBOERVJff7ITHUUDmmVXcz8AXF9l6lGXJPh9mb6PzRUFlFypawdhwyUyscSMdL/wTlkroVEFUh//djOC+LAdtNJyM6nLP2emagcDy92EC54m4wZUf0s099X5GStZhvTJs/QShkhYuFE4rv01n+jf3r/9FBZtQcmEeGdAm9XNtU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u76rrf69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u76rrf69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E028CC19423;
	Sat, 28 Feb 2026 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302606;
	bh=hdjATZPXBJLgvdH67/QienOJcmQVfzO1O7JCdPSQwfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u76rrf69tvKGqWYJbH2KbHT7AbCx+TKk8Gm7QvXrnADnkBWDKNRffB3x7FrOihktj
	 YClNT0b7KbNRKyWhK4txQ1L7tOj/aYy/O3GezrX5EvVDlTxUOH7sYs1wDMo5VTTl7u
	 MYb7vY7pFx0FQ9GPB6nPEQqcTMdJLNy3VKklYrRpqFZf/0iK78Yn4jqdyGHenBsSoX
	 mvR+sqyNXtTNpeir62WZyjwGe/xL9yzgAuXdKGe2+XpYEPhfFLxIOCZLbJXhA2h5A4
	 VNXSsQwQoJg8QYbKnMz0qVxvnHIsPS+GUclkAnS1wR/iS0NevcE5mq9R28HH12DEF5
	 61A02QOgD91Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/164] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Sat, 28 Feb 2026 13:14:20 -0500
Message-ID: <20260228181505.1600663-121-sashal@kernel.org>
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
index 754a00e2828bb..9ae14c59777ee 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2224,7 +2224,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0

