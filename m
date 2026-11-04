Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831643;
	b=Q4ndQ7XE3CrSHjRjh+NPjeHRATSIoHuxk3r1YpDWk1qIJK8m89Ix2+Te/fFTvb69EIl+
	 rFzOE+vNbMNQlWavouh+hMwPQYevdLuK/02bxojltZCD/h3UpYLkH3+G3oyhd62NOosJf
	 H49PJPb4YSHKSqjPtF/NJXHd/Okrld5wAjLMS9fdY0QYtmEjguBjS5QKJder7ZfjuXzTX
	 JdSw1qXGk+HKJ4SFN9Y4P/VvGjrlRJjJlbCdq3yzJC2w1o0h+D/a9z0wdzY4Os5sH/dlN
	 Z60TOSgGEwp56/L01RDAc70zyBnRYTcGCsvyZJO+dPOtDcoru4pz7R1ILUopxcwIouw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zBVjgVU9XkBDiiLs9IvhVHQuEV5+Qk39pzDbcckNo90=;
	b=Pv4DB42ElA6auAZUf/kITZ6Xqu3UcNaMZsO8PpsYyQdmsmLTmVP/K8MaQeLi0uawjngk
	 kX/JmL+0OHF7aUajDTU5/4tMBPtrmMQOJACScj/ZXIh/wS84+seUWYe41wALX+oS8UYj8
	 PkYWgB+vu2MKpOQbU0kXcCjaeYkRo7/u7w7mH2qeI5JovGa3TK4kx+JdVfwVjMeXZOl8r
	 3iAT228dToI7+mNcgWNXyhBxAmU2tfMz8Ri0m0pUXfw3Dh3gkBPYgirIckHbBKp8Bua7B
	 acMGWiLykfJkIL7KX2Lx4iI9RU6FmpskW0HWSvYdXnORkDKAp48J4GrTBXDQPVVy9Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqzGoKs1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293C606B2C6;
	Wed,  4 Nov 2026 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqzGoKs1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3DF1F000C1;
	Wed,  4 Nov 2026 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831642;
	bh=zBVjgVU9XkBDiiLs9IvhVHQuEV5+Qk39pzDbcckNo90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqzGoKs1AQwfpv0XVxJ573Jy/wsyJvwd7wj37vUHWYS7jOywqZEHeBVkwTCot/8Kl
	 Cd/0qsaR3EX+ond/Cr9b/k9Vcv1a5p5xvRR6tlPjAHD9C7hiz1/fzarsgpCj94HKG2
	 5SI93TcZOS8DvdM+N/pU2lgg6++V2f5yX8YLpeFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0828/1005] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed,  4 Nov 2026 16:09:21 -0500
Message-ID: <20261104211106.526724871@linuxfoundation.org>
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

commit fd012955641881169a9f01a00f656f6ca73842ec upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c          |    6 ++++++
 fs/xfs/scrub/parent_repair.c |    4 ++++
 2 files changed, 10 insertions(+)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -216,6 +216,12 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -910,6 +910,10 @@ xrep_parent_fetch_xattr_remote(
 	};
 	int			error;
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
 	/*
 	 * If we need a larger value buffer, try to allocate one.  If that
 	 * fails, return with -EDEADLOCK to try harder.


