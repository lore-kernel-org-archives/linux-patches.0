Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059199;
	b=onPqRoM778KhtYqA0oZn4wg3x/b53V5iBBMGKbitGnCrnIfyYZR8t82lmALPp3pUFtg6
	 K8i8TbWmruXP9JbuUruE38NVtNljfMlzxgknJaQ0WLiKhJuebPeQMEKDBactSOTaOM8v5
	 vUdkj7Fd/By9FTefx0pGjK02QkbfA/ECKgScJf8UEb1B0ee0XrlD/kBw92hGM1lGnwhmk
	 Fv+4lZOBjxP+ZFSHtMzrGUl+LYomXl2yglCXxD5M+ilPQu6ZdFFE0QSyBxuMdBVQ9s9hr
	 JiZfOmTUD9fRRN5qI4dpbFnmDRYROw3nfqrFJhj8uvYut72sRztSQQZcrAmTCGybTMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SmFNgeDKGZPW+GOMBMLOfDWGfuyTHSXWgXsovHcbIpU=;
	b=2PEC9hvTK/44exPeGBVxngsPx4ywZpOiWE9B7E9COzMSAlbMtaHFJhnMdYvQMPSfprd3
	 iqsGAxxZA5SQ4COMN7HM70C2fp3gHFPxV2YH+EKbMg81Y1MnxjIqHj2DMZyGFy1/VB2ln
	 7XsICUQ5gPoe8x3bRo8Vy2dd4R4jyy0LziLus0Q+XzotqIE0sfQtwHkqHHQKcewDR3/kj
	 VydOv1ZXTZ1m0AbZDHG1byFKOksNa8UCwgOxv8+1K7i7KvYhc2YovEyVBBo/ZnmifN6Os
	 4c2oFnhFUL1EcOBUnWM7LV6sfrCC/GIoDGlFssnP1kyxW0PHoYJLGoe4JLHCm8O7hQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjCZHk7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C3E606A31C;
	Thu, 19 Nov 2026 03:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjCZHk7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18D31F000C4;
	Thu, 19 Nov 2026 03:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059199;
	bh=SmFNgeDKGZPW+GOMBMLOfDWGfuyTHSXWgXsovHcbIpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjCZHk7C14bT/8ljfg3tbyqOmARFhJf24DCjDDMAM6IensdfIkUFweo0sQwgLJycM
	 dSsjczxx0QPS6ZUYL3UgMVo3jcrSXjwmbtcMDdKfvHW+dxfV77AqviM2iWeTRV3RzE
	 UE9p+fx+W90ER6lrBkoackSBX4b4d34DwAI7zzQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0716/1848] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118145945.822452406@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 2bbca049deeb1699cafd966cb2793fee576ee409 ]

In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
successfully allocated a temporary cursor, the error path jumps to
error0 which returns without freeing tcur.  This leaks the cursor
memory, the xfs_group reference, and the per-level buffer references
held by the duplicated cursor.  Jump to error1 instead, which calls
xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
resources.

Cc: stable@vger.kernel.org
Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index aaa59daa77d05..6cae1098f73e1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2396,7 +2396,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2566,7 +2566,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



