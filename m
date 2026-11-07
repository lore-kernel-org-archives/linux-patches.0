Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064921;
	b=I4fVxTww/B4Vvtro5GfNsFGLFu/LVeF7wTEnvgIG33L2BWTSN6Cf+LvycMehGj/pY0mT
	 DcAcluT4z5gqVR2hJ7/R9nOmx+XpxrraCz8x8ojZyipMylOC5LUvTlsnUnyVRs5SS0i0V
	 2/fEWjcPUkYGftHYcZ52qFuHCf4Jl7yRyNCVfYWTcAUCpck+xkk/+HNJl6uVwcSB6r+wP
	 37GwtHdb/IA+ixyq9viXp2Jt9/51rBLUS8UV+f7HTkvAQ+t6NVwSAhWlJBb8UfcYlJu0q
	 +iG4y7Py8pErp4AiQkYFdHDyOIuSDOj2c5z/KmPnGSLR/Hryss1RqEFvLUpJVVp0Shg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2YbCtpvdtXoZ7RTjN5MahljVO6p6M8od2TY62KlNm0=;
	b=gV6ueVfgq2p8unmhzpIBG4fxt4Njp0eKwysA92HZuRl+noqtkkO8gYZhsL6ci3W0CJFx
	 gwJ6h2PE7oKCii0jC0f+AgVpFcjBeoiBF3dp3JL6yq7zt03lMUeLi2r4gEGKyvQTzA+9F
	 neD0vdKFzPxxBqOeXnWZxoxZknudf2H5RtEDi7UZnQrAVt+ig7HC6vtoyKGMY4Yhhfiax
	 Ns7oy96ivLPS7SehRJPaVEqoOJBnJEEWlw78Mm3OVnPtKZj1HLV2iveVS4w08klFqGguw
	 44+tQ/frGCX3sVG6znAUYHVZAwvSpzch9Aon9XF4HeZCkS/W6Si/1f/klvGPJKrhMWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H5c5n/KR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13262606A33E;
	Sat,  7 Nov 2026 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5c5n/KR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9215A1F0089F;
	Sat,  7 Nov 2026 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064920;
	bh=R2YbCtpvdtXoZ7RTjN5MahljVO6p6M8od2TY62KlNm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5c5n/KRoIc7DOEE8Llu7Lti0Qtg4TpoIxKHk0UgY1qHV5PKXHufNIQZFk7X5z5Nk
	 9SKt3mjztE1bOgDMHl7+0hmoOYsbp0cnbWtdLRL8yfpABlaAAH6gceExnXhtBZi2dX
	 xeawR708DqNtDeNNSDmbDQtb6MQ27MA8dKv+ps44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0818/1257] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Sat,  7 Nov 2026 08:51:54 -0500
Message-ID: <20261107135001.936124436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit a4bfbfb4e98a62b589ac7ca9e73e9612bfe8cab7 ]

dax_range_compare_iter() has two bugs in how it calls
dax_iomap_direct_access() and uses the returned addresses:

1. The size argument passed to dax_iomap_direct_access() is
   ALIGN(pos + len, PAGE_SIZE), which is an absolute file offset
   rather than a length. This causes the underlying dax_direct_access()
   to request a massively inflated nr_pages via PHYS_PFN(size).

2. The addresses returned by dax_iomap_direct_access() are page-aligned
   starting addresses, but memcmp() compares from saddr/daddr directly
   without adding the page-in-page offset of pos1/pos2. When pos1/pos2
   are not page-aligned, this compares the wrong data.

Fix the size by computing ALIGN(len + offset_in_page(pos), PAGE_SIZE),
matching the pattern used in dax_iomap_copy_around(). Fix the address
by adding offset_in_page(pos1)/offset_in_page(pos2) to saddr/daddr in
the memcmp() call.

Fixes: 6f7db3894ae2 ("fsdax: dedup file range to use a compare function")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261011064840.1296-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1fbba0d21c13d..dbb58692efecf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2200,6 +2200,7 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -2215,17 +2216,18 @@ static int dax_range_compare_iter(struct iomap_iter *it_src,
 	}
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
-				      &saddr, NULL);
+	size1 = ALIGN(len + offset_in_page(pos1), PAGE_SIZE);
+	ret = dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE),
-				      &daddr, NULL);
+	size2 = ALIGN(len + offset_in_page(pos2), PAGE_SIZE);
+	ret = dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	*same = !memcmp(saddr, daddr, len);
+	*same = !memcmp(saddr + offset_in_page(pos1),
+			daddr + offset_in_page(pos2), len);
 	if (!*same)
 		len = 0;
 	dax_read_unlock(id);
-- 
2.53.0



