Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057950;
	b=Tjqky3RsAIH0va+lwv9e6+RxEL4dvRAI+NrkyCDp3351zArR6S31zPqIXHf/Rc5ZYLI7
	 0JRopdiR5l1FcysLrzt9iPNg/BplrdmZgqHB67qNDustNFPvvvtmSF+voYQuWiMBIFpDk
	 dBnaFGRiXdcem3Dw0kin4rqKRDNuJRNv5V0Oj3ij1NBP6tyyqC7VZPlr1XjfFDiZH3U8G
	 qLlvN1FOGIFgc/Mu6iRvC2WVdJTNq+aUTCf8GnLx9D27Pr4v8utRL5GvRwJOvlT9JjtkO
	 Ni5oX78XvNNKOX6zMTQOGOb5znf0wg3CRgAA22XHO3GpR8Z+Tl6G3/TgB75uzgB1Bfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ysAJPteKjKS9CXq+dmaF3ytdKv4q6Wik9JcCttoF7bg=;
	b=zLg+N1rqxO9u3UoiOGVbyHD6i4SzwNJfOvbgSLJWuCsONCnLvZKdOgIXXEBFR8Hn30Ob
	 +LKL5FOUfV5vKE+RZzwvSW/5A2HufVF+mZAASO8a7fHAXg7HMkBRD0dm+YXUIjkzzlBTS
	 J7H391onB8wi91bx0sxsVnxNPUANUq/ZKhR5nt0Ja8sQe7KUU6llT3itrsNCjBYQmv9EX
	 n0dlfIURgS/Y64T2IJ4DkUcA8uHcMfm96eaRYcHpB2EmPhV1kSCWTHhJxFVkt2pCofSG5
	 msaZOms+Mna0vOnCHPxt4vBJCj/vJCGpQT5xal2YkgoS17Aq5Z2TDzqvWpC4a9+B55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q1Jbn/MX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E583606A320;
	Thu, 19 Nov 2026 03:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1Jbn/MX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA261F000C4;
	Thu, 19 Nov 2026 03:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057950;
	bh=ysAJPteKjKS9CXq+dmaF3ytdKv4q6Wik9JcCttoF7bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1Jbn/MXxW496aShisSpQtZ260gd/Ipr5Wq90dkS1Ni28DvzhWgT6sB4RG/I53DaL
	 m8Orgt6dXch19ce4z3dxEB6aYLHFgvTxOx44c3aLBVAqdT+CHaU78ECa7k/spCOjfN
	 gaqtFCZxbO8bdgJeTKzNkT1g9E7olsWKaMeAYhOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0271/1848] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed, 18 Nov 2026 15:38:29 +0100
Message-ID: <20261118145923.634073784@linuxfoundation.org>
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
@@ -433,6 +433,10 @@ xchk_da_btree_block(
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


