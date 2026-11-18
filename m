Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045575;
	b=wc61wdrYdv3B/mq0UVN94RAFZPxvJXBrlNM+NARQiqj6KaJD78QwKrwOyiOPxMK2AhF/
	 6b1mJuqIJkguvK6GD0wnRoY2aI5RZgJsf0bJeoctBq9KnKCJHxDVxsRXh7jSzDXZwYTuV
	 DN2RdwPnsDQB6eGtRaPpXrCHyBZNecXsez138pzBY11TBskZ04ABdZ6ajrRlrdbHISFQA
	 gz1dQKLPL6k8fhQKm2J6WznHd0kSTKALrcqRtrN7buLHJVzS7//9f4QphrggI3QacNsz2
	 a3phINIsy8qG3q8rIfV4OFV7VWzvL7IzCbIM2xhT/gemAFLY6+J1QSrr84/e82vp0gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=erLZSidE3agK/oa1IKFVdfClJmU1+YsJ8cLq6R/kRgw=;
	b=4W0lv0GT8HlyAfVlvXRDC5Md9F0hvSeZ2d28BjROCIE3rKMBZHfGrKseLCH/rFOqIgZz
	 afY2PrBp+xiCaf/uekHAOwBLBbf2uhCUZxn+wa8/zPnQJipsd4ipv4mxxVe7rHHIm1Yxy
	 gOdKTvkYaqVd197eBlaCUTPq/H/XXL7oTcx6VhTBpr2LdMfogYBzxfR0hm5D3ZMKRAY3g
	 LuwX1QuIKDRzaV9HeLBxI6XhC3TnNX0KAobGn5ypywtIO71g3FTzpx5pc2djS1pkBXy0Y
	 3mgzrKmt77t65CjaWjo81D20yqfzW+jDqjKic8cZXWn+oDAJ8T+3S4O+qUSVU5Y1OPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VhpB5d7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D4606A32A;
	Wed, 18 Nov 2026 23:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VhpB5d7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928821F000C4;
	Wed, 18 Nov 2026 23:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045575;
	bh=erLZSidE3agK/oa1IKFVdfClJmU1+YsJ8cLq6R/kRgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhpB5d7qXivukOOGdrgtz9V727kIGQls6uCEYaxmPLrUedw+iBhQ/zXAC2Us7fKkq
	 feUWdqowRmMhl0mHlS6VQchLLtmNFcpIIHB12t9Bvs3Pfxj9PKZsME8zRMNUnDWFLZ
	 rRvlZKdGKC1vuIG+HzjDhRjWY3xSC/JF/s3UiNxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0971/2857] dax: fix dax_range_compare_iter() to use correct size and address offset
Date: Wed, 18 Nov 2026 15:33:25 +0100
Message-ID: <20261118150236.571311810@linuxfoundation.org>
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
index 2ebe70de35ec3..0c6e44793c247 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1957,6 +1957,7 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
 	const struct iomap *dmap = &it_dest->iomap;
 	loff_t pos1 = it_src->pos, pos2 = it_dest->pos;
 	void *saddr, *daddr;
+	size_t size1, size2;
 	int id, ret;
 
 	len = min(len, min(smap->length, dmap->length));
@@ -1972,17 +1973,18 @@ static loff_t dax_range_compare_iter(struct iomap_iter *it_src,
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



