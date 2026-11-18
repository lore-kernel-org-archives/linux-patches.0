Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054050;
	b=J+DbBFXg/er1dDy4RzuHJvpoGHCa9QoV6yB2eHS6pgX67oge3GtzVhOqK1rYw3KzLyfe
	 r7eSfNO0L4j/y2qICd1yf5wpALAxsjvCGtOBtrJftUzYt0jNdxRANISf5Dldk93qsOg4q
	 Z2bj8UBFXD9EVy60xJDSZ3nmX9sDBzK9NXDvV7FQQ6Iie09P8VqBF8xCNKOVfK4Hiatyi
	 YrRm7vScEvBXK52gxJ9eUwbpmprCEtKRfrynE90/e5toYAtUaqec0HCRSYrC9lURmejXl
	 JmGGKj3PC74hCUwFairKNVkm6rwS4l2fSMkYN+y0uNHeE1M83ydQss2+thX6U5A7EOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4kx/ntOvjSKq2CTM8wm31RinEhMReeVW2NKUBfoYWTQ=;
	b=i2rVQEVRxJifkbrCGqaw6QJrce5DDwUor0SFXQ5vrw7BynW9CN52W0N3McTk4z/sa9qE
	 dW7iVnmhMS6jC7OZTn6j+sauktqocOj2KCRhPZwaZkb92LPDqeUSG7Xf63kw7sGuIWtL3
	 HZ1RZasZT1RGv4bphhNk5XllWjNCs+8RRJbCv2jq+ha4Ix/9ioaqbpm4CkW+ZbMP5Owv4
	 SZMqMVsRISJhKN43Wjllj5IJOiw0EQY8QFxtC8AJQaO7kNo+RvyaoJ98Ep883GVflJKqL
	 cwh6N3Xzq9wbbUPJEr79nOfVYvm9onVwCcK0dvXBSSuSP3O+SOptx+i39/TNKbIBSzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8IT4ibm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765E1606A31C;
	Thu, 19 Nov 2026 02:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8IT4ibm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900F71F000C4;
	Thu, 19 Nov 2026 02:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054050;
	bh=4kx/ntOvjSKq2CTM8wm31RinEhMReeVW2NKUBfoYWTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8IT4ibmB9io/H7zG/s0Q3RifkazhFpfsj4FCEr3+bbYNyRrg6ndrA7pi35sWmgNq
	 nSqTuUjPIdrBZ/2xSu63armyMu0DFGEAapNmWuxogzuE8dVtY1ncJh2cuHYXwjq6op
	 CiuKtN1bfBkQdoB27LI5rMmQHfoQCzhCrWRj+BmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1137/2214] ceph: validate MDS reply fragtree split array length
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150057.522760647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 8cab7e7461f81ea1e0fd45082b50bb3c04c0bb10 ]

parse_reply_info_in() advances over the fragtree split array using an
unchecked count multiplication.  On a 32-bit client, nsplits=0x20000000
wraps the byte length to zero, so the reply is accepted and
ceph_fill_fragtree() sorts far beyond the message front.

Compute the split length with size_mul() and require the complete array to
remain in the inode record before advancing the cursor.

The malformed reply faulted in frag_tree_split_cmp() twice on the tested
i386 baseline.  It was rejected without a fault twice after this change,
while a normal reply and a one-split control remained functional.

Cc: stable@vger.kernel.org
Fixes: 2f2dc053404f ("ceph: MDS client")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: adjusted context for existing headers and the features-based parse_reply_info_in() signature ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5040a67a14f7..ba0de2b11d8ff 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -13,6 +13,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/overflow.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -102,6 +103,7 @@ static int parse_reply_info_in(void **p, void *end,
 			       u64 features)
 {
 	int err = 0;
+	size_t splits_len;
 	u8 struct_v = 0;
 
 	if (features == (u64)-1) {
@@ -120,9 +122,11 @@ static int parse_reply_info_in(void **p, void *end,
 
 	ceph_decode_need(p, end, sizeof(struct ceph_mds_reply_inode), bad);
 	info->in = *p;
-	*p += sizeof(struct ceph_mds_reply_inode) +
-		sizeof(*info->in->fragtree.splits) *
-		le32_to_cpu(info->in->fragtree.nsplits);
+	splits_len = size_mul(sizeof(*info->in->fragtree.splits),
+			      le32_to_cpu(info->in->fragtree.nsplits));
+	*p += sizeof(struct ceph_mds_reply_inode);
+	ceph_decode_need(p, end, splits_len, bad);
+	*p += splits_len;
 
 	ceph_decode_32_safe(p, end, info->symlink_len, bad);
 	ceph_decode_need(p, end, info->symlink_len, bad);
-- 
2.53.0



