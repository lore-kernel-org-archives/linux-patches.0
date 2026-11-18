Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058967;
	b=Sjqzryj5CMZb+k6HazxYJShgYYl1TFDHpIMnBdhMT20Q5jSNw2twpF6fpURW0E6KOtj9
	 wnj/4RPOOceZxqe6YzD+zWDvJmVwbr7XrV9zhkKtlCuGKzhQzljRURkVHsPaeT5V6hnR+
	 qkQXKBmOhVtTcqc40I9iyfD7b1z9nZQcMbR0cy70Nr7Okh6/k0x9RMEJhbzhebr2X/ec3
	 9TGRBoOh2Wv3VXio0/ZwlZuGQ7I2M/31FjwpoxlGVnCmz4klzYgHMd5i34UhBMWptIA72
	 d4XhtsVR663V7GTCxQFnl5GOL4vSkOKoq5lSItqZEMpOwb9ZGJqoCCEzsDqvv5M9fgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0YPnO2SsxCfKpbgHuOdDR5rStzAoKGFrCRNY44bIWw=;
	b=T4NxOUmDZDBR9XC2vziLpkAOj2p9YnF/PA653MO5ZRMy/2FP+x3B7CWP/E50ATOIqw9U
	 3Ml2Xl11Cr0Jix8kEtOfB+CVg95lcmFy5rkn6fbPJhXb6kNr/7sZUzAu1AbK8MVoE3dhz
	 cXH6VALCDwwP/s1elAtPpq4ztNZPoJYrpKOA0SAXemQyuUcMjDehYjUvX1Px/GLDLnZOO
	 C2xp/cflGFibVC8uaESwg7iKlUlwvfezJhe/FF5Y2tKQomhzjtLhwNMDeI2ifdE0Zspp1
	 ViW9RVOX890EI/t68TgcH1dLeafn632L16V6cxnFC7A5Lo3gi6bER2HGIYbcI0Lsyzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pd2/N8JQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16088606A32A;
	Thu, 19 Nov 2026 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pd2/N8JQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE9E1F000C5;
	Thu, 19 Nov 2026 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058966;
	bh=J0YPnO2SsxCfKpbgHuOdDR5rStzAoKGFrCRNY44bIWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd2/N8JQkXEJ1mkPOVZ4L5IM+eMFsz8/0aMuI5PLyzOxTLVhLxKI0TwBfMbBO/NaD
	 WKzFb/4btUXpt0koNGHW+/Rhs1oeiRSaBrLv0lnv5sWOj0CEQOUVQGgGWaWZ2Ypfka
	 pWyJI7LYK7Fmi5NfRLZbxAR0B3yYlAog99C3iSyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0675/1848] 9p: fix caches_show() out-of-bounds write
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118145944.102630041@linuxfoundation.org>
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

From: Zhao Zhang <zzhan461@ucr.edu>

[ Upstream commit 2acd800de8827b7cdce8cb5c2c63b8e8608ec8e3 ]

The sysfs show handler for /sys/fs/9p/caches appends cache tags with
snprintf(buf + count, limit, ...) and then advances count and limit by
the return value. This is incorrect for truncation because snprintf()
returns the full would-have-been length, not the number of bytes stored.

Once the accumulated output exceeds PAGE_SIZE, count can advance past
the sysfs buffer and limit can become negative. A later iteration then
passes an out-of-bounds destination pointer and an oversized size_t
into snprintf(), leading to an out-of-bounds write.

Use sysfs_emit_at() for the append instead. It follows the sysfs buffer
contract and returns the number of bytes actually stored, so the offset
remains bounded even when the output is truncated.

Fixes: 86db0c32f16c ("9p: fix /sys/fs/9p/caches overwriting itself")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Co-authored-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Message-ID: <abfb65f4800634dafb08238bba20cb48797e796f.1781908090.git.zzhan461@ucr.edu>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 1dd8a735bf7f6..4364f58e47dc7 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/sysfs.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <net/9p/transport.h>
@@ -552,21 +553,14 @@ static ssize_t caches_show(struct kobject *kobj,
 			   struct kobj_attribute *attr,
 			   char *buf)
 {
-	ssize_t n = 0, count = 0, limit = PAGE_SIZE;
+	ssize_t count = 0;
 	struct v9fs_session_info *v9ses;
 
 	spin_lock(&v9fs_sessionlist_lock);
 	list_for_each_entry(v9ses, &v9fs_sessionlist, slist) {
-		if (v9ses->cachetag) {
-			n = snprintf(buf + count, limit, "%s\n", v9ses->cachetag);
-			if (n < 0) {
-				count = n;
-				break;
-			}
-
-			count += n;
-			limit -= n;
-		}
+		if (v9ses->cachetag)
+			count += sysfs_emit_at(buf, count, "%s\n",
+					       v9ses->cachetag);
 	}
 
 	spin_unlock(&v9fs_sessionlist_lock);
-- 
2.53.0



