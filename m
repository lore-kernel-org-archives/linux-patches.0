Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034671;
	b=NHEH7OsjjjiwLZN6NIxjDrMa6XSDhHlQcNbsFrF59dC+ffgXKaDp8+Aq4iU78oir2apu
	 O6ew93ohiyDB0evNu1ymgAyRERmgBO8M7uZmhbaeDsPffcIjDtExD9isH2xQNJ5kIdP1+
	 wUA+v4dlFj4QLm0orH+vUt5JCiR2ZkJ08yrWrcGCRPQYbTxdLsyZJtWbEm6l2QxYl15F7
	 vX34wwgRnoW757jXmFrhPDHz4a1uRaAoKFRZkiN5O7Y9KR1qE3nSoU3kBv6guod4+QDrw
	 ZBbJy6jw+Lh3RVIf6lZrBSs7Ia32KkzQWdPDPo3z0agrkKkvqSmrpXjW6dqQhuVFTMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gxaEcuwtksf/tryAKKKJdTYaisFKx6Up26ClQwaEhMA=;
	b=rloZ43feti0AqSAUJP/QFpaWAvw5gB424bYW624B9KW/o2Xcc7ZmAckauiy2/ZfSJ82G
	 5PtdKYZNcnmjauKrlexjaQQUFBmfGQ+S3LRZLRGKRY8FWq+ix6nec74H8ZGMUQILeC+xa
	 cn6i8w9LYv/8ztUv/pwnbR/MpseFtOcbq0/YCqqA7+E4MHgVLDeTaNLNJTaMH15l87A0R
	 PJ9s4OBDINqOWY2B5xAAokGDWx/Hga2Gi6xUcyJIjGFh9eoiY55YpNOM0GGfQn1CPaINY
	 F1hoatiZChRe77wOtUN4b/QW1dst9K1dUKqam1LAusFTW00w0PIONPhNglog6Rs/5KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RziNyNkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022B606A325;
	Wed, 18 Nov 2026 20:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RziNyNkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E202D1F000C5;
	Wed, 18 Nov 2026 20:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034671;
	bh=gxaEcuwtksf/tryAKKKJdTYaisFKx6Up26ClQwaEhMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RziNyNkZN8k6CkaXn9GwvaFXgomTwhRfPZTJUaEyasYBCDpQtF1+LLVUlLCCDWl0B
	 bjRbPBplEStD+z8jFPqqfGrOUtnBzKcxRBq8N3Tc5NazPzwCYXFGIie2kPZunYYiK+
	 OjBtxX/GwK9Mr3LKqtN67wFxoAPASX8RCu7bfkds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0452/3318] xfs: strengthen the "is cow staging" helpers in scrub
Date: Wed, 18 Nov 2026 15:17:54 +0100
Message-ID: <20261118150330.336418393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 0d43368844a75ad13561a1198a3b027940730756 ]

LOLLM pointed out a bug in both of the refcount scrub predicates that
determine if a range of blocks is marked as CoW staging in the btree.
While it compares blockcount < len, this isn't enough to determine that
the CoW staging record is at least as large as the range passed into the
helper.  Fix both of them.

Cc: stable@vger.kernel.org # v4.16
Fixes: f6d5fc21fdc713 ("xfs: cross-reference refcount btree during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Dropped the rtrefcount.c hunk because that file doesn't exist in this tree, so only the refcount.c change was applied, with no other adaptation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/refcount.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index dd2c52807e40b..4407fc3988c39 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -569,8 +569,12 @@ xchk_xref_is_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > agbno)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < agbno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
-- 
2.53.0



