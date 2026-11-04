Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831590;
	b=vTitjXeexg/7JoJ7aiPMNtPZPPwcTVqvAjzTugvg5rt3daqS70AJMs6PSNh+CIFYhnRj
	 hKAjs/kHLM84rPpgI3Gs1zIcCa3pdDORg3HSLn0ipSN+LjxqKoUckBWTVy5ayy0aJnSVn
	 3p7JB3PFebAva/cw9l8damsbmA3sLSDk7j8LfL7RP+xVbYLq9XHD3XPtxTj/Ul+bQ5EGr
	 1wjEnGWmq9FgbdwzxxKocFPIC0jnfUX4hbUGxMxlz0zw16z60PxwZnDTGSy247N/Z6lAR
	 Fz8tEmYm91KfSshNpwEDXfNCgcgUhNiaVtqDreFDxlXum32ZOW+ZXyEmvnaVNTLWuJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBLIh5mzAe0BiY3H0ibSqTBUhD6wDG4TKCMjieGWl2Q=;
	b=fxjr3nvUdr6yhL23fqEf1Y8Q2iK8wrFCdiZqs3EHGcvj6ypNiilc034GXWOqnfsBnk5m
	 uY64PIUOQFuAWSSVFs//RXoKXUrBAb0q5YLZKf6HyjgIN7vR2d7B6lMy3TgyWRUIoM8Uc
	 kqesG4Mjc53YC0VjV6R4KCeJP7QzBTkIRzMagEIiHTRbzQopaHdvlomMpZHASKthQeJmi
	 awpIWx389ibfnJiwFc+02AB2Ns7gbz/JVkgU+aKlSqQvAAnPzzIlS683d1pd14oLa/vrS
	 1Ckuif6O0N1xSGHoLQuGBjwTc9YICYPZ+vbBn50efOsvkYKT7EjSngC8ORtEBFTaYxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb5+Mx45;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22958606A844;
	Wed,  4 Nov 2026 22:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb5+Mx45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD6C1F000C1;
	Wed,  4 Nov 2026 22:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831590;
	bh=HBLIh5mzAe0BiY3H0ibSqTBUhD6wDG4TKCMjieGWl2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yb5+Mx45VUSN2RMcOJpgIl/L3kHOmyRyNJMpWvdbAmvEUsk/BSPE6VO2IM6cTbyxI
	 XJ5u6T5f28TZgVTacGALF5frUtcFl0Zk2QpAqXIuxk1i1m5TrCZHMFtlcsW66Wflln
	 P3PKXeOgtYRD7eEDUCgzYzclj4pHjD+mnKjLlXDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0794/1005] xfs: fix skipped inode mask handling in iscan
Date: Wed,  4 Nov 2026 16:08:47 -0500
Message-ID: <20261104211105.584105172@linuxfoundation.org>
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

commit 63341d4af16fe850716b454fcd18990590d07d97 upstream.

xfs_highbit64() returns -1 if none of the bits in its argument are set.
In this particular callsite, a totally zeroed mask means that no inodes
were skipped, so executing the if-body is incorrect.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 82334a79c6eb1c ("xfs: iscan batching should handle unallocated inodes too")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/iscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -545,7 +545,7 @@ xchk_iscan_finish_batch(
 
 	mutex_lock(&iscan->lock);
 
-	if (iscan->__batch_ino != NULLFSINO) {
+	if (iscan->__batch_ino != NULLFSINO && iscan->__skipped_inomask) {
 		highest_skipped = iscan->__batch_ino +
 					xfs_highbit64(iscan->__skipped_inomask);
 		iscan->__visited_ino = max(iscan->__visited_ino,


