Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035351;
	b=lmjzGw0MyOCoFw+NZDnD4Kd4ghxoVaT7UH7XVa7sEaXmxk7HyDF8VCPSEAqdsVxiCTMo
	 qy+yeX6FSob/vcX+MyTMIaxFfgN8tQvN+EZvUHhPQZRh0WsRyxfMJJc1gcIG6Ne4MuraB
	 k2PrLn4sdmJiVTRmE6OII8MkixWCBnQ/AEHjiC3bx9s2uLKxh90N+Rs8g1baxe6RFH5yT
	 Sqvty429O7OxB8sOY+mxygpLnRLG5/tpFiKH0RVDeU3DzZEe6cScHhNhFe9MddfYOIN+M
	 s/0nLkFl/QLQzYyX+4jrtt23qZmiuAQ1HSNOh7OIlivT9jQ0VRRbd6omWOICDo4OMFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzZN37ux+neOkkYL2TeOZURn9bhPC+5Z1xzdCABEJuU=;
	b=dJnLj7kxJXhhFGaHJKiARYeoFdqWfF5TRpBixX89l0vPVO8Qwk4zyFatoLyKWEUmvQFk
	 hOEBE0Ch9GHrZxy5giEDmpk+ZF4P3tVvTzvUxRX9tx1OEHAvs/p7bbZTi+VEBcNAtKWqH
	 WvwsByhpCEXbCEHU8bg+5ufehjeQAQmjmmZVFbAVbGXXy2IKols+RFhaca0mL12OcsJC+
	 TVwypQQuTKvGRA40urmWYIGn1imTFkTE27g3itdvd+U2QFLAKvD0ibc0xk6R2BBQchF86
	 Q7yG9YBy81urRqG5cILo+V3ZfzbD9h7LhigyC8BdPxZFMQyIqpj2Updh4fD11V9qf2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLK+QTGC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E7B606A33F;
	Wed, 18 Nov 2026 20:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oLK+QTGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DD11F000C6;
	Wed, 18 Nov 2026 20:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035351;
	bh=TzZN37ux+neOkkYL2TeOZURn9bhPC+5Z1xzdCABEJuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLK+QTGCuzWvbxURQSgRR+zKEglQEFT6qYdDIPM145E2uicuYJjQkdjs288P8vweh
	 P7Xe12PpjJsyCSnSfcWmKi9RBrJgdchLhakV6/2sueNMfb+ruhcK1JGptVBIYXAl8d
	 wwSRAncyFSPwMwsUkejzYf/NKSmalUQzI5Y2H+7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0672/3318] xfs: only written file data blocks can be shared
Date: Wed, 18 Nov 2026 15:21:34 +0100
Message-ID: <20261118150338.295180543@linuxfoundation.org>
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
@@ -117,6 +117,18 @@ xchk_refcountbt_rmap_check(
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


