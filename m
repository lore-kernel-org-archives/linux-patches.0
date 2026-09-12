Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE464BEE38;
	Sat, 12 Sep 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229915; cv=none; b=HEnbY0pO0xlP/eFAXH2323zKrzTQO1tdjtWoWvljZa828SFMxa/sZttiLZH70slZy0CBNDdL6aleFRG3xpHNUq1P7dhI9Idbr2ttOnk76fabqDf0I/U+TqtBwlq2a+6ABTMxEwRJgCcUpnn0nkumGRrA/NVbQnudQPtjV2dIxhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229915; c=relaxed/simple;
	bh=bLoCaxHZy48DX6Y2WcwPBsjiyTQiRirI1efOjpRVVzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3nxBL/GKn5e4nm5YOiglH2YhhD1Qo+Y9m2RoE67iV2z6ODIx0JpVlfErXVggD5wYbqCuR5NumSNfTgrW0qmI7ywNoz/bro7kY/kJsuAS2DacJvtGZqNwwJiYlQdA2mt1Cx3sGe69M875LkHlY86IFo0XYBdXhONVIA+k9vCxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP40f6QU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP40f6QU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD21F000FF;
	Sat, 12 Sep 2026 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229914;
	bh=OxY7WUEjMHMDsNrFF2G2LwoaPRJzuMGReuN4Khpff3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cP40f6QUti4YjYWaRYLfWBFlGw1ilPjfHYNSdYz2DX+mzwETq9Ccqx5VnpmqKzmaI
	 IHAK5HgFpTvgepcy4dOO0Suc9ikVeafDbsdcDF6P/+SUMQiwIoV2oeMvyq+PYXXG8B
	 ZSaF137cT6X1PLiKHgcDlSQKFMy5A94x6NAkfD/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0685/1191] RDMA/restrack: Fix typos in the comments
Date: Sat, 12 Sep 2026 08:56:53 +0200
Message-ID: <20260912065603.645631291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3313410014cd5..a587b6e92d081 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -173,7 +173,7 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
 EXPORT_SYMBOL(rdma_restrack_new);
 
 /**
- * rdma_restrack_add() - add object to the reource tracking database
+ * rdma_restrack_add() - add object to the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_add(struct rdma_restrack_entry *res)
@@ -275,7 +275,7 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
 EXPORT_SYMBOL(rdma_restrack_put);
 
 /**
- * rdma_restrack_del() - delete object from the reource tracking database
+ * rdma_restrack_del() - delete object from the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_del(struct rdma_restrack_entry *res)
-- 
2.53.0



