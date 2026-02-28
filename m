Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA563603EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302743; cv=none; b=qhUDdrqth0uFQThzylhcItxvMf45DenCqG8cwiFwaXIEaA3kklxuvh6f/SS4cQQWmk3YcvHmuyONOeflRY9tf7bd+m528/kGW4LdcgNXewhyFjd2xpBcTT9R0ZW53r0etT/bjNyc33zQ2bUxXwCMn3+nD4vycS9IIOCQKMa+bZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302743; c=relaxed/simple;
	bh=Tbz9FgSvt51e+1amdhtYsJFEV6Moc5snKdx6/Nieo88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+6bmcuE4oqQpyIZOkZNs0wF5ZEN70gk6R5eGDSZYeTg2ncFTC7K/dfVAiswNnZrezm8757mU1oMaS9CessFKxsRzfcpNx/B3aeUzvFIkvXO9MyFsbhQdKKiQ0veTxDr83romQNAFLrLfk7y00XroYp2Q/gF9Q3bqIGC1r5iReM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwJEkKUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwJEkKUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E112C19423;
	Sat, 28 Feb 2026 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302743;
	bh=Tbz9FgSvt51e+1amdhtYsJFEV6Moc5snKdx6/Nieo88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwJEkKUZngMyqZQEQqJxCmJHh2Ff1NpWqL6cgWdqLC8vs62mRR07uhfvrg1ggJs3S
	 THiZNplmF7NSvp8wyvFOU8b/yF3PMaJQZZeh9/82izJUjZekCNkZCAtn4cI9qcl8RM
	 6jUzYLyz5cPwVQWwe+cVQyktSHSLcdnHf19vElAJ+vlA6CyyA0JJXGqo3y2z9STtmL
	 PhYdUT4v/sPayMUXTvw4zuiCfgZR6HEewi4TFUmzWQ1GPj2m/4H9Brm7QNDThE3PDc
	 552RZMWgt0WlU3FbUhZ1fwvWVeKQnJEiejRF5H0T7TLpHtvWRAjfmQXQDSdX5ejuBp
	 Zvhgly3WvYqeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/147] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Sat, 28 Feb 2026 13:16:57 -0500
Message-ID: <20260228181736.1605592-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index cdcdafee07f68..732940483811a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2210,7 +2210,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0

