Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046195;
	b=kYMCC/R3S0dGsglQ5PIrVAp9pMP+pkT2u5eSoJD1X4sduWLEluCYDfF0EDlcM1CBPNda
	 dx+o3EEmL1vp02Dm6lwWoVWUFT6unVq+rkWOEu4dqNb71JUNqmBKkKXJ7aJvW+845MQhP
	 WHnQnyZ4PDulNTERVy0S5zu5a761oeP4qLAi7rtLr1CMkuluP8ljjwIryLz02cv89OQ1n
	 92S+CpRJqDAulYdX50awpxtcIlzPXcp9gb9XDF24Zi4/vxEx1u6qZC6olwA/Jjtx0GgOQ
	 0welnhigD3lcCWaGQitSEDEdSrS56s894BSJqr/11fZLMCzJuV2X6tozX7MkP1Wr18Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hjhbuScHuOcOgkVtQWa/XaQI+YRj1S4vh9Ws7YKQZgA=;
	b=AwASRt7K/THLvY+p/IJ7WCAHnMO6OpFijvXjaBHMILzNTaHx9N6BiiVLgDTQVxOIvdr/
	 T3Mfs5NmYgTTclICm7KFmXW/CkbXYu8YIYS+kArWgJ/IQ/rPERji/UAheqmiH8fdd6uWd
	 GCGv8cPeTLmRetqz6+vNT5a9if0Hcl9mYAb2B2R0CKbMCg5bVwEyHn96yxP1bbfMutO8T
	 KJ4/N20Apt771HG9bi/vNYDzS94h8xKt9qeHzlacMvFW9DoUESgTZrjoiRqoAS300IPHB
	 759VtSnubRiPXvnz7Wk2jRjH160oecH5gXdvM6sDy2bhmvIbf1gt3IoZNOuFXUm54Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qz7m/qGm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B43606A320;
	Wed, 18 Nov 2026 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qz7m/qGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A006C1F000C4;
	Wed, 18 Nov 2026 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046195;
	bh=hjhbuScHuOcOgkVtQWa/XaQI+YRj1S4vh9Ws7YKQZgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz7m/qGm5bHj1tvyK1RO/IdVvI5zLx9z0EW5kqoxolQcoVWqjNEa+PBCK2mvQXsbK
	 5UGyZXmW3ngmW1F2NPxSHyoh64E9ZQSCEThqyDVXqQle/v3BobWifrebLy6AlFi4Y4
	 vavwpqHjH7nQPYIPmkCG29bTIu/JUGnCsR6EsZ6s=
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
Subject: [PATCH 6.1 1193/2857] 9p: fix caches_show() out-of-bounds write
Date: Wed, 18 Nov 2026 15:37:07 +0100
Message-ID: <20261118150244.566324855@linuxfoundation.org>
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
index 2a6988db807b3..c90470d1f8890 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/sysfs.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <net/9p/transport.h>
@@ -555,21 +556,14 @@ static ssize_t caches_show(struct kobject *kobj,
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



