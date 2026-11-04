Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831644;
	b=4hX+2WetVM3RfYyecVSIgETh/QXcpoedemfFL4fme/4nchVIIUKalLqxj0PVZrJRv9BK
	 Mc3sS4PyI3UaA+hZX+ccZU61Typn8/N05kqw7M0qy6f+0CsJeFqSOmJ+0T0fq10n6Kyax
	 Bw2zs3MhlxiPi9P06wv+WrJkradiSKK51YjOUZV8sE/LGF5aITBOPzdX+r5nhdp4VAtkO
	 VRY445pi8OxBpDkzmWEUVRX5c7m4OVgqXRJZ0iffOygt0UReSFoEboXw8K1ZIn+jIF688
	 PywbZoMNDMPGLnYJf5ksT7AQppqlCobphY50iEvAg4XC3CK9oRCTacYDaKZs3pI3QaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r3qd0OOYX024RW9i8VMi3hegVTz0jb9ks2bBe9jZ6Ss=;
	b=ivEMSElnJAcNuPKanbo64ESRba0QCbQNAQyddR18R/8TPcUb0jccLp/wmHg0EMMw+KvL
	 vxe9PYnS4rX74MR8ayjkbszvWqXFbLCJjHv1v7udZEme6XKvI7ZRranT304P0u3zFS2nv
	 sI47wo4Lj/KUQk7T2ibwDNVUUlmbGJVqpkzCRolzJ+oT1T90NL8RTOPYoaTbvL9In/wEC
	 llqL54aKPvc7p18nAVrB0igv3IhYLlUA/IFM2iutdL0+QpOJan6lk6Tzqogq//+vPzK6k
	 jxr2/JYOFd+BQmGV6qhUPT99fy8rBWDxtyraWjsvGix5CbLCHjL5ywI/iv7zLrBQSaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seVB3+oe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96005606B2C6;
	Wed,  4 Nov 2026 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seVB3+oe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1AA1F00919;
	Wed,  4 Nov 2026 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831644;
	bh=r3qd0OOYX024RW9i8VMi3hegVTz0jb9ks2bBe9jZ6Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seVB3+oeSmuw2J7dEuWhQgZP7vqzTCPcLfkARFq9RjZAhciCWwpPX8qE1BxNkozpC
	 TpDzEgAcwlt/0qrOT2ZE6B7GBXJfsOVBQ6lJhOz+OJ38KMIIfhM/14LH1gD8vcyRcK
	 91eJCuBY0o/9aSqkLHxtgG4W4rCJhBn4sv8GaV1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0829/1005] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed,  4 Nov 2026 16:09:22 -0500
Message-ID: <20261104211106.552380676@linuxfoundation.org>
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

commit 0643549ffecaeb716c0b75590a9b76dfa5eb35b3 upstream.

xfs_attr_copy_value() takes the value length as a signed int and, for a
remote xattr, is handed args->rmtvaluelen.  That field is filled from the
on-disk __be32 xfs_attr_leaf_name_remote.valuelen in
xfs_attr3_leaf_getvalue(), so a crafted length such as 0x80000000 is
stored into the signed rmtvaluelen as a negative number.

The "buffer too small" guard in xfs_attr_copy_value() is a signed
comparison:

	if (args->valuelen < valuelen)
		return -ERANGE;

A negative valuelen therefore compares as smaller than the caller's
buffer size, skips the -ERANGE path, and is then used as a copy length,
leading to an out-of-bounds copy of a full remote block into a small
getxattr(2) buffer on a mounted crafted image.

Reject a value length that is negative or larger than the maximum xattr
size before it is used, so a bogus on-disk length can no longer slip
through the value copier.

Fixes: 9df243a1a9e6 ("xfs: consolidate attribute value copying")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -582,6 +582,17 @@ xfs_attr_copy_value(
 	int			valuelen)
 {
 	/*
+	 * A value length that is negative or larger than the maximum xattr
+	 * size is on-disk corruption.  The remote value length is an on-disk
+	 * __be32 stored into the signed args->rmtvaluelen, so a crafted value
+	 * such as 0x80000000 becomes negative and would slip past the
+	 * "args->valuelen < valuelen" check below and be used as a copy
+	 * length.  Reject it before that can happen.
+	 */
+	if (valuelen < 0 || valuelen > XFS_XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
+	/*
 	 * Parent pointer lookups require the caller to specify the name and
 	 * value, so don't copy anything.
 	 */


