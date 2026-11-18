Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038582;
	b=OwXQxEyh3ZGrk33twyDWIEljCIPP2kCnD33npfgvgA415D5dVUmh/oLlJf4PFiY7P1XK
	 HJmDv9yRNIv2BvFpqUMQ4dRCK7SuWd9+1jjvLxIKWoQfVJmHCzwpXJFbac2NzL7UMBEic
	 V17goUKuZxe18yapqgb1TQ0904Y/37ohZ+XCPJ4ip3hr5XGqrbEioTrFt3gZHpWetw7aR
	 0e2WZanT6o1zasxR4Ihz4elbZ2n1PEkQE4U8j8fIRZznD/gA8gBZ7PzCdqeWdnrAVpkOt
	 PFTCsvpyIoFzDuAApBbHRgSGrJW4tFdKF7gGfUgG81LDf15EjRyxoTWBhrVn6a2R50g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WdCnmmtOsa9IkQFWNdgS0g1SAnxilO2N46qQJzgbgmY=;
	b=brtRQbDJ/BU4+1W0EgwcdTX98/57P+G6jtMeW9SKVL2J313YjBRJ299wQKD6OYvggPZg
	 kL5BsIqEPQvAF3VEvBSFuWnO+9FkSupqzL+n1LiyOkLI/ud279itA02FTSNFfMRYORsQ4
	 BYuCCbYekBkixAlbIkekrIZT+pTt0ycEeto3SUMeLZ7wPpUnTSLN3CTkV0Ncs+Q/p87AO
	 0tLSZnFH7nA0FV9SEwpvLLbTTi5u8mqPR3mX5GwqQfhW0A4KQXC4qRPG4sliQDwri/4D8
	 Oy5W54X9988fhVboBvXJmve/ssaF+ZBylRXHp3puw+sqFII3r9oapWqr0rQmNjY30Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkYu1V1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6F606A320;
	Wed, 18 Nov 2026 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkYu1V1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A109D1F000C4;
	Wed, 18 Nov 2026 21:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038582;
	bh=WdCnmmtOsa9IkQFWNdgS0g1SAnxilO2N46qQJzgbgmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkYu1V1OMUi81y7S3QIRWQjhseFBEscMMs4jKhU3+1Auj5i/aIYIBrwSnOW3Y61ZA
	 mAskbPCaXLAwDeTk5ny48dEsmxbVRRSwK6o79emW/o2xgpLbSizzTRAztQPAT/yrZM
	 BS1fVBUwV+jfvdbVn+JjyA5WhvSUk7HffIgQcq3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1795/3318] ceph: validate MDS reply fragtree split array length
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118150415.706879537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted overflow.h include placement because the mnt_idmapping.h include is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 321acdcd29db0..331cb321cbc82 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -13,6 +13,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/overflow.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -103,6 +104,7 @@ static int parse_reply_info_in(void **p, void *end,
 			       u64 features)
 {
 	int err = 0;
+	size_t splits_len;
 	u8 struct_v = 0;
 
 	if (features == (u64)-1) {
@@ -121,9 +123,11 @@ static int parse_reply_info_in(void **p, void *end,
 
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



