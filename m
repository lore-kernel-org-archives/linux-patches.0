Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773251D0E06;
	Wed,  2 Oct 2024 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876459; cv=none; b=LBNbHptJXZM7T4ajAQwB2oHYR28aOnayrZ59Z/evceDOYmpB0AZgtB9mlIkxww8LoulcNcWrRc0IVb0AqwoDK9Frq+80whAfNtAbGMg8idHeq+tADosjaN6FunJMIp3bU7H1m+z0cf9pEMmmP7ziXWo5zt4K6qt8PfQIw3PrwrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876459; c=relaxed/simple;
	bh=tqrTgK6T4Q+JIBPomdr+uwwLivjXLRRddXbxZgFQ+r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwf0KhZUnl8ERu8zxQjszVDJUDxnqFze1bz+q6vh6GeZcmbqfQfM2C93Qh4OhATTSvU2qS5KHxjsumuKcRhr8HiIJEeY8hgaKO5+Epi1KSdsYbjyfe6npo35SILjtG5Dfb4ZI/uCo3SJVvBleDRi3mFXfZUcZSu0vyGpsVMdnT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhYgSmXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhYgSmXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DA4C4CEC5;
	Wed,  2 Oct 2024 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876459;
	bh=tqrTgK6T4Q+JIBPomdr+uwwLivjXLRRddXbxZgFQ+r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhYgSmXp4DuAG8XTs0Cf5XpaAf+5gEuV07xEaAMjO8p8zrW6rO5oze6gfdYzHphTn
	 tboPWTbdb55npaXqmSUcAxulcKUnJOK5FhWtieFDcCttUA5a1Kqi9ijgIAAmQTmxmp
	 kABw5dAM5Kt5mZSZ/WI3fJF++OfpP5Vv/OviWHDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 424/695] RDMA/irdma: fix error message in irdma_modify_qp_roce()
Date: Wed,  2 Oct 2024 14:57:02 +0200
Message-ID: <20241002125839.379931378@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit 9f0eafe86ea0a589676209d0cff1a1ed49a037d3 ]

Use a correct field max_dest_rd_atomic instead of max_rd_atomic for the
error output.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Link: https://lore.kernel.org/stable/20240916165817.14691-1-v.shevtsov%40maxima.ru
Link: https://patch.msgid.link/20240916165817.14691-1-v.shevtsov@maxima.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index fc0ce35da14e6..c7475c925d1b4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1347,7 +1347,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->max_dest_rd_atomic > dev->hw_attrs.max_hw_ird) {
 			ibdev_err(&iwdev->ibdev,
 				  "rd_atomic = %d, above max_hw_ird=%d\n",
-				   attr->max_rd_atomic,
+				   attr->max_dest_rd_atomic,
 				   dev->hw_attrs.max_hw_ird);
 			return -EINVAL;
 		}
-- 
2.43.0



