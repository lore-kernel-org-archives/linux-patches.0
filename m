Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052854;
	b=b5G/PXA5sszV19T+tNzpESJHOGA4adb3JORmSb6ytRCkU2HuS7aqyBkr+VqcqJgFxUPc
	 cd7ZZjj8gqscKBqldUvfFU+Mx8iVVY7dIZ0fNkmTIjLKN2zqWSKLVqvMCJ2mw8w80SwoX
	 2FkC9TyW2WOelRgCc2qnMmE9U7MtQ7beuqbVegFCwqPHiUk33LInsZPkrvnRhKXVAqaoj
	 KIKRZzDH/AlJQ/6y0+S196XMHVGY6mwke9U8OZRx10M5d8TNkoeAouhDp55XjxggJ7SXE
	 gS6gstcv87cBeNUmXi1feRB67oZwOk6VQHgy382sClSGapEqyJ3jZ4Chmq2UFK0ZRjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ii9YnhaVkPhbD6St7BqJoqh3poXMx/A/lMn12uTG6s=;
	b=GxHvEQcVCgxCj4JvZdLiUXEtMJ9mGeQDFc16SdfKOYQPWn7dVpVd+9FJYIKsnSswiF2p
	 3eJ+77Cc8hksqBExiHISp035gYc8SMvyFDw4OEeACNwn34AzfNqSpPr+YaUf+2RnQFHpa
	 2cKOTM5rIaR/o/t4MxSSWtI3AZUw+aqmlXmo1Nd1ZGaUqRR/jjfQ2RLK0GQH/r5LOBvba
	 cHAMuIZWC+P5gMGOHvrJWvjR9/Ta4Rm7hUDm4FN9DBor+wEvDVsKHiqBnbC+5KpAGjZWP
	 9rmk1Yil8Z2eRZTzPvNXwMkYO0YPw1I7ta26QRs77QZ/M6wHJvE0+a72VOBDmIa2cMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ory8xByM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451C0606A333;
	Thu, 19 Nov 2026 01:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ory8xByM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971AF1F000C4;
	Thu, 19 Nov 2026 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052854;
	bh=0Ii9YnhaVkPhbD6St7BqJoqh3poXMx/A/lMn12uTG6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ory8xByMi+/OAE1YqGc4YbvPBh/f+OVHRNJhYRldGj/0nz+xHE6WBmNpCwVEOr9zw
	 64mxKtbnifVUl9tgOWXgrofAfzxZjM24pA+tzAdq/6q3/J6Nc8dvRVRS92eax0oNzW
	 j8DvHCcBPk4L+Fvm6mHYnKjEtRbQ7EOS4cpDu7NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0710/2214] ceph: avoid pending truncate during nonblocking cap acquire
Date: Wed, 18 Nov 2026 15:39:46 +0100
Message-ID: <20261118150040.195385431@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 979b7ed4457a04c5a41c36f86052ecc6b76c67d9 ]

Readahead acquires caps while the folios are locked.  This can
deadlock when processing a pending truncate; truncate_pagecache() can
then attempt to a folio that is already locked.

Return -EAGAIN instead when `NON_BLOCKING` is set, causing the
readahead to be abandoned.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5cdc7052e7237..42af046aef510 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2675,6 +2675,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	}
 
 	/* finish pending truncate */
+	if (ci->i_truncate_pending && (flags & NON_BLOCKING)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
 	while (ci->i_truncate_pending) {
 		spin_unlock(&ci->i_ceph_lock);
 		if (snap_rwsem_locked) {
-- 
2.53.0



