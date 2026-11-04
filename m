Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831648;
	b=YmsSIcapWjnMSUL64NeCG123sYhsNqk8QDKbcCi65YMPFioaZp9n1mrxC1Jj1qDj1YAZ
	 x/P6r1mVDSQiIJ9M/9QHYbCVIJ3OId8dt1J4JhVO5HY/FkvvmT8dBA2mWa7UGd3lF60z/
	 9PUcCw60EsXMKbTnw/QfqnqZ7ZWTIrhZtp1oz+xNtBHKdnfX8Hxs4cXik7C2/2CrzIbUR
	 MxARd16lYRPuckh5K/g/kAVREfkl0AcBL9TXGCR4zTw0TWP4U9DbwC/5EbJlXY0U3vwWD
	 siOhUCsIA6LUgdU8FPJS2eF4eZ44sxzPloFRN7V6oa9UeTHE0K7x4lYCPoVX2vlPMvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjWSm3cKbhCZImPznQaEeNM3D66s0tDev6kiCp8mBLU=;
	b=pTRU/K+pvt3wBQSrNhNpIWom0Azq5UtpB4c2bfL06tKDDtgbhScEDMawDm5mVFy3163g
	 QgHoyCLo/BkEBc6yS+RmSWXv4+h+hhMu0HVbmzZwqdx9yr2jEeELB/WZPQhxzN5CdQnJq
	 q3hxW63m36kM2ZLPfysFOd0SvX2hp5U4UreeDoZVQAOlIQqIsGEbkk1CrnU6GYI/XaaAj
	 VepXdI3bbfhkteZOzSAlQbP0C1zGyQnsv5L84n0AuRAOn4XrH/dhjT/+rHlykk4GnEDaN
	 XS3iZePPOGrdbikXhnBWq+uW1gG18XB6nVw6ZGl7mlDKb1scvSLscWtJOg75kzGuvHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2r0ngQgf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA066606B2E7;
	Wed,  4 Nov 2026 22:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2r0ngQgf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428DF1F000C1;
	Wed,  4 Nov 2026 22:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831647;
	bh=JjWSm3cKbhCZImPznQaEeNM3D66s0tDev6kiCp8mBLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2r0ngQgfpLUEUO1k7+ENul0Je/l6sSsecjj4oUQbZLb6RmCyxMqs3G3nTgawB3Q3E
	 agoE01FLxaC/3rlUy9H3Dy2V6nhxNLKIRXYjGtO8vEXdzDjCiEUJTLMhQFRD4vmYmV
	 m/BdVAppGkDCQs4sC4YmkCXNTDDLDUdvrFzeh8Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0831/1005] xfs: release ip after unlinked list store failure
Date: Wed,  4 Nov 2026 16:09:24 -0500
Message-ID: <20261104211106.608109319@linuxfoundation.org>
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

commit 9a263723d7c9ab0615bab3f5cc145d3d24454a5c upstream.

If, while processing an unlinked list we see an inode that has nonzero
link count, we fail to store the incore prev/next pointers, we should
release the incore inode instead of leaking it.  This was in the llm
fixes branch but fell out for -rc7.  Weird.

Cc: stable@vger.kernel.org # v7.2-rc7
Fixes: 0052633527158b ("xfs: don't ignore runtime errors in xrep_iunlink_reload_next")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1081,12 +1081,9 @@ xrep_iunlink_reload_next(
 	if (VFS_I(ip)->i_nlink != 0) {
 		error = xrep_iunlink_store_next(ragi, agino, NULLAGINO);
 		if (error)
-			return error;
+			goto rele;
 
 		error = xrep_iunlink_store_prev(ragi, agino, LINKED_AGINO);
-		if (error)
-			return error;
-
 		goto rele;
 	}
 
@@ -1100,7 +1097,7 @@ xrep_iunlink_reload_next(
 	 */
 rele:
 	xchk_irele(sc, ip);
-	return 0;
+	return error;
 }
 
 /*


