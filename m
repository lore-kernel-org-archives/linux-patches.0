Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061701;
	b=CszeIzrd+SiR5OuSTpor9DdLbaak5QwYODWpYHr0DDbloQUgbLdpx/x5HeG2pQp79ZxF
	 WRvoYKpdhWCilMDSYwOaa6uskbcRlrFGiAMg7qU+5SF+Sxo7b4c7f/QNjDJtzTSDCZNCc
	 jY99ZMDCB+iUug+O6T2Z76I/FeiRE0Z6sVPd/s0KcBerSwGP3qSpa+tgjDhZB7fav/J5H
	 gyspOVEkIrrTP6t5TfGql/rev2It9lQ/sT1j+2OemhQgaPLlH8tTgqjXiimSfRka7Q6Ex
	 fc6O/YHeCNz5IxYW7T2QbMwBqg6qsbplXJYlxET0B8B6LN4Tvd92/lYDQIzCkuHptkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4sBpWmm2ZO1XD2xutTNpAgjvF1SZQyaflhccg0KSVYw=;
	b=I8GUG1oEUALwwyGLYrdUtdjqwiT/wglUtnxBQDzvKTfSdFWOARwXfY4TmxOEC6YI8HA/
	 uEbND8t/w4Biepv/W1u8X3zD7zmiINu/0rtJokXdmj8xWCJ4WXWnd1L1Q/SpYTPHkIbZr
	 fWhg5XIUWQsHH7d7NRAnMqu/RxH5FPZXLs63/TdDRDSBMeFsRI0M79dKQOvZBpoClrJfu
	 9ies72sgDCw4XOJnHgMpFMk1ajWxbOAqQgS5Q8JIGW2CAgI1GKZov4jMrKKV7F7TCe6Fs
	 zeVpQs40cj7bZXdPDgIaGov+gqUhWyZd0U6H7i3mmH8u36BM0r6/FcWsfj6J1O5pQDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAJKhAYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F1B606A326;
	Sat,  7 Nov 2026 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAJKhAYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB951F0089F;
	Sat,  7 Nov 2026 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061701;
	bh=4sBpWmm2ZO1XD2xutTNpAgjvF1SZQyaflhccg0KSVYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAJKhAYgkrIWbIj6sJg25r7MUYzIDgwRrCAEYSOnP9TNsSN6xxm8rsy1B3zOhCNn+
	 N4D9nfu3JDSnXwq7Fl19UwJEjqdfZ6vtnoTLk1GtxY3mECIekIOsHJFRjHq7+QCOBB
	 2q+M3lDzfHnGG8XLg6ku8D0NYytMBVaOt/W98cQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0743/1536] xfs: only written file data blocks can be shared
Date: Sat,  7 Nov 2026 08:45:59 -0500
Message-ID: <20261107135018.395847070@linuxfoundation.org>
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


