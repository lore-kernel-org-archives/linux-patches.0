Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585860;
	b=efOaI+F+x47w8KsAHmopCsxSpH+rCbTJYdgEH+3+00g2SpUzL5bqaLlM4miOjPLGzKm1
	 5d3yiY+yN71Lb99qmmv0WdbRZEcP1KfZ9PsCqfmiZ35Rt0+t4ExvGcRiD+ryVKgFA9Pq3
	 2zorpMmOb1Ge4LOdXfdXfSzZd0UmBxt3OC6G2miT3T2Q+50vBxMZX3rejBkSUES7evoEd
	 /YStGGKveeOWSGL/ZtoFeXfdMnBiyH4arL3+C6gc31TTnlsfm0X66AMiNNLXZibU4Mo6A
	 VHq0i9tQEWtkemFBNr199CkcnE4BzhKrYAIuTohsOdnwXI0rpgGr78kDwmPNzVlZGPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mtlrMXVi3qqX2v47RN29zvSjS6ZzGqZhlv5AwL6GN+8=;
	b=uOBCvCnw6rUmJhLVpsnEps5WA3nsd490L7fJbNOKG7ncwb1/KS+fnAMqDM3rCOikO9mA
	 /s5qfEkoTQNsGzhnC9+PUW9yzyC6IUh517l1gzSKDc/7KF13iN+/OLYYhT96HCnSo13o0
	 9eq5XeTbqiGU2IhlnwRlQ2iOcKeWXFqzxysv9aMi9O23MLc2Maarlw1r+a+TUbfS7ujTh
	 pJSz/ARZxCmWIWkb9iGoDhpH02/m6IxXfKwWdJ1n1PmBExy5gRWGaE0JZoCJvsiWB4iEp
	 CxxxbSCl4OkZ0GSlBlVtnUSNyUYTnonmn8kzBFWfAxqFAiy8G5ab/NO3qFUQ8VoSmSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AW8l4wPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25095606BAB8;
	Fri, 13 Nov 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AW8l4wPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C3D1F000C5;
	Fri, 13 Nov 2026 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585860;
	bh=mtlrMXVi3qqX2v47RN29zvSjS6ZzGqZhlv5AwL6GN+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AW8l4wPm42puHC2xjPz88qP4m0VZDIMEElEEfo8428K2sAjaNrNXBhwWTX1RmzC29
	 qnbt/6ebn9g0e3oqXIXPZ2RubVZcUntS+Cr3bLrxzN6Xzgz3kSD9jt9stEUDVa2bO4
	 njQ9OPOUUMtxiodkscChoNv9fyscj/Zrh8U6y7uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 434/507] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Fri, 13 Nov 2026 10:52:18 -0500
Message-ID: <20261113153811.451323868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 7.3.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; the trees with pr_warn_ratelimited_client() keep the warning (7.3, 6.18, 6.12, 6.6) and the trees without it (6.1, 5.15, 5.10) drop it. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e07a7b1d3663c..f32a533f41009 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2220,6 +2220,12 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
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



