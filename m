Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A44422E08;
	Sat, 12 Sep 2026 10:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208130; cv=none; b=O0mAqjZzyeGWWgDlOE3BfjsWj5MsC9I+8BbGGPdZrKSu931229g1w3UsZSCmZEFDw509+kfDZljNg9m9xXOlsbcEzabmHeJim7fRD5EhyC3eoFew3JqUmd+g6CuifQIWJelWqlUOgJ5xuBXkeHqOEEG/u69Q1ZPgMnErvVDYKzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208130; c=relaxed/simple;
	bh=l+GWCyiBr2vTKmE7c7uupgp/qy+p5VYMj/+jQUxwFgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a54u1qOqDQ1kmHI2n9DyT/QqvxWnS5Zz/56O6WAgOML3G2D1QG+NzMwIiUWNvFZzlsk0ftzZIhd6X06bKMtEx0qj05h8lokQ2K+e1X6R8+h585s/AAMleaXuWTSzr9Dtun71xinxamKuZXryhdrLI3VbYZuOAF50usAq+SDwf1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSdk98NX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSdk98NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848041F000FF;
	Sat, 12 Sep 2026 10:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208129;
	bh=F/F2FSFhX2eFcaFrsDC+bRXFdH49eeVqTDpPn1Vn8CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSdk98NXNTRMK6cdF8BYhXONGu8lbelE/eZ0DDvwqb7eTXlI40QuJjP86l3emUInf
	 S3fn2hASPsfD9zhhaAoAd9qbifQyodFGIgl/PhtQsfof5gcLtBuDXgdceGGz9tFXcD
	 2+JhGEHt6Jm1uklDFIQgklyT+TnpU0BT+9DQXW1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0512/1518] RDMA/restrack: Fix typos in the comments
Date: Sat, 12 Sep 2026 08:44:41 +0200
Message-ID: <20260912065635.026848168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit d43358cda7c4696e08880aaa58a7df82e471fa7c ]

Fix couple of occurrences of the misspelled word "reource"
in the comments with the correct spelling "resource".

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20251113105457.879903-1-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index a7de6f403fcaf..b097cfcade1cb 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -175,7 +175,7 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
 EXPORT_SYMBOL(rdma_restrack_new);
 
 /**
- * rdma_restrack_add() - add object to the reource tracking database
+ * rdma_restrack_add() - add object to the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_add(struct rdma_restrack_entry *res)
@@ -277,7 +277,7 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
 EXPORT_SYMBOL(rdma_restrack_put);
 
 /**
- * rdma_restrack_del() - delete object from the reource tracking database
+ * rdma_restrack_del() - delete object from the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_del(struct rdma_restrack_entry *res)
-- 
2.53.0



