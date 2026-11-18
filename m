Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015124;
	b=Kky4ldMi8TJe3yKHZR4+nQSEtD1NFiECBW4DGZfuRi9lnt9Ia2lY2cEZYtu/vyBk0obI
	 ov5OkL3j9B9zwFSSSnNadKsaFWD+Z9Rn/wSgNAUSB3t2w8OzlMqDOhDqi1SpMFTsIYRfO
	 upmnrcvrq7Q4tnhwunwr/Ul65ay6eEuB7Ws6zhmXfYfpm25yBzHBkTmQMIercCwMyg8Ml
	 MhXThiA1EKgJez3jWC3xhe1ELynBSV6gyhKUJwAwzuqIORsZADuUOUG3h5IKSoPSLgb8t
	 5DUR6uNtRsJyl1eNlOxx4bLSvONDZ3iKfxuJY6VKaIiRFdWcaDYmKx7/yRZDAH7Yj6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LVQH+anXK/QU8jFSOT2hHatVHZ8qgr9joPemlM1PXMo=;
	b=dQ3r4oHgH6bvMjsN0NhIxE6uoVtuqyqyyOZWm8LaiFg1+9xTSg+3kdLBneoVS25MDTvT
	 PuLQVCYjflg6jUf/QWaryGwpJBGjjYNCNz2FNpHt74Uj783CvsB2LDUM4zVxGETVwvxVG
	 IeXaISlsvrUJtLJemBf0DI97t3LsVHr8mGAg/d+ahK8WTh5C5N/dM/Bm3tO4esDllwVUm
	 I/jbkk6CIIEzVhkh8L45TA791/R12rCqYDkQ+d7jk+DQbcQkO8LmIIXnl38bv5U5M3XBF
	 lpHXcOd33jhBQsaOIUEJuKQdl8Eoo8wneFp4foq+O341/sK+VwTnMp5F4Z/k+61yL5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxbjFVpv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922AA606A339;
	Wed, 18 Nov 2026 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxbjFVpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B925C1F000C6;
	Wed, 18 Nov 2026 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015124;
	bh=LVQH+anXK/QU8jFSOT2hHatVHZ8qgr9joPemlM1PXMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxbjFVpvdLKFDLDG5DkpXvAmB8+5stN+YQ3plMP9s5VPowJHLr2TafKohXXfR9I+Z
	 lAVzmayeO11QBkEf8fPjj6PqLN95wDbPqkZCl2/eAvY3soCZm5kzW6SBwKmlXr4Jf2
	 QN7ZYPvH0kJjbIhFub5FgXSjNOQLEDXZ5mb0yWKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0060/2651] accel/qaic: reject BO sizes that overflow page count
Date: Wed, 18 Nov 2026 15:21:40 +0100
Message-ID: <20261118150250.103873811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

[ Upstream commit 568d4cb5dcc5ec4e22975699b6ea67a30806884c ]

create_sgt() receives the BO size as a u64 but stores the number of
pages in an int. qaic_create_bo_ioctl() page-aligns the user-supplied
size without an upper bound, so DIV_ROUND_UP(size, PAGE_SIZE) can exceed
INT_MAX and truncate when assigned to nr_pages.

When the page count wraps to a small positive value (for example a BO
larger than 16 TiB on a 4 KiB page kernel), create_sgt() succeeds after
allocating only a handful of pages while the GEM object still records
the full size, so the request never fails with -ENOMEM. The temporary
pages array and the allocation loop both use the truncated count, so the
backing SG table ends up smaller than obj->size. Later slice operations
validate against obj->size and then clone ranges from this short sgt.

Compute the page count as a u64 and reject sizes that do not fit in
nr_pages before the narrowing conversion.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708031959.966009-1-alvinhuang0603@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index ef0351b6dc9b5..4d55531bf1c9e 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -15,6 +15,7 @@
 #include <linux/math64.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
+#include <linux/overflow.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -455,7 +456,12 @@ static int create_sgt(struct qaic_device *qdev, struct sg_table **sgt_out, u64 s
 	int order;
 
 	if (size) {
-		nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+		u64 nr_pages_u64 = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
+
+		if (overflows_type(nr_pages_u64, int))
+			return -E2BIG;
+
+		nr_pages = nr_pages_u64;
 		/*
 		 * calculate how much extra we are going to allocate, to remove
 		 * later
-- 
2.53.0



