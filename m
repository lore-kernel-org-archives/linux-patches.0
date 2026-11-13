Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591274;
	b=iilumGAcftPZZncFVb9/ocjfjNqggKKhKNRY4xqUUVNnAAPybbPW77KvqLq9nXj70oMD
	 fwIypnB6J3w8lcM1GLFLg7FiNVfLVGLk4FdU/6ZnhUOj84qG5dcG2WyjO0LpitGXhVL3H
	 UH6QgPMrEHDE2KwRPCCXVoKVb6LqlMpYmT4XmdFa34gMtzvUXL/hnvZraVjD3CPAdkX87
	 Xwkxl1oYHIiyUmRi62J2P1BDSby6nMSN1sV9b5IeCHC2Klj3E2NnUPEENorZidp42LYpK
	 9hf0kp7peToHmsNzh1w/Y6+KzwSvwpqkuGAhvjO62xNSy3MuwPfVml81uaKswlz6wTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0gJG0cfSV6kNOnZzRaxUaeb0FvybnZ68Y9yiqfRXmIY=;
	b=La0E8PL55Upx5RrVoVGtZScyTyOTiOQsxzv88gLvSMh9RIaLHSp4FH5BVbXZhe1QZhS4
	 Aaz46/AfTLErSNHu4rV4L02JJVpHDt7bpI24gmN2+u8r7U6X2nuJnLK918W20e12CG5yS
	 s0Hny1TPg4U9vKAlwpo8YVW8Iv2oLvFS6aAgjPG7gHSap15NXSiYaGMiyROGGrGXgCrI9
	 hFcxqacdNLYx/G1eUNcgOmel41771lD+lnTG3iWqgyUizPjt253kUg9mwEN5rfdJnwole
	 0BoFnvcI6hBqE0GC4jrvTOEJIbX5Fk4wM8cDJsZQRALGLpaukSSZB67/kqvh1UmTJeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKkDRgfC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CBB6076FAE;
	Fri, 13 Nov 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKkDRgfC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B624B1F000C5;
	Fri, 13 Nov 2026 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591273;
	bh=0gJG0cfSV6kNOnZzRaxUaeb0FvybnZ68Y9yiqfRXmIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKkDRgfCw2mMTidEzTB5muDngBygvtyOrAhMC1QbxNWsKp8+lGCmlgbq/JqlS4yxN
	 K3UZ4BEbwCIOtcJR7wgdfozZcmYDYo5FTjTj3FYHU0PaJVoVqNzmNw1oige4Gaj3Q1
	 j0QnJpeGl+fk9wsaN4zmbEFb1x4zwtTlfci9/nvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 396/670] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Fri, 13 Nov 2026 10:49:20 -0500
Message-ID: <20261113153825.174903988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 6.12.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; the trees with pr_warn_ratelimited_client() keep the warning (7.3, 6.18, 6.12, 6.6) and the trees without it (6.1, 5.15, 5.10) drop it. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index aa551d94be1c6..63ead85dff268 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2173,6 +2173,12 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
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



