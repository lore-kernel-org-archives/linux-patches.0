Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828928;
	b=YuFELlbvir7USkF4HJ43keovZKHGRaV8m5/mJUnTiWroUTYvLa5En39ICPbZ+yTNwgI+
	 buus7t9IDHn4GXXpS2enLf+p8cQ9Z+PlIevYD+ELt/+Ot+HTKvwh/BPXr4Lnt8DBgOgZo
	 H+ZbgoEI/w45wc8BltCk23oNBNvPwgLXzrRMjWFI0ZEkRL2bknxBEzGjWprbo6s4sXnlr
	 M/KWU0/EMmi7TgxWGsqz9dIrS6qxCD3+6TA3+q5wvZXUPB93ZuaE3bnp6HB8b6ILe3mvS
	 qEKUiR49gtZ5DNjoA9tRkZggw4TRaw3f0dLUDOo3WfT8YGDGIZrkS48lBnTeEgFnBuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FUQ2pZ7rKP1S+bh+RPTT8obQ1kIp4Z3bjhxbTz+d2dM=;
	b=DoPbBTDZ7+B77HQRBO96x2PbRWj5ZOOtVFgDm1IZRIAKf89lHSWXIImMJAP15zscQh7S
	 7FoBcSrVQBin2ILJzQHWATQNnfkLp/x2yhKL83svG52O1W2MhQJ0JQXWXOilQpB0JSuCl
	 F22IbY0i3Gus+niBFarB56cnSKLT2Mj0dCHwZi2DfT66sLGDy0kyFvleHN2f/JTmMbtx/
	 aQ/TndEvPcBDx0CKYi1gJpoeBc6sH3Tm27khuNWsZakqF63wS4YvYt1RAAIwlNVGxERM/
	 kwt2KKO7FwpxdAJNL65Le3VRXyX8dmJIBOKeojrCqCJNMTibthgMTkf4DAzAu4b4QIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r/HhsOsQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85E606EEBE;
	Wed,  4 Nov 2026 21:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r/HhsOsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A531F00919;
	Wed,  4 Nov 2026 21:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828928;
	bh=FUQ2pZ7rKP1S+bh+RPTT8obQ1kIp4Z3bjhxbTz+d2dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/HhsOsQ5sGzeifQBCaulfvhVEYyVFvvrKr7ixn4HaKSOfZDut/6L3RdIUZVhhZM2
	 2xGIAgXCUPWnA3XTejVsgpbE+Ekyd1IpWphEYhhpsJiDuhCAeYwtUn6caUKRbJow8o
	 jFhI/sbLVb2WrqkgWo3OOvgWTxLIcrOcRDGbwyRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 332/547] xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
Date: Wed,  4 Nov 2026 16:08:36 -0500
Message-ID: <20261104211047.662788335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 436ae68743a6974021fefa21fd3093d9bf8e66e4 upstream.

LOLLM noticed that xrep_dinode_check_dfork doesn't require that the
inode has the METADATA flag set in flags2.  Add that check.

Cc: stable@vger.kernel.org # v6.14
Fixes: 702c90f4516223 ("xfs: support file data forks containing metadata btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1014,6 +1014,11 @@ xrep_dinode_bad_metabt_fork(
 	if (whichfork != XFS_DATA_FORK)
 		return true;
 
+	if (!xfs_has_metadir(sc->mp))
+		return true;
+	if (!(dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA)))
+		return true;
+
 	switch (be16_to_cpu(dip->di_metatype)) {
 	case XFS_METAFILE_RTRMAP:
 		return xrep_dinode_bad_rtrmapbt_fork(sc, dip, dfork_size);


