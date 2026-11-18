Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059747;
	b=f0A4fz6V1fxfUcd96cxjOBalVg9J9oewKQWPVnl8cZHj0frNQILdZ7ejZ1dIV58t5vI8
	 HgBk2rAWu7/fha9g8iG/VMlipA0P+hzFE9bljTorc6AMq1NquCuIqLEXTeXxutN30UUUh
	 Z3VKO9hPd4sUK8cb2gm1ReCvh8lXyGaTHx08f/GMeJCssBKJjxGUMatusZG+edLJ9ESv6
	 QiG6ERkPLI1WN5iXT7gD/uvYJdx03s9NVuD2KXwTh+eiHcdeI4eJVSC1DFl7sQJE76X2c
	 5luXjO9MwoyCkTMG5I5JpMimxsbrGlIi3iQd1LvVxKt0xutgscqXdDfgHoPHTGQ7FOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wPWOLptpG4Hh2I5738hPSj7nEoNrgnAnGpVfJqtOixM=;
	b=pC6Zg9tqJu0DBEAiAcGHROGYixUtTN8E5uk/n9HrOoyHMGBv0errA4y4AYZDVwODVu/O
	 ZRz0GiK/TipMrQ1eggYod81Ml14Lr8pcTYgWH3AmIXkWAV/PO5MQzPSNnUkBFgwFTWSYW
	 2ho5FbCzod+bAgaW5LsB/f3g93H/6Lcx6zPTPVmjbjY0efRZq0zlOEbkMSS5RLIgbXCRD
	 kF+KnO3Y1NgELF/VG/K+2ccIq4eQw07K+FOdNDz5JSLe6jSI4xS/FTg+/4CODPfyA0fuI
	 DEC07jtUSvHyDx2c9qEWmhEO/KRc471xtvMULO7Dnh67ECNdtHkYCgb749foIMsn2Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JClv4JL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D088606A32A;
	Thu, 19 Nov 2026 03:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JClv4JL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6A91F000C4;
	Thu, 19 Nov 2026 03:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059747;
	bh=wPWOLptpG4Hh2I5738hPSj7nEoNrgnAnGpVfJqtOixM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JClv4JL950F6oCiJa/Hffj3KO9bWxumalBYf2ICsFoPHp9VIvOe1t9409FZKLPsin
	 VNiBgHMEHm8Jn5CEvDvb5MPXNm/WAMsNq7wEHz4+0Hwb3n+6LBOpYqM2mAmqvGQ4B6
	 kJxPDRbZx+UbJNVQLWQGRL0TJQnLFF9GpbNIVKJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0952/1848] ceph: validate MDS reply fragtree split array length
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118145956.880420885@linuxfoundation.org>
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
[ sashal: Adjusted include placement to account for missing bitmap and mount ID mapping headers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 637f7aa82c0a2..50fc4856a5e0f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/bits.h>
 #include <linux/ktime.h>
+#include <linux/overflow.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -101,6 +102,7 @@ static int parse_reply_info_in(void **p, void *end,
 			       u64 features)
 {
 	int err = 0;
+	size_t splits_len;
 	u8 struct_v = 0;
 
 	if (features == (u64)-1) {
@@ -119,9 +121,11 @@ static int parse_reply_info_in(void **p, void *end,
 
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



