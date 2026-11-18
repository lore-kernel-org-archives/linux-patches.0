Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028824;
	b=XpuaNo4tajbbHRhOmoKXA3i1GiMs02yfT0n20YVORqZ8eyrTGo3VkTzmaX9+K69zmDij
	 vEZSwo/K+slWb56Wv8stNfDUwMid8NjHE8mQyomfUGa44eUcCRznnwX1D+KMxDEvbKQVD
	 99pFsq85XtVtxfGffpBqAmQKL86M8gLz/y1XVGrY15wSM+z6iAqSXD86VOTbWTg2qTtwH
	 g6CsC/f3RfcxQVQVGvTZOL5yjCQcNUWIs8xwEWXQzU0p44gCmKISyaq8b5jQx0x29rj0a
	 HXQ6ZcsMN6GAiKVxv/SZuIenSkhEer0jihxuEfmCEL2Dj//d92eYwD8u/rPFrs3x1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdTKScHrsa2VNJPjc0tOmEZhNDt50gOEy0Ui9Cpif/c=;
	b=3JysxR+fAdPUY0rfHbvc4QQHTmQMs+erkgopodtoZ7m7jqd89qgMINK9sbPFxQIKEvCm
	 OEMf3T2h14HVfCNim989KWCjbZn7tycByLExKmcEfXLfHQ6KqmmfRi6+2RzvgzI0vOv/s
	 AVcA2dEC1UDrmXqTKecUkkfRKjdyG9c3mAkIK1nDu8p0i1KqG0DdPZ3R2EzguwR531pnl
	 y6eR/xwnIShLz2JIrFjWRBCK89/a6AsgHVXzY9SYkF/Ej9ugE/BO3xizcZm9QqcpgNpPr
	 ZufFeRtG28qwuJrpjtFqjyckOs8FKM+1/tn2o1FnJq/cDCdNHd9NSglmqaiK8hmmc5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvhRZ2+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2D1606A332;
	Wed, 18 Nov 2026 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvhRZ2+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A2E1F000C4;
	Wed, 18 Nov 2026 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028824;
	bh=NdTKScHrsa2VNJPjc0tOmEZhNDt50gOEy0Ui9Cpif/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvhRZ2+DfdxwN5jKMgQJJakhXy00PNebdXzgwqkKmD4OPuThEITcQ0hNvTCMyoKvA
	 bQ+E9HD1X9G0/dU3K00hrXBbU02QXffHTzOnoz3MOQqwaXCjmQpkzDMsyGOlNv+ZPN
	 9fJa65BFf32OHn7kKOXHLKuXEVRWuDcl2SQ6bSig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0132/1756] accel/qaic: reject BO sizes that overflow page count
Date: Wed, 18 Nov 2026 15:37:39 +0100
Message-ID: <20261118150013.442076115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aa89571b37f0e..f9c00302aff86 100644
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
@@ -454,7 +455,12 @@ static int create_sgt(struct qaic_device *qdev, struct sg_table **sgt_out, u64 s
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



