Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831674;
	b=ClAyXOT+oMMx+dFPCzd2YsTMM4g7eDw6q/d+vhe7F+QBd2TpYjp6ahi/HnkdvthkSRh1
	 wJc9KrdcUuX9XdxtJ/DXZ/pG/dcMfNz+35MWEvqrEt7JZQIhJ0/gzqfl0X3Te3wlMblcD
	 27rBNu+2SBbxKqGAfD9RooKCX2Trgt0Lzo+2HIyAndJ2bphodilx3GffiSi85g1hXGIAC
	 El9I5SE9XUMBYnJUl+7XHp20Y0uJePTmOghbzl5Pc7KESTw6UFjjXBxmwR4a6pcbwqdRM
	 Tka1VNRU8SWS5yY4Kf0yLdYSMdYLckNjjdHTL+LyPENa/3p+NeFrLBmrVI8NbPnbcrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfZf4PFLG8bVoRTCc35B27N52rVntH64T0rYQ8tqdJM=;
	b=5taN5edpqvx73JUqJF12H7T23NXIhomOsBkmB6/qeoYlQTYjLdGt+m0BlukH8Q87g92w
	 NFwZukiBhUsN1vnpIsIp9wkqvDmErtLu9TX3opaJIA5flgoupphfiDcOjmF3ndFpwbcNg
	 pFyCxcbwDEuMCSGd9cu1DytKbWMsUoUSTv5P2Be1ivz/yI3lDHpn2FoZ0SO3fTJxUtUT5
	 /yrlFM0GWVocXJIfQWadUWxCzDNPNihbT7tb4qUROBLaQ/fSvTv4dElOfFs62lYyEIu6T
	 cWtsb4lsyHAnHZp6iD/FWYJj5GLyT2OpuXi5IMFt7R4ASyE6fDmnfuu+4kYlT7Fgggw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6A+ERqu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA6E606A33A;
	Wed,  4 Nov 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6A+ERqu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4384D1F000C1;
	Wed,  4 Nov 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831673;
	bh=RfZf4PFLG8bVoRTCc35B27N52rVntH64T0rYQ8tqdJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6A+ERqu2iRLxegEodO9w9C/eWLCBFZZIwBewIlRIcOguevN5eVjYLSLgV7uXz8Lg
	 edm8liHZuGaDlnRmonCL4WEMZ68LB/Q9p65tCDZjr1Wt00QvuTzKNImIhMLuh76KJO
	 yTWp+tWDDyIASpHtkK7XUcFSo+JsLTopWy4Q0r5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0839/1005] xfs: bound da-node entry count against the correct geometry
Date: Wed,  4 Nov 2026 16:09:32 -0500
Message-ID: <20261104211106.825157558@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 3df5e5aaa3bc0913236c48ab29b7df3a785aa29f upstream.

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1787,6 +1787,20 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 


