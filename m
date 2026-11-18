Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018084;
	b=vpuVsVHrcOoEVEHUsMqs+YVO8j/QSs/4/myg2gMdIxOmTH1aXrMn+/4/hPPr5IaSBnS9
	 cFKhywkrUbMeRyK5P8zXj5ATOBkIpQMinltVtbG+dTtgVN8Ge106k800JRtSck8bF/S2E
	 G5wZPtPgzgnAWpux8o3E6npODmkMLlaHqktljvC8YzlnrghoMhiptVa4kU/+ko+4L5Bqy
	 HfEn6KyEWCPJ/dqAMaUG8EqxnZbmqqfxKRyQ/bLuCTMbbukTr+5a2Y7N924PKMc7dvfVt
	 leX6O1mCNkRYVjOTTePYGpYJ6VvFHBTSarJtws14zEa2kfzpa/chtqWvxcA92FS2xLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kLl03IhAAkrilIdBhZMHF3m53WdDa3JOwr3wmoa/IBQ=;
	b=DD+CoRcdZ4aIVdE53opPCY3Zll1PMG97ehgT6/V/+52HrG5EH89M0S/mDiu/AJ0CA4nq
	 pPOD/4fDsCjltH1sCxP2n/oLY5wmmZgiympYVPkat4ApyGNJur1V5WlP+9/sXhKrRjx18
	 +rdb+fEabP6ujMz96DxlCmE/hrRr1VTkVHxZe2nVLFpND7i0sw+dSd5htdiyOmwha8Vup
	 DZmruunQLcz5vcOOu3yoOYud5LmrivdcwYdaI1+60HRXQoR1M7i5FsHasxvZcvqqPsAmC
	 KeGhb6GV03n+a+V2GwUk/T4JSU8khUu+e6KI1vk5m0YPY8UdNaoCfuuLO4IflD7TxUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdQxJ1RI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E5F606A337;
	Wed, 18 Nov 2026 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdQxJ1RI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8955C1F000C5;
	Wed, 18 Nov 2026 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018084;
	bh=kLl03IhAAkrilIdBhZMHF3m53WdDa3JOwr3wmoa/IBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdQxJ1RI9txK2gbXB95NbVSNlhdf1N3PIPea54NQUhcSEzQoxkEbkkAw9LFXlhLjS
	 1enfNQsci7tqQb9Jvjvf5yZPRbSpV9LJfeag1pHnZldDGRzTw4jR4VQWbe0Y2ahVTL
	 Tqlr/zZMgKSXJdV49LAQiikJEO12Z6AdCtcOQnC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1090/2651] drm/vc4: Use drm_timeout_rel_to_jiffies()
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118150327.240342394@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 88b7a9fb64afd206b3aad92a96425d2b562774d4 ]

vc4_wait_bo_ioctl() converts its timeout with usecs_to_jiffies(), which
takes an unsigned int. The microsecond value derived from the u64
timeout_ns is narrowed to fit, so any timeout above UINT_MAX microseconds,
around ~71 minutes, wraps into a much shorter one. Unlike the equivalent
problem in the other drivers, this one is not limited to 32-bit.

Use the shared helper, which takes the duration in ns and clamps the
result to MAX_JIFFY_OFFSET.

Fixes: 21bd85f82ec2 ("drm/vc4: Use DMA Resv to implement VC4 wait BO IOCTL")
Acked-by: Christian König <christian.koenig@amd.com>
Link: https://patch.msgid.link/20260915-drm-timeout-helpers-v3-6-f2ae987d861f@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 0fef9b48d3c68..e76f686bb3748 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -32,6 +32,7 @@
 #include <drm/drm_exec.h>
 #include <drm/drm_print.h>
 #include <drm/drm_syncobj.h>
+#include <drm/drm_timeout.h>
 
 #include "vc4_drv.h"
 #include "vc4_regs.h"
@@ -984,7 +985,7 @@ vc4_wait_bo_ioctl(struct drm_device *dev, void *data,
 	int ret;
 	struct drm_vc4_wait_bo *args = data;
 	unsigned long timeout_jiffies =
-		usecs_to_jiffies(div_u64(args->timeout_ns, 1000));
+		drm_timeout_rel_to_jiffies(args->timeout_ns);
 	ktime_t start = ktime_get();
 	u64 delta_ns;
 
-- 
2.53.0



