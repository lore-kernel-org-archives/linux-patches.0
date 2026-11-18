Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033873;
	b=p89psRKHzsdrAOIHn3DJqJ5zcIiVhMx0pwrn4ARH1+KDiQfpCE+fL+7R1gtLYuYLujZx
	 hItYKgbcPO6dEBiVRm0Jm6BPwrA7GFFI+GhgbYxeshKn4pkuxdII2jXxidk2o+hYGez+y
	 CqZYuloUDfCOLst+qU2X5DAh13GsD07oTAsQxm3RzRhEpp25843z9cGN6H1q3asiwFJ0I
	 zEJFbs9gA1Qek1/QXHHwMIKaUX+6NkKkWErphcQtedHWGuIBVrsoWaKISdZHfWsQkK3X9
	 WP6GprFtXm4swvT9UScNGbg82GxDKtGVnLo9BsbNdiHWhZ1apew/kkyNrXDW+pvhK9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ig9ukz0vceqRMHjcDeNXjlA/viWwlfUvGhcpxIgGQOw=;
	b=xJAKf02ygJoS7muteQ4hmH+xOI3XEUcrV+hhXJ1rEMz57SGNGhIh5VVQk6AdbVRk2Up2
	 HUU4MYIgcF8WnInGu/IsuaSw90cZq9odQHnJFQ1W0xBhMXs4NXYGvNseN1BV/qe45gKru
	 HHgQmNkLiTnOkiXZmhlK4Tvt8DnXXR6DbQ2RN3H2ztyicTbXcxN9FbBoAWjoTMWKwVebC
	 +jR4B8ryd/ZQYoilbEovZNhZ/E4i2U0aJzsfZyuH/iskaP1HjoB2/OQL6qQxBf0Q0VwRo
	 12vMeGiVbW/Zxbk16tdve7RqZroiJx5zlDwWRrq7iNSqjiXAtxO7O9cnegqDO//IYcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBT5oxCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34046606A320;
	Wed, 18 Nov 2026 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBT5oxCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D05D1F000C4;
	Wed, 18 Nov 2026 20:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033873;
	bh=Ig9ukz0vceqRMHjcDeNXjlA/viWwlfUvGhcpxIgGQOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBT5oxChb9AURPHp/FeqxMVxRMXV+hJZYr9XiSc28q5LRsLbM9iVKjuHJq3/fQWOZ
	 bJVW5Fg4hitaI+H1O/WfqIQU3/+1dsFZ3r5jlBASFhGCie3/L88SZBCI/zgf+01rnA
	 Tr/bFi3B1ATy94am1j/1UyTZ4gQmEMaEHwHo0TXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0170/3318] ext4: use FGP_WRITEBEGIN for tail block zeroing
Date: Wed, 18 Nov 2026 15:13:12 +0100
Message-ID: <20261118150319.749622428@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit e1cf7b5f5c8ad1e00d00c50c61c3e8fdc79cd422 ]

ext4_load_tail_bh() returns a locked folio that callers immediately
mutate through folio_zero_range() and mark_buffer_dirty().  Use
FGP_WRITEBEGIN so that, on backing devices that require stable writes,
__filemap_get_folio() waits for writeback to finish before returning
the folio; on regular devices the wait is a no-op.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a81a0cc8758c8..7f9358612f453 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3699,7 +3699,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	int err = 0;
 
 	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
-				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				    FGP_WRITEBEGIN | FGP_ACCESSED,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-- 
2.53.0



