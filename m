Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590277;
	b=J79w+eNnnC0ZhsPNDHBOcJm+SJwvOgCb1j14V4UwwVQIQFrCV2hw4Jdns5RUhaFiRS9b
	 /mnC9YhAyoWKlCwA2MuJsdAOXxNF4b3nN0LsXrUkWWNed2tSmtRanbAK/yMf9jzknvJn6
	 Eer/eil2/xRX92TZsQiYHmOjBiQ+xS20MIN4vxSvTtNJB1/OwmZFAuAhrYzIBb5kjfIX0
	 S6CJ6RxtPx+4VVSeZ6ARRBf768AQLNHDwg9ovmhc0qG70jZG12ljE8XZKybuM/MhNoMXS
	 LWUko1Na6L2z6R05xhHj7SGG8fE362nC8EBpfDq4WczjuEr7j6pDPvtOUeAhiamP5hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vzx3Ge9EkzZ84eDW4xagOA2b9ivTyi+wIB0Etqk3gcg=;
	b=WbiSoF9Dvwny5I3Nbz3CZHqqnynmrQ/xdGP5w7Ng4JaVijNwYEJ9h0VtyOtsEhjAmDzy
	 l/HVlamhnYP0Oic9elh5ugQgj/wb9UOdkNDuA08spqWKq8Z8m935EgL4jygqrfezjE4CP
	 IWPtPOWtWvhE3GzTMR+Ba7lYcNMH8Y9BkCw5LF6wWqECSw68BDVG0gtVgv8T5JuUKjROw
	 obRqhbt6fYhN8W4jloi2ZkWVF6HqWwJ9s0oQZT2yLjDU3rjEJMhJi0JW8zMd5ypYbLOpd
	 aPvZzyTZElMSMryN/UYEEYLXXuCsK6WHweFECNHnBly8NFcLP74Gq1eNup5Ix1Ut1Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ywqg/ydm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB02E60776DD;
	Fri, 13 Nov 2026 17:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ywqg/ydm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AE71F000C4;
	Fri, 13 Nov 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590277;
	bh=vzx3Ge9EkzZ84eDW4xagOA2b9ivTyi+wIB0Etqk3gcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ywqg/ydmkkIuPqVWP2DdhGs5kzHURdJXKnWfBb1wS61HZc6maKSAjRzoEQ47ukfYb
	 4Je5Fxb8jeFRhAh954b53FTkzUYoac7vdb3Kka5J3XO5Q4qLY7KCu/2MADaSRyGO3N
	 4ZHa4jae1NKiuZ+P/RnEryaJr2K3RTB9LYI5GULo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/686] vringh: bound top-level re-entry into indirect tables
Date: Fri, 13 Nov 2026 10:46:40 -0500
Message-ID: <20261113153830.066789942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 925858cc60964..c753a0cee240d 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -333,6 +333,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
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
@@ -358,17 +369,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
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



