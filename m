Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044499;
	b=3HOimkQp1p6+gSwKsuOGI1DaeXAWf19sv4VNlUnp9xGkDnp33g35nOWIOTpefNDNL4Bt
	 9XlbQOww34D0DAbyIxTr1j5QL5DUq8WdsDI2IsMAI/od1fZEkY6JUkg3RPAMTwTKXxg4D
	 gt+Ef0yRjWQziEjpJRKrvm1yRtpo0tfSfhV42B+Z2GnTM7Z0SW4H8PR7GLBiUzpkgDKd/
	 2/E4/0zgvk1RtXRytIkANajVycOHwHqeagOKZlb6RQy8ae+QBDMuQ2wXaQ8Fq/xqDanZ7
	 XskJJxQZV+KR4nTMQ38Zx4Bw5+3F/OQu3+XIwc83e+ZyeXCZy0Eeq4xioadPj9z6UaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Thk2hxwbwSBio9L2tPgLjzHrEegEsNkECC1fbVPYc8=;
	b=qRl7m5NkDz8fT7isY+X1pwSxDbUX5fAdPLn357qWgAGvVEMyGF+z3+qREOvUJ0bz1UqV
	 CJmUOpO3C27BZ+m8YkkMzi6gMPwzn1KepNcF1h3zLcZO0pODAFF3b4UkkhrFnLyqiULKZ
	 ulyBDH8sT5K8qEfVEc20Yq7VpRo/1Rj+952F8FdXSDi6DkTrQoEROzyvw4uHUbdj5Q9Hz
	 z9PkbzRCGWbVs1303o36lcG4r2ihQC2bHIWB/mXUVccTde30fL9RXFz67eGDGIxGjRdUR
	 61hWrry3XbqohTHLQWIYpIYmnPbX1+1gdFvzibzTyZ37zfawp3HOn01reVfUYUDIUhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCme4fGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8329E606A31C;
	Wed, 18 Nov 2026 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCme4fGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3FD1F000C4;
	Wed, 18 Nov 2026 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044499;
	bh=2Thk2hxwbwSBio9L2tPgLjzHrEegEsNkECC1fbVPYc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCme4fGQlnEn6ys3L+ySOmGUsWAZVCriI4yYh2/Xe9dshqg33TOoSnjuJTIgc7Mbb
	 naQSQICeuUwvoZeMFC6TozSGTZkGeE+Jd1NxHtbHn23sDZMaor8cfyXkoVGbxsnKCc
	 EySygUxNATeroAL1YEh0p4qvKBRjlfY8JlIjfwW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0589/2857] xfs: reject remote xattr entries with an out-of-range value length
Date: Wed, 18 Nov 2026 15:27:03 +0100
Message-ID: <20261118150222.690675210@linuxfoundation.org>
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
@@ -295,6 +295,8 @@ xfs_attr3_leaf_verify_entry(
 		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
 		    rentry->valueblk == 0)
 			return __this_address;
+		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
+			return __this_address;
 	}
 
 	if (name_end > buf_end)


