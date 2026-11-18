Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059210;
	b=BuBHkCjEOi8yKnvujGbYCdd3lsOkQDKOGSSdlUktCFDYL6CxEOBiE5oxV5KL02CCoO+e
	 JWWAA332uJ/DBZwiLzlUleWtljKSin02h/3gGgdXRlh9VFhpui2IJVgTCl8k4/QB6ig2m
	 A84zOf2FmrStHu7eoRkdOIxtiCg9eH9Jy+CFLBvNxqC19E5GXWsCYzqH8UIgqMvZC5tT5
	 193tqVoSRzHt3UL8p6wj/gM8pLbhKfMje3GZIUExK1vXdF9iVAD4stJw1kCHQ9hIjTh+A
	 WXjUYBikoOAymeiXaNg3Ym38wC0ukPCgo108bCD8fGApW8OA32OL2Ko5tsb9ghbJpqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7JxjdG6AOISXUy6dUfLpP0hqnWTL+AW8gwZP2dXGSAs=;
	b=w9f9G5OswHfEiZ51xJIZ/a2dMiGjTZcbFJcVQBI97nxoNXz+tHwa+OgN5IvDJ8YgWoXK
	 dywffD6lRr07nw355H3CPIruEw+EZ4+FBVpAob7T6gHcBobT3n8DRKQLf4PCVZJXXFeUu
	 pNRBHgLtdngpz9fLErAGkFRn32MpX1PiRV5eRtLzYRG/cQFsXs4O1rWabrq5G00zA9p2W
	 80kdbr1c28y11lgpsi9jItFGO3ggYLTFSFTVt50vjecqSaUSUxomUfsqIdEkjDGawdWj0
	 LLcdLytC8Tqu54QjF1wg/DBtc3W90nZ8gY3vie9kX49xrXjPFK70guyA5NLvViHtIJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN7625E9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C12606A325;
	Thu, 19 Nov 2026 03:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN7625E9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278E51F000C4;
	Thu, 19 Nov 2026 03:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059210;
	bh=7JxjdG6AOISXUy6dUfLpP0hqnWTL+AW8gwZP2dXGSAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qN7625E9Fqd0wBL4IEuaf9CAYEV9GSwoHcZljwzVS9gh5pLB8tLS9DzOK9vFncvpX
	 j+Y28sDzSNDFw+Ybnjk0LiEoO/Vp+McpN2LYAe8IiT/qVinrKoQEJeKYrn6iTMTgfK
	 kbi0S2KKN0dEetTIXCdwfWxC+sSxlzlYOU5BWMbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0762/1848] ceph: clamp the inline data length in ceph_fill_inline_data()
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118145948.345961656@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 5.10.y: folio_size()/memcpy_to_folio() → PAGE_SIZE and the page API; this tree has no pr_warn_ratelimited_client(), so the warning is dropped. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 4e247e65bd070..bb9f13aa892c5 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1717,6 +1717,9 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
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



