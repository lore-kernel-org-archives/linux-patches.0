Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5239734403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301865; cv=none; b=slgfNnBsHkIXc/cv43iiJC5Rv4RJc+vWwSNj/SSro2kIC/PxErAZ8NRbziHm3ESA2oF5b8xK/ns94vVoZXZgtliRZwmwhqyoyYLibmX/tQ9h+yn8Lu/RcEovqcUntACIiiJdc9Li7C/bkByvy2W+6IMdLhzRIbdlijl0FOrpbSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301865; c=relaxed/simple;
	bh=8m+ElpjqG5wqHcnRSJ4dnPuJLkVn04p6w6PvneogXsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Je+wgzlPO/MBjhMFrW1/JF4pzE5w+pY3n4lygp5857XuDfROaeTx4MOxD9kJ5oBOPinMBh5+5uxjeS4jqHT0r81vKyz9RyhLRVG1GHYPYzueH7Gx4gqZzchhNRXo3RE6+67uCO+rmvIORBKZW7epCwkgf7P7h2vOKO874AFNib8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvQgFtUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvQgFtUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56DEC116D0;
	Sat, 28 Feb 2026 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301865;
	bh=8m+ElpjqG5wqHcnRSJ4dnPuJLkVn04p6w6PvneogXsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvQgFtURtWyCX5copmMr3LmtSRNXW3mrprnqOCoG8JkPZ0yCRBQi+Ovb0F4UImeFi
	 uIc3xRnKvh9HfTQaj22mGvHwk6OEyuda1i1iZ880ZZJt2OkVIhNnnfSkb2RZV5X6i1
	 A/hVdePPA42I3kmHTOCrdopSZt/45oyBeSYPzToG1mqllGu5z8sEROiNna489jEBym
	 sgNPuXyrAGvG1IwcJOcGlhyjA0TgZW5BH2pNUO42tlBATmTJQnE+UyFXKwvGTK5ROy
	 GrWLAdOGnOkl5jj9EANLb9xpn6BtRdozsRjmzDzwmvaCTJyZFxTuhOeE9cJVtSTG37
	 EID8/Do1yg1BQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/385] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Sat, 28 Feb 2026 12:58:30 -0500
Message-ID: <20260228180011.1568201-288-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2c1eb8a45f673..ac81b7d1eec96 100644
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

