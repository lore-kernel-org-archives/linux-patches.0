Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065420;
	b=rEnZFhZZEpMBv/R0ekCiRWsrK8vyy+q8ThgG2MfaGAxwzG6dQv2AB9kfNJoDYtvQ6tVp
	 j0bDECvApAWFh/7KxgRm7ioVwTSFdGBdao7JocOUPIhA4AEDWL8CKRuomQjqn+2yEb8CJ
	 k3211M78PjcbZzShOVApYGqqRHqbh3nOSpQhkm7ZxNISMYqC6YSci3RbufdDn4OEUdicp
	 PBhgerSKRQDd58DG4ziAMvlt/VRNWRujXl9E9Qf8fkFbDSUIydNSS9IndmX0TTnH/xtV4
	 Iwrf+0ZAQztvbOJbkJNLS9Eg7LI0OhXXn2wI7sXeuEzi9c9e8yhjYLCvKqUiYWQ3qHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jmxJYTNzvliaDzQeko/LCqp6qE5xlJEarxgpRdLhbrA=;
	b=p6UhazXQh6anpTzxzaqiSW0VRHRDZGiVoaAu8Yn0lNgSOabxywCyT9fAGOQTDpYiy3ny
	 hAhApC7m6PdizsZa9nuLwxHddB4kYyEs5U0snYWqFC7TuQ8w506qS1ChDAOtM4JiXoopm
	 awg5uL89lQjm2VpUPZ3syYHCozFTOhuuM9DbM9nDFfJHyejO/DmLUOomV1H3/aGJuzUES
	 xcp9kQVLunmuSUyYlQwy1vS9lXWzJ/s/T/6WM4VP4YzdD+3DP+QGTK6ukaMR3wJh3hog1
	 qvpMkY1oxXhneHyv2rk69IulBIyobnGr56tgKuzhfyh0Vbm/T4jSOHZioglHGTSaElg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCXE8Ex8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0198606A32C;
	Sat,  7 Nov 2026 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LCXE8Ex8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A96F1F0089F;
	Sat,  7 Nov 2026 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065419;
	bh=jmxJYTNzvliaDzQeko/LCqp6qE5xlJEarxgpRdLhbrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCXE8Ex8/LX9utKOZLiUmipN2JGJLUqA1RDuXZKUj9TkK/H7Leo2CFQD4uTRoDCv3
	 /vg9D+jvWnXK1zCkZBJcHNKSON5Wt8kad30RQqv09oHEz1weU2BNsPoFwKbLYorxQl
	 p2vfsnpF5xC+Ah6Bd6xjK4Fz/n0nUW9xz7Yc6miU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1134/1257] ceph: validate MDS reply fragtree split array length
Date: Sat,  7 Nov 2026 08:57:10 -0500
Message-ID: <20261107135010.548700473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index b354c3296de36..1806cdc202718 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -15,6 +15,7 @@
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/overflow.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -120,6 +121,7 @@ static int parse_reply_info_in(void **p, void *end,
 			       struct ceph_mds_client *mdsc)
 {
 	int err = 0;
+	size_t splits_len;
 	u8 struct_v = 0;
 	u8 struct_compat = 0;
 	u32 struct_len = 0;
@@ -140,9 +142,11 @@ static int parse_reply_info_in(void **p, void *end,
 
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



