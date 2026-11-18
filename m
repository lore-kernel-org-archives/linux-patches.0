Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044471;
	b=IY41AHR1NkBYDdprmrs09NT4k67DJ8DdZWOx6WohQ0RP0W8pyUuTiZQlCZyWbo+xoIIM
	 uBtcoIb2ibSA34+xOVe4owlzxTuzU+KhstKdC7y7amvrAgnEdXGxNl6DV7BAY7yp43v2y
	 BuBxBCH/EKdCBAgykgRlcqqxiM2YxBDTMaEVepaLmliPu2e0NCBqbd+jebA7COhxe42Wq
	 VBhto3gIDz3QGWFDTAh4+KjmHweqcldHQR3DPJv7EFal4PJ1O6LJEYYNP1h1J/J33POsL
	 2FfT4bVm29KIGutWbGPRAZI6p0iQ8tjrr2a87OoD4zsiesn0mMefsFdc4tWrGLeq33w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4VIwW7MO6AxdlXvb9tFXiJK4gcOp0JF1ebrFaX2dqM=;
	b=QPIoxLGAOoZKq3ivyN36MF3jJjtm+J/F24YxceFFmYtJk/IzY4qiNOTFMd/Y7DOSMvd9
	 jZmZeroZndPy0N2IxoHb+fil8o4uSG6UwV3HdSdiNYKVGCbnpg0Z7iqBJVgpGbeNz1SWy
	 jYaVuBk3jLq6EylgPqQm8F0GRg4Yr0j3TAeBjuvU9fQLdDKUhmVZX4ZHjgJuWHlebQdd1
	 xAxUm3KJcCCRGqzTB1e/LqaC49ybaxIVINRxdXmjVe5+/Y8ibGrNx8LGpJiLDIh4RvWeh
	 8SSzElFyp3QXRq/TUjHvAnsxkU5KNWQE+tn9EgOAFoHOwFyDSMXXfIE3ebvhX1Fct5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfNuO6ip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA48606A31C;
	Wed, 18 Nov 2026 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfNuO6ip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBEC1F000C4;
	Wed, 18 Nov 2026 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044471;
	bh=E4VIwW7MO6AxdlXvb9tFXiJK4gcOp0JF1ebrFaX2dqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfNuO6ipWF4Nry/9wmko0t0XcBoEayfU737DMrKfTLWahxqYMav3SR+ir3cAYW9E4
	 zmGRBkwZzVbQVCuRav9Nrh55YXFyzxmTEJYYMYQnDk0DJCZOgSwH4CsSp8bgfaOZEd
	 I3tgmCwO761Wiormk1IHiSNGnwYyuVKeu7ZGWOzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0580/2857] xfs: check fork type against dabtree block magic number
Date: Wed, 18 Nov 2026 15:26:54 +0100
Message-ID: <20261118150222.366562915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 43030b72a11a532e7e3c21ac84a8625425b4201b upstream.

LOLLM complains that we fail to flag dabtree blocks that should never be
associated with the file fork -- data forks can't point to xattr leaves,
and attr forks can't point to dirent blocks.  Add the missing checks.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -392,6 +392,10 @@ xchk_da_btree_block(
 				XFS_BLFT_ATTR_LEAF_BUF);
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_ATTR_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -401,6 +405,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAFN_BUF);
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -410,6 +418,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAF1_BUF);
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;


