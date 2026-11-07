Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061669;
	b=lf2TqkpmkYRPGi8m69H4EGQz+xgTIZDMMCwpRka6vwzuBlvewfGP0DqF0zetWHtW33Eo
	 gd6+R8YWWLm3xOYvBB/MP7QBBbbmNCe1BBN+N+UMnn+c1YdoKi9ruIx5BO4cs3ap/wBoq
	 7qzOxbaDscG1dteVLiC03vtmTasqoMq3P+MhiOL3LR+BOZeF4ydRtMLau7hPJLB47RH58
	 SG5uQVkf86s+CKFBFcsDYAt1JTrXqjca4zJvEslrDtpghC6hw1+mmzKMT8/duLTCvZ44B
	 5ISA/PcIoc+2QIKawZBk/a2GNVdzmQXjjWB4xuBcoEyXol6TCYNUCXd22s927vK8y6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bC8YmRL6DwWM211k9+6HEJsusW0uis72e2WBMQ+hDGc=;
	b=lndHx0PulQnt3ve5BKmXET4jQ6Lytw2coj9tR1qGvcBOyRswy8cjBtpGAs98ihpVHo3Q
	 86eK0C+HJG3gpJbwrjQ3yDead8/5cZhxqwzZYUBp19QanTNyOIBbN8XGfQynxYhHTBYyY
	 17/G255hYuqZyk7+olhrJzPt+f80SrItCDVsQwx18K47uQ8w0LtRrwVqsrEBxXaN9PIKr
	 GUUifP4JD4yLrXABhSEw2CnVa62Y3k3HAPCFHG1NFbeamLm1J4YT1vSDw+vQT8Ztlbp2Q
	 50YefU9EUK8EbHS0ATrrU89Xl2MjhJbP7LZJrDT7hJBWu3BVKwGpee0zEoKMmK7Hnkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhghB6Ff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0E7606A32D;
	Sat,  7 Nov 2026 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhghB6Ff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B901F0089F;
	Sat,  7 Nov 2026 14:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061669;
	bh=bC8YmRL6DwWM211k9+6HEJsusW0uis72e2WBMQ+hDGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhghB6FfWbWyxUAQOvCglpZKWzYvdIEs2SDbP67tdJZcLDz4f39WF+2ylwNtdL0GD
	 XIfVxzK/NcYpcBg5xjwiysxcx0y6ceqTHtn5T/ZsFBcqddhX3OygNEXJvJ0z5R9HmB
	 PTiIw5QL7Cq3DrLi09vs1gmo9fVNtGcOisrceFQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0724/1536] xfs: reject remote xattr entries with an out-of-range value length
Date: Sat,  7 Nov 2026 08:45:40 -0500
Message-ID: <20261107135017.833275572@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 15ccd92a782a0253f4a17895f3d3f71e5c1d1973 upstream.

xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
the verifier and the CRC.

That length is later assigned into the signed int args->rmtvaluelen
(xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
-ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer
then memcpy()s a full remote block into the small kvalue buffer
(xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
attacker-controlled content, from an unprivileged getxattr(2) on a
mounted crafted image.

Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
the leaf verifier, so the malicious block is rejected at read time.

Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -296,6 +296,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


