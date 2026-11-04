Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831664;
	b=BIrYkrKeUnkqSv4N5eEra4WvmGokhnahQHeGTXRvwvvpRSpUH0sN9RIyzKgaHreQhmrL
	 1qnxkgBrXGmC/qNWO4yxMF9NiFAXrm6GSbeHHOWDItCZ6qTz0EDgV9SR8BBM/8ueHs7hm
	 xjmIYWgK2pYgG7cBSovQYcPg/MwM27lbFHE5hXpb69nm6T98CNxfb+ymz3KNokWW6R81J
	 +1ZvLAw9TA34bJFi8nteMESbP4LSjlbrdLho80i3xTt1e2fAdytSBH2/iwsWF+G27Tq6y
	 eQknjE7qr8qwgGQkiOLPubv/OSZrbEqm/ImXr12LniTXtkPtgTqIogXZ0qGFCXY+3ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YbN4HkLLDH/KvKlxoWPsZC08lf9O+zmkeryu0xpV7jw=;
	b=PjcAr4bb4Fg46VteolI2nmkUF75F9wa4gHnDocVgRBu1HsnkNmEGMueGDWMjIMWSpXc7
	 vmJt6Fv8F9JJoJDorXO4ovSzzy6RjKgVn+rAmHLvntNmbTGbiyr25yrMnf6S5J8kQVfCH
	 5d1nHoIuxQ0n6qP7EvjdOa+6dj5zLIH01ykzwHeANZLOR80k0Yof6kW0vcdING2co5TrO
	 ya1bnyOqysYYUMaVawpmc3TFYzYyZcDd1lnMihUKC3pvNWyKaEZmpC7UC4WI2qUDTi003
	 3aoWWfbt/L3MFAbQhwPAzX012ac6yTyOt2mJjezESASdKLuh5QhyK79FuSWDkkvRylQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2fWl3YR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0C606B2FE;
	Wed,  4 Nov 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I2fWl3YR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6D11F000C1;
	Wed,  4 Nov 2026 22:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831664;
	bh=YbN4HkLLDH/KvKlxoWPsZC08lf9O+zmkeryu0xpV7jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2fWl3YR6Kg1UdNbreJAG9K9WltsAUPsJ3r0yBSX7KGdI+tk9VjMIaNj3Xylin97e
	 7xOoskxS1uM50+RAKzR1lglyPDMbCwXrAUMMKhozD/ghLY8mUa8Q3XGCmVDC/idxCC
	 3nrW6BbRER82agUSUfMue0vODuJtJX/j1eVRb2DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0803/1005] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed,  4 Nov 2026 16:08:56 -0500
Message-ID: <20261104211105.841320699@linuxfoundation.org>
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

commit f61c91a2e5994fa81141d6c06dadae1fed206018 upstream.

LOLLM observes that we need to range-check the dabtree node record count
before using it to index an array.  Fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -451,6 +451,10 @@ xchk_da_btree_block(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
 		btree = nodehdr.btree;
+		if (nodehdr.count > dargs->geo->node_ents) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {


