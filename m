Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060969;
	b=FLvfbeVqYhhx/1Uep+ca1buZcnavU0wrq6IndWXMXHf2iTvNLY2RLG7n491lW5jYKA0D
	 48zLUaPe9zoAVLfH9UFVeOkJifs9K1zcNjaItxoibPC0fvv4gI7w4SAemnBRJo4Z9Jc5q
	 7pQXwvowyI+daHdHlJm1+mRAEH7sW9JAQkz+Pr9Hz6qVMZriYsfrhnSGYe9DUXMTPdGPS
	 Ds1XZp2jMbOh9lizIYCCJAmBBcuZgUa5UmO89xQPzHIHSIzeZbtFXqJD6RPH3R66+pTDg
	 viTehWykEz4JqN8tnzbxmH1rQtPSeAKf6AABH4R1DFRwVWDa1H4zpXBk22HeI9bd0Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEc7GJmbqCuURg3evP+w5pNPEBX3j3DOk3YrtcaCL3E=;
	b=IAyWsblc224AAKSv4sej2jIS5+7lUyA/REos2CASDiNydeIZFSe4eL6Ah8qOLlAaP8LH
	 0FxyS+OD/R7kwZZtJdOIuUPgdGRslE031oi9CBeSF20VbBZwbnyBmLIwr/CMcjwp99Ye3
	 VbQotI33ZUutNLyCMuNQsgpxzPrApWvUsslGexlpHJq54toiGqxFs2OZcT3hXi+CtEJEF
	 9iVzyK56MV/niIk0uxOui1ttvLASE8LMSxwcWB2phOFR2S1S6w1nE4TX/UyG1+5K+OOch
	 a5EPTTdzArYk61flHEFIo5yAOxvkN9bA9jc3fMzMLxVcPaU4kTwByhxqP7cpigTchSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekPoWqNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4C8606EE9C;
	Sat,  7 Nov 2026 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekPoWqNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6561F008A3;
	Sat,  7 Nov 2026 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060968;
	bh=dEc7GJmbqCuURg3evP+w5pNPEBX3j3DOk3YrtcaCL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekPoWqNGpYYXMXNqhzQKeNpcl+9nUUNZiV46lKwG20F9d0iJcuvMatyQK2lxOwIKb
	 hHPEdB4XdzdB/m6g1ZAgcmy+N1YjwAcCTrqa0Tux9qznacQZL5yIbyVuJZt1lqzQ4D
	 GuCowhYSwbAAi77yEYdzF2Fx7GN0jDIXKw7j3cCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0322/1536] hfsplus: validate extent record length before writing it back
Date: Sat,  7 Nov 2026 08:38:58 -0500
Message-ID: <20261107135006.764038137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b1699b3c246ae..dc23030e1f65f 100644
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



