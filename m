Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043611;
	b=1TkdASwylVReQ6umg1LNoz0FAGanqCXQJbDNMfq3glmlHp0XRkwvMQ5GviTuuODoxq2t
	 /ZUyqPkuCy6t2dLugk7M7RF5vp1fghV7f3wr49rxYlLwR07vE6toS2DpoEkQTxMgFAmMb
	 sbI5+vMaCTc3EDBhpedXnbk2OCAUTyu56li5mFLUtSJD7mn6gixbJrHho8oCnwQ7rmU+Z
	 w6dzmbNnFGJjqnzbP/SlILqZc95Soz/oJCr9RtYbKmo+edZVXlrVLf2bMivY7wJYKyo71
	 q9Cxz4d1EYoN8zzXRFP2jkkY71IHHS1I0m+CpijCYK0w6eTIx5ZHcVycQ72ViVHKxOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNFTFhqeYYfM4c8RZTa+5v11Q6Z+4mQuTo+DRI9TVA8=;
	b=o6l56q0ExJLv+kZUTYmRNTMMpE/cKhiZ3daS5qfCfrCQ811o1Rxozn8ivneSOkLW+l/1
	 kF4E8qvY6DHP06sUOO1QUWQNcnSIz/8XjmiXOmd+petA1TUQJpHZ+lEnMmtNEJPy2Cnk0
	 WV2drt4lw8lu1tcO9rWYGBZYBuCsl/2luLPKlV6nnU4DOlCsIj69sIWoaDtgUtW1tU2dN
	 Sj3jAP8C5FwKPFZo6s0A4Q4SytlptfGo9MbnNtaazO4Gw4b5Yw5j+4jmzLZ0vFDwUGa0+
	 dJu103B71fHpXoewcrQGsjdS0453/GAJoCfHBRb1phTZGUv5OYFy9CM3YG+c7fvLsOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDu9TlRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565D606A32A;
	Wed, 18 Nov 2026 23:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDu9TlRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB361F000C4;
	Wed, 18 Nov 2026 23:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043610;
	bh=NNFTFhqeYYfM4c8RZTa+5v11Q6Z+4mQuTo+DRI9TVA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDu9TlRlQYKpgrDp8uDQ62n6lLr+1NLi3zFx4sD3mOFpuq5nTZbKbT3GydFuhGJWq
	 nHUHhv+ZMPzIbrmXYuL2GmjeydKqhK2T6kUgwR5SyZMrLZuQOLPjtFGlmGy0+dlaqQ
	 JNJev1fAomdo9EtWRvI9Uhdu1sqwqDe5YH8DvFqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0235/2857] hfsplus: validate extent record length before writing it back
Date: Wed, 18 Nov 2026 15:21:09 +0100
Message-ID: <20261118150209.914475091@linuxfoundation.org>
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
index 839bf83448c34..548e3d3eafc57 100644
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



