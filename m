Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590521;
	b=uFJWYbVeNvjdeMR2GlvZN/3e2fsN/iKXMVckIZj3r5a+3i3SwOFgZNXz182NRIYgSk/x
	 wXEyBrQ3DRdNw8BhpkGiaV2FjdRWI74XE5OMUEPIAHkehlw1MDWPRQDSUBFzP+wDSGM/u
	 pkRFVIIogZ0rZ3LwKVJ1nHwIsGb1S/DqnOJQt+5WzCWAP7fxSC82tWagysa3nwoOIihlw
	 +mqs4XMxpFcN0SQwXIzAETiuSA+llQULqkPRhAFO8HOfbI+s6P403brIEEvGCSrDgDm0P
	 pHWqwXfOl9faf7EKyohdfgbFsE5cJ4J6kNia7uGJIfplRFbPhDZR2KlKfZgHaYlY8Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4qYmt7XVq0H+q7uF76jQz8AtDkoyn1lDGaDzsesx6us=;
	b=TuZYIHWTVgy8lURYmoUK2KAVRzjajQAbAK2IMU9y8agGWFDQEruZA6nRHDqYfKRnoqwq
	 gIyjbJHVwe+ZPosMNWhWdUIewfNOQoYI0kV1QC6tEa9IrKL4BrNKkYQPeedV1f9zehg0z
	 mghayzXGFikWo6anUZ3NDLlZn4PVZqiuPqjoh9VJ+woQ/Wxp6l0RnKI0UkL18BW7sfl+T
	 Dp3PQK4ssl5tWl/9IUQFRT7f5giFDVR3Sis/OgfICHSKNrMbgT7MGISGHRYbmRa5YOpfW
	 h+i9v9RqYxIuWD/3cJRKPNaoUJGQXYlvGG6Kx2PBK27w7ckNnqCifQaBJuXS9vNN9AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoLQJI7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6E4607322D;
	Fri, 13 Nov 2026 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoLQJI7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084FA1F000C4;
	Fri, 13 Nov 2026 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590521;
	bh=4qYmt7XVq0H+q7uF76jQz8AtDkoyn1lDGaDzsesx6us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoLQJI7ac6t2IPloev0rQkWsNbFvHtcnToJ3vIA6lWRxpxmjNfWTTXDgmYqdft/FL
	 6BK3jP9Vv3pWMfnjQNCXerfcbZcK4N4eeGHm2dkHMAV0MuNcFPyeAhNJqom3vWbpaK
	 rVNb3IrI4Pb47Rcvh03Vdgqi8iLD3dW3J9Ym9Uww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 466/686] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Fri, 13 Nov 2026 10:49:59 -0500
Message-ID: <20261113153836.673179714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

[ Upstream commit 9c1d14d3b66b3e1dd96ee664c0dd2548f2b77a52 ]

The MDS decides how much inline data to attach to a reply, and the
client parses inline_len without any upper bound: ceph_decode_need()
only verifies that the message actually carries that many bytes.
ceph_fill_inline_data() then copies the data into a single page
with no length check, so a malicious or buggy MDS returning more
inline data than the page can hold writes past its end.

Clamp the length to PAGE_SIZE so both callers, handle_cap_grant()
and fill_inode(), are covered.

Cc: stable@vger.kernel.org
Fixes: 31c542a199d7 ("ceph: add inline data to pagecache")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ Adapted for 6.18.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; the trees with pr_warn_ratelimited_client() keep the warning (7.3, 6.18, 6.12, 6.6) and the trees without it (6.1, 5.15, 5.10) drop it. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 51aeae341f56d..6f6c8d9214362 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2214,6 +2214,12 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	doutc(cl, "%p %llx.%llx len %zu locked_page %p\n", inode,
 	      ceph_vinop(inode), len, locked_page);
 
+	if (len > PAGE_SIZE) {
+		pr_warn_ratelimited_client(cl, "oversized inline data %zu\n",
+						   len);
+		len = PAGE_SIZE;
+	}
+
 	if (len > 0) {
 		void *kaddr = kmap_atomic(page);
 		memcpy(kaddr, data, len);
-- 
2.53.0



