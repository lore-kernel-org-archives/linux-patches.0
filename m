Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831681;
	b=mis6DHC7F1uwJPFquSkP901FPL3XzA6DeL6I5GegxK1M7ZfrAptHUUgD9fbQNhH4eq3u
	 5dld//8qHn32tzfl4zhzedrxYvn41h1yP+a475MPGLu931w6EVKGmNHmtjIOqoldPr2ee
	 LOOhfRu026ihFUT1IpvDJv1UAvFERidoFtR9UQVIgCxwd1/ZvAuMi00Kq6zlADdrcn+/J
	 zJV4zKIQE6uu0p4CMdNm+Q8ftAGaz2c+eXfNJf5AQ834P+b6aZpKmKLtvHOeDfdPFpgfL
	 VJ3aqejXTayRA4HjxJ8g+D3Yiov+0w/RMA94YDgf8vipvi+3B5SUA8ZiCDs0msvtZDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=41JaxFGrr23pChOuynkSZpUomliuyLafn+xFLiDRZHE=;
	b=pd8nVuqM8YAz/tek18uiT4dUrkV3J+TySSlrjfizx3LohLL20FXDkGUpS6C8n6T3Io22
	 72EoQxifgitE7GLqlczFX81O46ftaOPa+iW9Uxty5FARg/7OkszWxtoQUnUT9yQG87VgB
	 i7VdwC1us5gXmI6+Ht3g9Vpt6H7JGtBTbtUSQUoXjKHnL6eoPS5rcVrF1kScc+3JLCDKW
	 5xIicP0qCbGd0bhnRB6IYsB0KOZZwLK58tN1YZxiEDKKT8wN+XGRMbhVGBhopDUW4W9Lo
	 k/15hRmwglO9dOy+iAacx4v7i/d+xt4jTVY6M6oC3vgrOS2SkSwi5ugOSEZUpMekezQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gto8TeOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B8A606A33F;
	Wed,  4 Nov 2026 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gto8TeOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2721F00A16;
	Wed,  4 Nov 2026 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831681;
	bh=41JaxFGrr23pChOuynkSZpUomliuyLafn+xFLiDRZHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gto8TeOtJExbuXJFRd8DepQHzwLmyhEECyx7QjFu/Ej03yOu728PKDo6V8kffG1Zy
	 8akXt4xLcEMhFnFTVFlCZH8JfXPhrlBZmS/O2kIjruexfSGr5dZTMoTV51d4Q296Xh
	 4t4+XDkdNmtdt2/xfEUwJN+cIiQeV0FNH2kkR6mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0852/1005] xfs: dont set a metadata directorys parent to sb_rootino
Date: Wed,  4 Nov 2026 16:09:45 -0500
Message-ID: <20261104211107.160534530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c9f98b0f4f70c8cfd617dc2886bf2fc0a36ab9da upstream.

LOLLM complains that it's weird to set a metadata directory's parent
inumber to the regular directory tree root.  Fix this even if nobody's
ever going to notice this because metadata path lookups don't access
dotdot.

Cc: stable@vger.kernel.org # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1674,7 +1674,10 @@ xrep_dir_swap(
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
 	if (rd->pscan.parent_ino == NULLFSINO) {
 		rd->needs_adoption = true;
-		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+		if (xfs_is_metadir_inode(rd->sc->ip))
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_metadirino;
+		else
+			rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
 	}
 
 	/*


