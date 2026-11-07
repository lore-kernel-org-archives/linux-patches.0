Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061637;
	b=L8YkIf52FioSMzEvzh/5vMgTUs7aC2iRyZT5L4x511qek90XXagGbW5j/3tzSX+OZMxY
	 ph8Jl1eLw+WUjCpWlcD6ao7J+szMdzd7ccAuRwckIi8FakvsOJr+9RuRA573LD8cYbxDh
	 w+sTQCiOztGs/1FWu5Fhn/B5XKcxcIK+37iE3ezl//BhMOsDylKrD7qINnjdRSYAAR2pM
	 PaAvbQYzJAP1Nk6bosgl1EbSxYge+CfJvCOVwdd6ag9t2bq4v2yYrfzszMs3znY+NCsJ0
	 JvCl1UwbeeLVslKm/97rEyHTLxmFTMk2pq+PP0ITVQdAqs/F++O+5Xme3+8IrbnSoKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WIXOMO4XX+pjJwg6p/KzlTqaKXNkukkbWTjSXioH49E=;
	b=PZ5VNSyGkjUuVejGMY334DR7LmrrrFVvR71HDb0ouke9zpqv00/dwMOsbikRRrBhNi3V
	 /hy7J18WD6J7PIpyTggJ+rekXpwNlH7k4s3TdlSxsLBLk8dLKn7IK6S/v0gOLZXiCuZmd
	 pRDBayQAUcPSgtUOlC1SMEat38dnE5IXklXi5+U7W5oipvxOW/PIbNtEE0chY/Y3x2H2o
	 xY5ZUOfDyZKRYFgUNPsRC6ZTzZDarV/rwFuvhaLT+GG8+rpzEvzl9pGPI1UfpWFio9Hdo
	 8fOaQ0/wybVOOboJcdewzCg2qU4R1a/YHudfwvvKcboLruKFKJmf9Be9/CbPn1mr1Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1675kz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D65606A326;
	Sat,  7 Nov 2026 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1675kz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843081F0089F;
	Sat,  7 Nov 2026 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061636;
	bh=WIXOMO4XX+pjJwg6p/KzlTqaKXNkukkbWTjSXioH49E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1675kz5051dzPuyCOtiJ/E7xNI+AFrJ6ey+krzB96jeELbHC+8oYi63atZXEEImV
	 n8VXdTvrAlV92HS/Qk+3HeuWDhnxZB2NyHhYWi3M8UYYD8uJoV7MV7oKYn4z876Ubc
	 ZvEp+hhuPrKPrHgqRopscIhWZ0jV3Gkiuna9jU0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0698/1536] xfs: always reset incore attr fork buffer when resetting fork
Date: Sat,  7 Nov 2026 08:45:14 -0500
Message-ID: <20261107135017.095993969@linuxfoundation.org>
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

commit 71cb13685e72a3c5d118732559c727a0c9090b7f upstream.

LOLLM noticed that the local format attr fork verifier depends on
if_bytes being set correctly.  However, the fork reset function doesn't
reset that correctly, which can cause post-repair verifier failures.
Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 387ad909e20b..98a74066b240 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -840,11 +840,11 @@ xrep_xattr_full_reset(
 
 		ASSERT(ifp->if_bytes == 0);
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-		xfs_idata_realloc(sc->tempip, sizeof(*hdr), XFS_ATTR_FORK);
 	}
 
 	/* Reinitialize the attr fork to an empty shortform structure. */
-	hdr = ifp->if_data;
+	hdr = xfs_idata_realloc(sc->tempip,
+			(int64_t)sizeof(*hdr) - ifp->if_bytes, XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
-- 
2.56.0



