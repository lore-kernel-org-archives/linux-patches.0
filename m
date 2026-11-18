Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034163;
	b=0mbU4Z+Id656lgi5QPGRH45QbIvWkF0L8ncIkq6FgLfRzaFdfb4izxq2phPM6OAhWzEz
	 FJoSRK5cwOxZXWATC2GNDkY0w2MxArw9JwxbeF9GtqZnbdV3gOlzS6lIO06FY7LbV/OrU
	 op3rjc8VSQImEMPkQfWFRixpUOjaSaIsW9KWTjVycrKjnRLURlwlZ+okPzAY7JtgQxP1b
	 LPfqyKaRhViU7v6jQYFVEAC8l1PlTkX5dxxfqmqbdlNd2rI7brQsSKWLzIC1eQQAmfU6b
	 QAR2m5SuvHF/DKrtb98NzLDWUddxa/sU6Um9Jjjg+tWVOHHILbXV3gJnsW/P1IhiKOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1Y6OkeSfnP9gLhyV4mxUUIPixfXmUaKIHHJ8JHhje4=;
	b=P3hc0ZzSmw+Vw1MfWPHfik/0F3HxtKg1uL36GE6FzwkXOIQ4cobFpQbGuQLmPUdoIuVO
	 OcJILYgIyJkoVHf6thb0k9EjvY022XHqhFrckLRvYYo91+/JYyfDYazY+DlavYEH6SS71
	 14Av1sBk4bje/1GPXypCBTd4tI6aLVXG0yIcEZXtsMwOp/VHiZ1OhkD6Nm/pzsPiIyg9i
	 W7qHi+86iFJeNqTDuR/6UBGMpd70liSyPk81NYQjT9pUUyXb+JK1ohWwiU/9PRMuY6Dkl
	 ae/FpfSaokspbKmle15wwN7lapx+SPfWWIOoYro72FTJaVifXd3nKF9hX4gBBSIrqWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjQcNzH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5452F60A261A;
	Wed, 18 Nov 2026 20:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjQcNzH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45AF1F000C8;
	Wed, 18 Nov 2026 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034163;
	bh=l1Y6OkeSfnP9gLhyV4mxUUIPixfXmUaKIHHJ8JHhje4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjQcNzH2fuO84K8iCodzKLJQlJ2OIeDknWYiio3n9gfaY6H6jKMAQI8CLHInwCBcd
	 54UCLvpdquQIB9LwkLiUD5QEUZ26sxXmrxC8qGZuUTQsLMGx1TK6808fWo+aDg3IOz
	 3fgPWMniCa/0LpZQFl1/f4BmCbGPK6QWbGoLNyg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0272/3318] hfsplus: validate extent record length before writing it back
Date: Wed, 18 Nov 2026 15:14:54 +0100
Message-ID: <20261118150323.610926579@linuxfoundation.org>
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 627b7865c062ff642c0000f3a4775f1a44b986a4 ]

__hfsplus_ext_write_extent() writes the cached extent record back into a
B-tree node using fd->entrylength as the length, and fd->entrylength is
derived in __hfs_brec_find() from two on-disk values:

	fd->entrylength = len - keylen;

A crafted image can keep both len and keylen valid but make fd->entrylength
negative (keylen > len). __hfsplus_ext_write_extent() doesn't check
fd->entrylength before consuming it, and hfs_bnode_write() takes the length
as u32, so the negative value turns into a huge one. The copy then reads
data past the end of hip->cached_extents, which is only
sizeof(hfsplus_extent_rec) bytes long, and leaks kernel memory into the
image.

Reject an fd->entrylength that does not match sizeof(hfsplus_extent_rec) in
__hfsplus_ext_write_extent(), mirroring the check already performed in
__hfsplus_ext_read_extent().

Link: https://lore.kernel.org/lkml/cbd7003314c530d4f910eacf019ff80adad6687e.camel@dubeyko.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260810092422.1691377-1-r772577952@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index f6ac98b0d44ff..b3f98abd064ec 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -110,6 +110,8 @@ static int __hfsplus_ext_write_extent(struct inode *inode,
 	} else {
 		if (res)
 			return res;
+		if (fd->entrylength != sizeof(hfsplus_extent_rec))
+			return -EIO;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
-- 
2.53.0



