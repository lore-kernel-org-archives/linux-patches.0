Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047164;
	b=PAfLNeIF+TulirJpYSXlkant6nA62fzRgXOqWtoTPCJJtSRvPF1grtC1Sz310fIKfxe5
	 +cmKepb9zUbRt4Gi+Ex47QhRswT4nitPH0hxI0whAYw7ZByqKIQ7a3ZiWe9ab+iuwJS0M
	 VP/s3siL7+ZHQ9gxaCQynGZFnaqob2cxNgurxhpLqqZDXBiuyvgBvkFmjIU2FDUiN2mU1
	 LbFn6UNI86tHNglldvw+eca146RseK17pSxA2M4bA0xe0H9WVn+HaqGtKZ2cpHJVV4ZXX
	 6k67lnSRtgR9xhKP85TDtukuCGKRVjMPS31LFXZqsBwlpPraP6p0ylSUI1waNCNvtMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zPMqDb+4w8Zu7sl2tDXtmRUNHEqv1011d+wl8U3Q5uo=;
	b=24Z52pxZ7QSPLx06jJDrnv3AQ5Vw8wkfo2RD+6VBU7Bh9CpNRLPjpIu2IEUoV/ntMKvR
	 QVmUqoFp7cPTahYi6liR9qWhHQgyox1pyWIJFlj3WtFOwAedB7yNJhzxzJhQV9fsM6aUD
	 eChfMLorCwkvE78OoPmwukJquzwX4XvFd6tvGAFY/IR83bNsfNNJbEpV9y1dusXIRP/Ku
	 Eqfh22mkDRz09TA75ru88TAY7cE0l7UQza4+TIIDckniriuh6oFywVhaIVLczblPlYnN1
	 4IwRRaCy3MRCp46RdUPT58IMPsP/G3I2k87FCjaZBPz7KFAnvmMBWHaN4rXDZEzZZ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AK2MW7+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B7606A32A;
	Thu, 19 Nov 2026 00:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AK2MW7+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3051F000C4;
	Thu, 19 Nov 2026 00:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047164;
	bh=zPMqDb+4w8Zu7sl2tDXtmRUNHEqv1011d+wl8U3Q5uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AK2MW7+4J9YPHCquXipF/UgcSTBvwua8p/NlVQTHw8Hhyhkh8YMYzI+KDW22UgcnM
	 HmxKhCf1fxOUQiJshrNrKzLTOP8m+8TfEHWc8usOIuyOITLruvLQXKbq4k6nun5mFO
	 d/IeBl7RbQCMRf9YNNBVUygLttDWCvK/IKsaZmVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1540/2857] ceph: validate MDS reply fragtree split array length
Date: Wed, 18 Nov 2026 15:42:54 +0100
Message-ID: <20261118150256.771542561@linuxfoundation.org>
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
[ sashal: adjusted context to match existing includes and the features-based parse_reply_info_in() implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 099b68d6d66d4..6cffe6ac17915 100644
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



