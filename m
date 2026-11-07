Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062596;
	b=xf3263ybTfG8XBNg4pQJGUYtx18OER42N3gQdGiRyREFj7ARRe/oSkQtEgbTssjqf++t
	 4lFWPzoAhjFX4Kga0KKl35fO4Y6+Y1UOLBE2r5TCUlRZ1vc2bJU886bBQRzq5loVPtH+i
	 gauYRv/dvzpJPs7PKeOvtiTjwGMDddYD54vTETO748C1f2Jht7ir2hUpSaUzxo2W2m+/j
	 81cT8P7zo7iOTgaPbeqUptgOYwfUUk8sMNO4gNmpT28ecDzEEKjKCZp6xz2q5QXyviSI5
	 0Ufdu35/QvYTFIdPsHlyQuHbG7oJzC7QZgRiH2ginvlb6XkRyqYmjVNofvMFSwO0SZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5XxoP+oTwb31ZoTzW/QTAQ84FQ+weX7XTrNTjYOmqU=;
	b=KwXWU8NvvYEOkxL1Wpuizbby4fGVgpQnz7ZiPf7BuehwnUwR6UtX0JJB/A0d9x2onuSJ
	 D2E6dFgkFfgRhdQEeG+sqzdd4f02uU4zjrE845VZ1mPjfnmtyfuB/oCRQypGISJeb+zVH
	 SB56BIyOhQ91IQUuCnRkIv3f/zUMh8H1f3g3Z2gNCwOCVdh3McUWtb3v/OLtgBZOd9dNU
	 xOCgZtGFVWutZAO5mWxhYzww7npVC6/CaiTy3o0RUeFTjuMj6eR6ebOu/2Bpnyazl5RoA
	 m6Mtuf3VK6Fr5tEEJoBq1xjEbTL+yleyQhq+Su0hAuPJumbrLZ8g06MXIHWNH+YY+vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X31ix7tV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E9606A330;
	Sat,  7 Nov 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X31ix7tV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B34F1F0089F;
	Sat,  7 Nov 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062595;
	bh=e5XxoP+oTwb31ZoTzW/QTAQ84FQ+weX7XTrNTjYOmqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X31ix7tVy6cflE+B2ZvW+wZdG3495M2/G79mXbHR0Vd0WDx2Y7SV+cEuLCcO2hIwp
	 mIpd9Hk0zSTpzE3mMMvDKbjz3gF9TeVWt5VqhyfYO72qh4DuT+zJU92wyhqDKnbm1t
	 s4l6B2Q/Y3R78JT+d0ErAlVa5jLwEZ7dP/sNBl38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1471/1536] ceph: validate MDS reply fragtree split array length
Date: Sat,  7 Nov 2026 08:58:07 -0500
Message-ID: <20261107135039.161072779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 17c440926d752..69f716e162190 100644
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



