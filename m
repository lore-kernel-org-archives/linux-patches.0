Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063674;
	b=GynNlJsjvBNKWv1N/EhUdaY7AQtS4kKFm5FdsNjxFK3OOCeS0zvx5BXZwcoPZCM7pn28
	 9Iqfgvj9BPEuAIsDdRUtmwiIOxlKzRY68GZ5Y9qQvLhoulz+lO4jWGbXgobHUTwZQ/JzZ
	 he97Rc2ghSvb6uxlePDA368PUQ7Os2vjDbffYXjMAmSlXnOwaqC8Bp7TO/YRSUoEHmO5D
	 5cbxjvBXDfltM5FS5RV3/s6uvkGt5uNjiXou+nkCcCeEN9+YbXen8gsD6uLG64cnDRY5g
	 fiPfSEyqRqjO5eTrmQVATaDUD3/igN045bRHMdUBfcdo3ydY1n+aAbPe8XMHT0W06yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8QE4xAYuvkZKP05Q5vigzVavXjeDu72S9em/Y4xgA4=;
	b=KIBAyvrmvvDt55KMOUfiilHttrcZ/vxgVA5WESRntDW5Xg9gc7drHZrkqOezxQtVBR4Z
	 n2x0n4tqJEoCmx0YQDOPv0MwlSSMtU9Mnmds6a2DMQFgwifO4M+IcbIkn4/Y6tBtDJ9bE
	 oIPFXFX/AsMvunV7/lwdg8Y5PQ2MQq2+yUCoG4tX8sYhQIvC/Tj/EQtDmksV/nBuPZwI0
	 ciW0efWUtq7BZ7eZc2T0XgFDIuFu/fgWVXtIhSP6oR8jseTPf0OrTUvbziv8Lg7WfUqvH
	 +8jeKk843mszJ8JNNBPYCKARn8d5aAneSZMq8G54VWq7Fw5GNisudQG048sKVbIgDcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MWL4Y+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C41606A9EF;
	Sat,  7 Nov 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MWL4Y+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77D81F0089F;
	Sat,  7 Nov 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063673;
	bh=h8QE4xAYuvkZKP05Q5vigzVavXjeDu72S9em/Y4xgA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MWL4Y+3iVB+IomiviD6KnUn9ue5eXLq4Rg4WbOwwgoljxbVHksiaomd5bRY9JD0R
	 q/yfw+7ay9NlGoDg6YxKhRm8vt36KcqdSQIqP1VjRrg8a5H+arlmidT9iPGwu648CO
	 5VGGm5kjttPG7eAsKyd8wVvHy9b/Bt+G2myu732Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 784/869] ceph: validate MDS reply fragtree split array length
Date: Sat,  7 Nov 2026 08:57:46 -0500
Message-ID: <20261107134919.275789214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e1a0f77acc1ad..0220daac0fba7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -14,6 +14,7 @@
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/overflow.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -104,6 +105,7 @@ static int parse_reply_info_in(void **p, void *end,
 			       u64 features)
 {
 	int err = 0;
+	size_t splits_len;
 	u8 struct_v = 0;
 
 	if (features == (u64)-1) {
@@ -122,9 +124,11 @@ static int parse_reply_info_in(void **p, void *end,
 
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



