Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058903;
	b=PhZd7Q/8cizhJkQXk+kazSMxU3VMQzYfl54kNY6KQETThLc6aNm0ei4QmlKDtLDLsbcy
	 mgqTYoTrnQ3NpIHWOTsM41zThMUVEFrdykTNYLND6omZeDK9Yfc6cZU4Qx/LALMKZ1zd3
	 eovLccMDwmG+Y0bVYCYVCxFdvzA/Win1X+LAAEKGMPsyjL3+GWEkyJP/HQZYXDfn1eLNn
	 noe7SAZZFKwkD8f7VUWHLKWkkgj5eem6MLeexwFcPk00/5EgD4uxCx8w0EBaRkO4Cvcr/
	 ZfU3zQ7h6/IoGFYU7h61xzrJeSCpNCorOYITIxb5xbrRYlatAKMfVSIuC5GjpE1jBPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnTEtiAtzUwF2GUgVT5ZFtH/nUij3dX2rkikg/q7iuo=;
	b=wmol9oiolZWmNz4szAoGX4XjYluHQRKRUbfxqS4y4g7NtNPeFATCGs9yamfWwzxRQxJe
	 lJkH23uaAvKtBFhA4cGwjW9ZeNTFV+fBpyCk7Bwq4fKBMa9Tyl/ehVuhtX1MszG7lzeN7
	 6eJCTs3x6DTDNwHXfehxSmIi7Ik5OUvLNCMAIElcrkVNCyEuzOrqI83umByxoQ6Ho6a8R
	 qfzTP25+AA1be+AU3VwC7fqcw9zrLCi1E86TyR70mpppeCTiLW/RRZxnvKNhldUJZezSo
	 8CG6qIDoFRA6hb17uEq5yyeWpClrtOLHwwvZMAurMWmniKpjf5hNQO+o5y8f2CyrTiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoCiRo98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D95606A31C;
	Thu, 19 Nov 2026 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoCiRo98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE491F000C4;
	Thu, 19 Nov 2026 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058903;
	bh=HnTEtiAtzUwF2GUgVT5ZFtH/nUij3dX2rkikg/q7iuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoCiRo98xehP23Su+m/9b3BhB2qOY4kGPfHh8pMHgki5IPCPf0BKm2OoVvwWa+Tzz
	 rt549Mt+P/7rs50YoJwvT1aAAhbO69aJ3HsHQhzmaEPX37pwVbFme8jI1EwqzVEWi/
	 umjK7tRcSyCIVYR5knj2Dtg0Hp7mH295mXTsr+Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0651/1848] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed, 18 Nov 2026 15:44:49 +0100
Message-ID: <20261118145943.065917516@linuxfoundation.org>
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
[ sashal: adapted the check to xchk_xattr_listent() using sx->sc and goto fail_xref instead of returning -ECANCELED ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 3947fb3deb140..31d89e5961bb5 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -134,6 +134,12 @@ xchk_xattr_listent(
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



