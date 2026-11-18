Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037934;
	b=qAE2EIIsJoswDWQy/Bib8OEXSLA0+bs0S2og4vv6oOu6fKr6rqU+a6LK/2f7VKHd+6xG
	 gI+tnIccgdgVweRWX/okPJO58ywLaWIYMANuNNHhRYZjINxQ/uq9WksY7q/qNj4nJYr37
	 PtN9tm4OIDOC7wm7mmh6osYH88mCI43CdwK3P2CU+ow2/jPu7pZTM7wXt858YMAhhgr7m
	 KoUahqUZ6cI8ZPFUb8J0YEGX/nKD8MVBJz+t/uCi0ZQaajbPbGZNuWPrvrsxsDAmJhTDF
	 lb8nuIFZoti2NP9yksYIBMZC/3Vvia2cTch3ZeAms9UiruIGriqh8lK24F5/K/6JVtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MHgHZ3IVr+KXJKdRP6ogyezQrOGPrmLEuT6SBtYjI4c=;
	b=i7IPDAIO/UhoNaj4TFeLSKb297haK3mmH1mHb4SToKa/CcWUXB6JhmGRqWjgNHvdNNUD
	 /GNGUv1GW3VsAIe+25U0QL0Jqou48fPv5r3D7GmuGaRz+zaNYDhYwLM1NUI6QgAlnxZ5m
	 UwGdAaAWbqB423W8yIcxHxV7bTpqDOllsifqotbHQDYHsXuLZmNQ9vPgK5IHA9XMu2suB
	 Iah9uFqsy+U24nLN+QFHeoKMQyCeX2Mz5lDzlC9sFx1LO7ZoOtQa4odEb8ZsMao2c63th
	 9zbWdtk2gVABHDclaBKBWigp2G+Pa2we7jG+rFkW0C5XlwKLpUTHhswOkMnufvp3C2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e24TwAPg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B2606A31C;
	Wed, 18 Nov 2026 21:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e24TwAPg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4F11F000C4;
	Wed, 18 Nov 2026 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037934;
	bh=MHgHZ3IVr+KXJKdRP6ogyezQrOGPrmLEuT6SBtYjI4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e24TwAPgL1FxzRNZ3j3mg5dheNyr75LZK0lzOvKwN7pcdLcC13XjIBKZLnyma8n8K
	 M756JYjlFnNnqdAPAGVSEmQRryeGnDf3zZzdan2GwdaSaFaL/n4g0MDifBBxe3kLij
	 4e4zg1ixSoRBDneTw9bAcQ9IaAww2jmPq4/ssBJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1570/3318] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Wed, 18 Nov 2026 15:36:32 +0100
Message-ID: <20261118150408.217652146@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 6.6.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; the trees with pr_warn_ratelimited_client() keep the warning (7.3, 6.18, 6.12, 6.6) and the trees without it (6.1, 5.15, 5.10) drop it. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63eb50f94e6ec..b48ea3bce962a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1822,6 +1822,12 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
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



