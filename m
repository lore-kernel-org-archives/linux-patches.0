Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053110;
	b=dWUwk2nwF2E4lnQUFv6NUA157dPSSSRVR4YGm2DN/uGlZleQPAgCq1r5ORAMNzKw8BI6
	 ms6V4mSyslaaUn5lSGlyv67Yc/7dQTVVsFvRtza3IiiInv0rc2+jknm/Oo6kKkxGLq8RY
	 HyGtNOh3KIA2qh4WqRk4EQAKt0Foe1tnP1MeJV9ZIYu2P4txf224uvQUEyiVbZcVVBuSZ
	 i7QxQqG3evNgYSTlRCT8QUtJ+LJfNt3Z88Nb3TxGEO3rSaJt+kM3cNqAvv+X5VSaI2fWA
	 mOzwiA5uNwyQqjVdLMfqAwWVJWKab69EnXFZMy4zzcBXC4yBCukcUs7noXwG7UYD2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VsyTMQD/46umSESKORLe55UAy/g0naAn9BhXrW6LwZw=;
	b=oz6gE7BCASGcPYwBUoqoK21fh3MS0yC10zAonorElLz0376IHCGA0C61XDMvW7euYIL3
	 P4F0j3/6wWaTse+XdNna9plWgWkjvajOzKaCnlbdpUj2qZ0tAx9RWBK5WEPH2ajZks+pb
	 1xookJYvAye9cU6hMOSjPt7lPXMcVBZviAUlCu+UULwh8XtymjjBQzRb6kMRueVvHwBii
	 i7JPWFuIGX9QUP72feuVJYcMzX+mJT1k34rOCFIyYuXYCbsRdKYANwhROEebKRwKTNvtX
	 APo0KAaRp8MqZ2GWkFUvqnz3w6QdoGBD2NM2dLiKwwQq4Hzthby8GdBS+AY5etxr92Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brgTqwMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D24606A31C;
	Thu, 19 Nov 2026 01:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brgTqwMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F271F000C5;
	Thu, 19 Nov 2026 01:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053110;
	bh=VsyTMQD/46umSESKORLe55UAy/g0naAn9BhXrW6LwZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brgTqwMHa7QpHsrR2R1FWj0k6POnSo1LUD806ZALwtwCn/5A715Rb5beBHVIsX0x1
	 RRScdyzFt3ONwyHG6Vkg5iGzSsm1nDuynANA2pagQTnABLV5EYYGTvjkg2x2G02ybq
	 qD2OqvvHIKRcn/VSRJTbpsFXLCGURT82e4imzp5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0804/2214] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed, 18 Nov 2026 15:41:20 +0100
Message-ID: <20261118150043.663158458@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit fd012955641881169a9f01a00f656f6ca73842ec ]

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: stable@vger.kernel.org # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted the check to xchk_xattr_listent(), using sx->sc and goto fail_xref instead of returning -ECANCELED ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 01a2f893c156f..1a0af90eb0943 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -133,6 +133,12 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
-- 
2.53.0



