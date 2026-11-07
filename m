Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061686;
	b=wGHzWVgfHJSTRz6uBkTIjcZsMltFwehcYHQelR/JAbE18kb2K6IVVexFElugZINWv0Qo
	 KE/QUStnFbdCNrAWSlH1tz3/5AzhobCpPsNlatMVBhHKhy8nQhYCAPGIttbuO5uIGwemA
	 bWrlTVHDc9tUPoljhFFzxZe/yMuBbYSZAMGq7neDk2qJfSaY5DGENgb9Q4L2Lrv7SirVn
	 oQdh2rfhSwabe/EJ/8R8xNbBlNcVOL2fapLOjqOcmrTycgGPHfWSfZccR7sX65qIFa4vk
	 2uXGX097sFPJf9Bu/PZ2td6ll6n0RYRa/0gBrg9dV001rU3mkmGpzKKsPHM8FR0qVGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWvzxA4prNiHslDSZiH+B4JCPIynZly4izQ4O+8hpLs=;
	b=nRFZMi0ljrXBbHjYGivhyvLI3IFa2+F2GFGWPWmp9ZVPv0OI0BI8KTBTXZuYm6H8t/5X
	 pqHeVMMxISKuzCX103qwIuuWOzcq+RRiPNVNNpg9VxVQC+hVRP+4mdWBj/XwI5Nt7UU8S
	 bH7WxstPlruQFQ3u2x6EsTOjLaeMOsHklGCgquBz5OSkj3EEP13IoHfhA8zse/ti8aJ0z
	 g1vVI69nuFCwccQ5ZuSKmKQs88GJjRxMfX5HAU/wxrUElDJXr7iUyOHHOElvrJ06ZN8oa
	 XSwnd4VTfo0t/WSHWkuaFQjf3P1kleC2IrUUbmNlDcupl/JppLgaWhhas/wF0c+D/Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FT+fvujd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E9606A32C;
	Sat,  7 Nov 2026 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FT+fvujd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D011F0089F;
	Sat,  7 Nov 2026 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061685;
	bh=uWvzxA4prNiHslDSZiH+B4JCPIynZly4izQ4O+8hpLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FT+fvujdF4+m72OdiGgxlHQv8HiOi4fhCMBUqjIgApEI717OUrSAZ2i813m1/0beW
	 /4FIWwSYjyyThPbL0RHPgrm9plWz+DOJjS8kMhv7WuZJgqoai06i5OfWcGN5+xFoXz
	 a1RD97FGBz9yJl+0JLjnGmqbP/d3cBIzMH6juylY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0736/1536] xfs: dont clear COWEXTSIZE on directories on reflink filesystems
Date: Sat,  7 Nov 2026 08:45:52 -0500
Message-ID: <20261107135018.186665085@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 3978b1f3109dfd5c648442bb040f9abd58608226 upstream.

LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
unnecessarily on directories on reflink filesystems.  Directories just
pass the hint along to new children, so it's valid to leave the flag
set.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -553,6 +553,8 @@ xrep_dinode_flags(
 	 */
 	if (xfs_has_reflink(mp) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
+	else if (xfs_has_reflink(mp) && S_ISDIR(mode))
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
 	if (flags & XFS_DIFLAG_REALTIME)


