Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051800;
	b=qneoBXWQErlRpXVqClI9lof+j5Ch0tAfX33TuLIR+zy27zO6MP1YaXFV6JiRriMrWof+
	 2nXMCV3zdXbCmCJ36gxgSP3+Qf4ejNQEoy5aRY8bWsTFedCkGLLUGOru/5X8UWcBRQKVk
	 7bMPfMUAGhC1M8mGPPxe2/a1oj5oG7eYMhs8fUVpqEpEuuttlV5jPUZGb9xO3LPv/e7H+
	 3/YxMZk2zgqXgcqT+q3KEp4nS428Eet0l2w5S6SgYy30SRUIUH1IwedF9hqgYlVs5RQ8t
	 E7er3J1MRo/YRkVGbHvJU/GLrV9w0I+en9xgSwdHaLA8IpFAbegxZQ2BosclCVCZhyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpoji6WlP/pUoJCZIjEVF/d1uzvZUKNESX5kmsh5nJM=;
	b=WiIZF9vykZ1He45zQQfABjBsnCwDkFmJbHYfmnLegKzATa13mV7YofPBpPuL/Nvx26Il
	 zDH29zpAXJiexhO2wMCmTSXlQW2y+7vP1ICjsZzAFvdhJ3pic3NzbvynS2Te/zk+jwRlq
	 UzvIv/zdj1ebe3p5i2pPlL2yonqLLk73718F9ZTf5/wdGYEbO9+lqAMGj4GuWitEV75D9
	 uDlJidYv0mDPO+kZGIv3Hphehwye7r16oqHONP0py1zdIPP5qMnsuZtFnJ7SpA5m9F2Xu
	 5sWMCFPLKVaxm+0Km/BSRjWLioNViOANHCMAdwBSzig7o26yZ3WhbVwbq/sthvv/Kdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqYhNGY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D84606A334;
	Thu, 19 Nov 2026 01:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqYhNGY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76A11F000C5;
	Thu, 19 Nov 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051800;
	bh=wpoji6WlP/pUoJCZIjEVF/d1uzvZUKNESX5kmsh5nJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqYhNGY4/3hkSs2zPmgyeNsAIPGB7RQ+yEmPpOd+o9RvWGj+XGhLpbL3/+lHdQqrz
	 fxLVoKGiKE/JteA+YQEkhYUK+UKn+GvNlEb4vXoz/yUOFQaucHG4miwJ75Rf/zWVRg
	 DGyY2FfFymbxlVXxJF9e8MNIimSok/ySlkIfxMiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0337/2214] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed, 18 Nov 2026 15:33:33 +0100
Message-ID: <20261118150024.001331657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,6 +294,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


