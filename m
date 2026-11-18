Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053498;
	b=t44uxzF1lpSsHPmyiYPE/E6Y9hhCUhAk7fHz+PuOymJVaIuN37O2UAacj+hTZntQwFVB
	 JVG9E9PSdnAXtSUpwADKgAXJNADSMOP14n5TvUBbGFigcpe/u2IzLkGKD6rUn0VTknh3M
	 92eVsHpqVMRE8dXsOJXy9Dsc2xYbwXj9JFrOZQYdCiL6SwE15mRdpChA0HIuR88RxqzSW
	 vCN7Onyq0Mbcf+uF5EyJEqewbEEfr3YxDwI3f5vIXwNKlKhFOKoa1t7Hdy1mFZxSLyAof
	 g4EW0y8OExTn8qnLQohgn5Adwt8NZd0LFcLkA+LPSJD6OGm8LKAnozxODoITGVG9aWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5TgPiV1OjLtjmfP/2pp/yohNZB91aSPWNDl+v9iTnNY=;
	b=PgLRi8Bb3o+1INFX6c5kC5vsBKZyd3gQ3F6qlyYkY8YjirrBlPlEGhTLU7sXvR4Th1F3
	 /YWMsRX4Jq36+HBtrZGB01YMVa6j0TIruIA7Zf/3pc8hVLLn1fBxr1zBcCUVXRKTRF/Id
	 SzkYJvZAX4PIydsCOBuDBWPmRm1eB0BwgRtjMBpCcCMxU6GxSbxtWerQWlkt9w42y76tW
	 w8EXQqCFmo9Y5DscidDReoAN7KS6HvdOBq0vkaD+xPRpzNsK42QA8lK7ZMXMynRErgtjd
	 K6ObqiJjk70JkfYI0QLZ7N3BJfEPN1qlYvvFrffuEt9TqP+nDfazu0Svq5V2afFXKpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeR3Udow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB914606A32C;
	Thu, 19 Nov 2026 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeR3Udow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221251F000C4;
	Thu, 19 Nov 2026 01:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053498;
	bh=5TgPiV1OjLtjmfP/2pp/yohNZB91aSPWNDl+v9iTnNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeR3UdowRNmhtAP56Bu9qwLDl1/1cJDwXcl9GAAhVKj6OjlKX11pcS3DZ6orgYTD5
	 PHNJhoW/DOZ6GSUKXjOBNAJ9eL/GJKWPO0mFaibHTEA6XK6Ilem2BkNiyO+4vvDHP/
	 pzHZkkkRkChNSpYkfefL57SdOsfSasnX2oORG3k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0934/2214] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Wed, 18 Nov 2026 15:43:30 +0100
Message-ID: <20261118150049.730434723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 5.15.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; this tree has no pr_warn_ratelimited_client(), so the warning is dropped. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 618ef368b5649..0fb3fdfdc8685 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1572,6 +1572,9 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	dout("fill_inline_data %p %llx.%llx len %zu locked_page %p\n",
 	     inode, ceph_vinop(inode), len, locked_page);
 
+	if (len > PAGE_SIZE)
+		len = PAGE_SIZE;
+
 	if (len > 0) {
 		void *kaddr = kmap_atomic(page);
 		memcpy(kaddr, data, len);
-- 
2.53.0



