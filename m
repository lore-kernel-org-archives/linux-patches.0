Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831695;
	b=ZGkxQCyjRXxWNXakqJzbke4CM+ozLHYcLzVSeD7+9Mc9zOdsKZ3Od83vbU+MV8yWL3i6
	 +k3m+gL4kgyd2FLThu9m+wXm/MyevmQfP8kYZMNlfRop3J9SZEQ0gW0RUZN4tML5OW3T3
	 VMuPrlMt5tlG0rxZZNQn7zVEPXDZLoY0Rvqu6KSC6SRQJnOSlvCz04RNSuAeDxKHdl41c
	 bUINR/xTRrSkWkgC2PsXvxfSmHJBAjNBcsMXaGqA9HCT5nrxTrbFNKOLp+Dz0eVIm6bq8
	 LfRSDo0jLzFVuDpSe1eH2XCYPzwredTxxLs+RcsOzFQLBGkI3JQGj+6XBkpUo1Rk6cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QdH9g3C7U3NIw1vMXdxZk4NleuLW/52sQabKSu3FfQ=;
	b=cVeUB3vVzCK4YFvA/mRXbo+9KD0+mKJ4S2SVihFb991YTlCCyyqnEiG/2qwZC4f8MIgq
	 wZyBKCfkn1YWP3hwCFOVmgHfg4sYa0soyuHsiAFp2OoMZvKpURRA3LBBl+i67FveeTnf6
	 WwzK6ubKX+kYSdMZc6XHvlrSS2eMWMo7fDh+W8d2CNV4q6ZhNN/Deqkqr/kukhAXDh95s
	 h5QXXrS1OhgQxIaf2+CIi8JpGUR7tVTTa1CUI7TqJtqzhVZcN4NQiT25HROoFKITuRqPD
	 5U/xQwmjwbHOL2mLjhQ3wR2I9B+yFgKuMAyJSgMXGtB2J8A3icYnRu/Bh/4r5xJMaTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uq6FfuxP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30586606A332;
	Wed,  4 Nov 2026 22:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uq6FfuxP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF50B1F000C1;
	Wed,  4 Nov 2026 22:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831695;
	bh=5QdH9g3C7U3NIw1vMXdxZk4NleuLW/52sQabKSu3FfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uq6FfuxP+hNF9DJuVmXXzr558Uaiv9JDQm2DJU4zLz26Q1MxqPwCu6TPdnUuJ+nQm
	 aHEm9L4kDmlvl3InPEsekJCoREmdSIUcwdzIoiaW1qSV00ZzEfM1pY138iQ86LEaLJ
	 lzfzOC8E/xeOd+Ea0FGWyw/cgh3AuQdv1zKC3FZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0860/1005] xfs: only written file data blocks can be shared
Date: Wed,  4 Nov 2026 16:09:53 -0500
Message-ID: <20261104211107.369824120@linuxfoundation.org>
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

commit 634b63baf05062988456a0bd5df2696c14ea2949 upstream.

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm


