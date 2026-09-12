Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAD238AC8A;
	Sat, 12 Sep 2026 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242696; cv=none; b=LZ7ScQEbxZDAldVzcarwhoy9iKb3F7lLK41Jj2rAT0r9PM4O583dLYmVDoDHoP6wqnUuM63q+OVlsYi89o8Fy6ZWw6Ao8CkNmBAyLtKIyoVXtS4WRH3eM4G1eufAAPtpfCYTAvrOfyU2r19sw9u/cJoBJchjepxg+J3vTxg+LeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242696; c=relaxed/simple;
	bh=H9Q7+UC8I0i7Tcdey0LbASXTKxzM6CBS0u9oCcgSkEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jELV3o80CFmMUK5zrZ1iD5GR5ac78WG14u1ATQeyNLvaPB6rcS9/dm6REsbf/b/4uHjs+phj51lVM1yxXL+EFkRXRdccwdiluHdE0AEesaO3TGBnECrO4jRV/QylyODuYFaeXujs+ff4DxG6iYq2PSqmCZ3HfGuZ7P8JF/7lXj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6/ir6H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6/ir6H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69681F000FF;
	Sat, 12 Sep 2026 19:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242694;
	bh=5KT4zizuW8y6d5dqPzZCxGjHtI7/JCJ2+x7v8H8G758=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6/ir6H9mmQ8Cve2YO9PjV428s9s7d6EZtp0jhSVXmkMflN5J5+60g2z+7LLQg3bZ
	 IAiwnyJT5J7znaOZkKf9EIiEbb1NGAkFaeXCMPfgCXdnsch27IiONyZHRepqEpGS4e
	 q7+0z9GzvZic2X6nqhUPtGVKjd5yUsJlXLG59C5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/798] RDMA/restrack: Fix typos in the comments
Date: Sat, 12 Sep 2026 09:02:02 +0200
Message-ID: <20260912065528.461320941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit d43358cda7c4696e08880aaa58a7df82e471fa7c ]

Fix couple of occurrences of the misspelled word "reource"
in the comments with the correct spelling "resource".

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20251113105457.879903-1-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 3481bec4dfc4 ("RDMA/core: Fix potential use after free in ib_destroy_cq_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index bbbbec5b15939..134074ea0582b 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -214,7 +214,7 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
 EXPORT_SYMBOL(rdma_restrack_new);
 
 /**
- * rdma_restrack_add() - add object to the reource tracking database
+ * rdma_restrack_add() - add object to the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_add(struct rdma_restrack_entry *res)
@@ -302,7 +302,7 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
 EXPORT_SYMBOL(rdma_restrack_put);
 
 /**
- * rdma_restrack_del() - delete object from the reource tracking database
+ * rdma_restrack_del() - delete object from the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_del(struct rdma_restrack_entry *res)
-- 
2.53.0



