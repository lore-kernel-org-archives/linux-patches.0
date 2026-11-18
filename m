Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046309;
	b=VikGw0CzIPj3FFecmIw8Qy/RRV/xJneRFV4jSyayCPHHdkQUNHEz7gniex8n9vSfRTdT
	 PgoM+G+rQ5fPBD4yDKpzYZuSZsL8ilVWKVi2JV631DbpI+1dLVM0xfZAYGkkMviZmZnSK
	 KCJyprMiGrujbw3pAFbrLMhm7vBsJ/XAEfb39msA/+Fo3/GHFlWWd/V3t2S29VXukHcpK
	 giLAuF2PvHVtFSFlB94Mn9Hl10Do/S164Aaar2nSdBvHO5hZ8eaFlAtfygA9xoYNca6Pq
	 aX+gHXzM1xTTXte+pOuPo9+2f7f1keyqJjqib4QNpoa+iVgwR+TvcZl6wS21APB/IDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fqwqP/vZB1C3yDuk4UAZB0NxTj7kIFppmaZmDpPtabI=;
	b=v52cq5gSHY+QbBg8jDcWndF3xg50RHgOEa/xUa8sGYSWrIEcdVxl5VkboxE5WjJJWhbf
	 C0OKOX9T2zZnMnanpB9sozBHfFOgi7Sb/+0r6vXGOuqqJgCm1Ma+/u2iewkZvZzbl5yJH
	 ebd7hpuXwl+lugM5IM+oBLswrCnVjUFxpP7NBTbXVFOdvU9uydVa1h6AHASl3QgYXOcVI
	 THuOLLjwpc4OIXFr5wW87aSDI2yVb1K/MRBa3nTH+P7K8LOtKKdi7R/F78/JzRqPcRFoW
	 Kf/X1VAXn1c6ADAK7JFnmgR+wR9j3tFFsSE3D3IQYs8Pw6Gdu+ao8mwwDpzHkTtMm3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtB1VjzY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9454C606A31C;
	Wed, 18 Nov 2026 23:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtB1VjzY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA65F1F000C5;
	Wed, 18 Nov 2026 23:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046309;
	bh=fqwqP/vZB1C3yDuk4UAZB0NxTj7kIFppmaZmDpPtabI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtB1VjzYtGPuW8gnIOsx/OnWq9NLpC2BrQ5GdlC8jPUM3r2Vfnt14jiwFgYalelTt
	 zyMBznB2/4X6l10HgU2fcXUy7FQNeCzto5u5YXZLyvLFxIy+ribLhPa3WcCBPReuwY
	 +9bbiKQn1Pb5BaJRYLqASHOnQZOBLu+lHQDxiOkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1234/2857] vringh: bound top-level re-entry into indirect tables
Date: Wed, 18 Nov 2026 15:37:48 +0100
Message-ID: <20261118150245.990621156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xieyan <fangxy@xiaopeng.com>

[ Upstream commit f898439ace7f89922e853b43bcbfcd26ea2e0a98 ]

In __vringh_iov(), the F_INDIRECT branch descends into the indirect
table and continues before the descriptor accounting runs. A top-level
indirect descriptor is therefore never charged to count. If such a
descriptor sets NEXT to point back at itself, returning from the
indirect table resumes at the same top-level descriptor, which is again
not counted, so the walk never makes forward progress.

Because count stays flat and indirect_count is reset to 0 on every
return to the top-level table, neither bound in the loop check trips.
A guest can spin the vringh worker at 100% CPU inside __vringh_iov(),
an uninterruptible host DoS.

Move the descriptor accounting above the indirect switch so that a
top-level indirect descriptor is charged one top-level traversal step
before the walk descends into its table, bringing this re-entry under
the existing vrh->vring.num bound. Each top-level descriptor is still
charged at most one step and indirect_count still bounds a single
table, so legitimate chains (including the multiple-indirect case in
tools/virtio/vringh_test.c) stay within vring.num, while a cyclic
indirect descriptor is now rejected with -ELOOP.

Fixes: dbd29e075228 ("vringh: Fix loop descriptors check in the indirect cases")
Cc: Xie Yongji <xieyongji@bytedance.com>
Cc: stable@vger.kernel.org
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922122955.69433-2-fangxy@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index d89c2bce94cbf..4506f65396b02 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -334,6 +334,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		if (unlikely(err))
 			goto fail;
 
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
+			vringh_bad("Descriptor loop in %p", descs);
+			err = -ELOOP;
+			goto fail;
+		}
+
 		if (unlikely(desc.flags &
 			     cpu_to_vringh16(vrh, VRING_DESC_F_INDIRECT))) {
 			u64 a = vringh64_to_cpu(vrh, desc.addr);
@@ -359,17 +370,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (up_next == -1)
-			count++;
-		else
-			indirect_count++;
-
-		if (count > vrh->vring.num || indirect_count > desc_max) {
-			vringh_bad("Descriptor loop in %p", descs);
-			err = -ELOOP;
-			goto fail;
-		}
-
 		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_WRITE))
 			iov = wiov;
 		else {
-- 
2.53.0



