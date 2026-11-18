Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059038;
	b=APfCs4vJqxBQw0CbtqgovqinwC6hZBg4iWguc4uDY+VeEKq6s0C82M74+lwh5RVkSReS
	 ChQ+z4cGed1oQ0oN550kICC7BjIU3cRTiWKQnVcfCE8UxrMf1OkX5dSERa38N1LSE9hxG
	 xAMjVxO+bLlAqSZuckEmiQGdRGAe1wp0DCswa10jVhshhw9iJ8767wIHLqRluUrEMQcGU
	 D/Qk4KvkWQucZd6q5QgDj+R4NNHifOm5U2EeKZ7I/3BA6F1bq6cU16Lzuqv/bj6u+daK0
	 dTKNQPF/BVgkgSNz00pkC87RdBmge/3imv7V+tBpIal6iML/RvcAgnYKIKehYhs0IWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3268mFqbtu3F4CLd+9pomgiv7dbGyxUspIN5f1hV6Bw=;
	b=0V8aGXPmxXpQiLqj9zVMgZnDj5drFhRP5Twvs9dKtZFOuNnM5cg/RA3Db/zVSEAH6HVA
	 rPxQjBzMqRJuu9Gd7j6yBoO1kquheSBRKxmuVGbaMpilR8vT/I0vwUeejjH9ut8M3GW+N
	 E7kI7y+WeBp61bdbSxg72ETAq09XMWd5H02W9xLV0y69fucqjFFTTwQZx0Fsm6Wg4COSm
	 +1cV74zbZ2inmA7RjSqtg6Hn/1HZbCf6nJAk5ARa+mkYdgLJDV5N7W3TBp//Ul+/KoRo7
	 7/vdn+JEuVFUb9BEW3xenqd/qBVD6o8H1tIvk/oYqvhuQtg+7EZ+ZlhmD6f7IHd+DWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPwP0X2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2B606A320;
	Thu, 19 Nov 2026 03:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPwP0X2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A4F1F000C4;
	Thu, 19 Nov 2026 03:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059038;
	bh=3268mFqbtu3F4CLd+9pomgiv7dbGyxUspIN5f1hV6Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPwP0X2H4J4M6SvIWWB9eLJ9H/zxiX0T1lmT+16+pIQqwRRyQG3vdU/0u+Ycl+njr
	 lyAZz5lztecd4dJtJ0V+JtD8zZYZZoo0LjIgAsnjHup1qorB15ZceIM0cr+cR+D0+m
	 S4QUblOyq4HOE7luODSF9M9g2jXmKt3BZmzCeWgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	Fang Xieyan <fangxy@xiaopeng.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0698/1848] vringh: bound top-level re-entry into indirect tables
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118145945.100308845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 61fcef5a3b031..ba2c680b940a1 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -306,6 +306,17 @@ __vringh_iov(struct vringh *vrh, u16 i,
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
@@ -331,17 +342,6 @@ __vringh_iov(struct vringh *vrh, u16 i,
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



