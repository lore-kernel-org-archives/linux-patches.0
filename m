Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B86303A35;
	Sat, 12 Sep 2026 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223679; cv=none; b=poK21Eo8ArldQpKGwsMQrVdEoigvhcC/DX1rwBW5h40ssILvteuxX2Kk7fVRHbwE+AcCX/y4PCIK3wpHcIeWUcPDWuoSFm+zlf1k39sWZCqvXYINp+i5JvkVhOAV8YM8tbgBPuLX4IrHie1lG9w6jhIID9S4eLE1rexVDD4pIlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223679; c=relaxed/simple;
	bh=vpKUNw8vexNRl7kbXKDLgm7b+h3k7qis1L9vqUgLaf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U04ejJyssIH+7winf3LuuF9xtUs2cut2IN+GusycjuP9v59UHY15pRTtnm059s8zk35/qfM7n3kcISK+nsNWkPQJeJ3bAkAeaJzVR1MJFelXw5W1H1PyPMs0Hist1VuCjdBHM+F/Xwo0qtaqE+UUf1ZrCDwaJicG3P9RwCMhkPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1epuCrAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1epuCrAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8F81F000FF;
	Sat, 12 Sep 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223677;
	bh=caagUmiNfagQWOeM/QpCoCBhzXzc6BtOK5SEm9hA6i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1epuCrAOVR8PhvB0Y/RYxtcPP91CKRu6UxbgzeEq40YSXc6IXyKYoF90YdtqdomMT
	 IfEOhvvBhJgnkHPcg+t2jvWuHwD3gIFMnojFhuKMi2R2eQNlhUf+0X2fNaO0AAV0nD
	 NVhHWtAiU5z62wo0mCiwmK139h2GzVWwaNy6IuCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0838/1424] RDMA/restrack: Fix typos in the comments
Date: Sat, 12 Sep 2026 08:54:30 +0200
Message-ID: <20260912065626.074773528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



