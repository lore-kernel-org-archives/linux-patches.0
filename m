Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053355;
	b=5b2y0DYZCh2ukmrlgDz4/UpFDF2mdU/OLIARuvCRgESuEJuHNrZ8lfhkVcs7cF8hW7NO
	 2WCUXapF+d7Z2sSjHjg7T/fCS8D2CeEfjhcBt8oa4f9nw4rCgdkqB7pnQRCYy51fFJmAh
	 jU6vN31mChw/Q+Pc9rcn9zoe2Lm0mohcJfFl8TuRu7NFfmt8Di9PF+0TMpTPw6Nn5AyO4
	 +h4v5bfcYL7Vw8n+MQPt4gBAsGY0glnDOXJkHXDlETl07Hs3ljDqnOMS63V+BuW0A/FUx
	 Y7474/qoGkj3BtfzoJfssHoxaDnLG3amjw3UPIbJW5KQrN4KQCRPB4wFd6bOSAGJ7kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bS6ZZ6nIQrfqrw1wa8DN7u+B6qleqohEcixRepi0IU=;
	b=qoka86xiWULzabgBVQQZl1YLg2In2fTryD6FqnQq/vNoa/k7NeMc35IgZQ3VGHvjAcL7
	 LkXKAQb1RMd7CGqQKYLexfzOsiYTw4uszyPBLwj4axbYwDIZAvohUTYJs1KxB6S9MFM8O
	 i/+3C78tPqVroZwF48QEW6VgQhhBsBAt3VwkuDSRpZjNw+wgTJKA1GcJFY66jmeBAYOKj
	 l7dIVTZMjbkFhKvj2SUwT2pAU+LJPa7/EODzLZlBp1IAJWrmIZ7YByzFxAFaUbGSCxEVZ
	 3P+STAwWsmNLZLAp4LtgT85Wp5bIBk5QDZ7CBRaWP5T82Sd7ZZF1v1TPriL0zeJu0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0nxJf6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387F5606A338;
	Thu, 19 Nov 2026 01:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0nxJf6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862A91F000C5;
	Thu, 19 Nov 2026 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053355;
	bh=4bS6ZZ6nIQrfqrw1wa8DN7u+B6qleqohEcixRepi0IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0nxJf6IMd716at7oqHGW0W3PUMIZr9+6z9rSI+ZvzVRic4g7AgnnmRDy1A2dEBj7
	 wiAucHdyhvWFhMYw/KPbnD9zS9qt8RClARqPaM8XHk+rqlAYg/cgUAqnGSFXjGBC7h
	 Xt3pCn28rQ/DgFc1NqMHv9XHug1XpP5y0Hyk5beQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0887/2214] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150047.745170584@linuxfoundation.org>
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
index 13032aec47ee8..503db9741cad0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2471,7 +2471,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2641,7 +2641,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



