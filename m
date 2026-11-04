Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828939;
	b=geRBV7wgCAuX3TTBG5OTDok6YnI/K7WinCQ4U3Wy+yfVKAWeidk5KoSTp6g4iUR67H8i
	 iZCVzAdUKwMDJHLGXBLY51aaCO3VgmXDSO4hjDDJtwPX//1R9o94ixCvAOP+bSI91VS8C
	 Z4HjXVN4se5sJn2zbqotIIIZKE0gjwyJEccC8kDKKw6ZgsWeQ5mh4mMP0AYTqwtM17hwf
	 tTzUdVKxgRMJa1h3o2Mp65Gq3qgP+oBH6hB5r8w4OCcGUpo2FuF5DG2ElHw4vuoSm3fiQ
	 GMiLppVbzEPPsnf2mF5+kHf98cFT2JGoKLKl8EV0hxng6n1iR0hTD5WDs+iN4/5QkfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0EiOcaNRotBKsczBO++vw8ENgVpJBuog4q6e1eMXBw=;
	b=4rgpv6BBMaEJQpAr2cdYYhD8NGkPVj8WxejnXPnTbogtsaxuXO7t5Kj+kveWBJoc3Tlk
	 9gsynAE7Pnc7p/bTq7Fn8cD2ZuUhizd77budBALu5aUBR1YYpJwWmO+J7gpiqbexEyT4k
	 c1FhPLYey+C5eY75v+RofYIX9VXQXW5NJfKfoWHRY+6qWRKnxrPWi/hnXNmAZMEQvfOzl
	 6hnmPmgpwtJMQE0Oo+XcMqNifiuVaLCBuQT7ZTCX7Cfi1esFNgqkCanlXCJ2FF4pmsszK
	 5zcX85LOI0pKzX8U0xHUxBqexzBegbIb4Y9ij70d804Xc7mHNfRB8y86s6RkaLxE0CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiyAAAqp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E7607873A;
	Wed,  4 Nov 2026 21:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tiyAAAqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A5A1F00919;
	Wed,  4 Nov 2026 21:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828938;
	bh=o0EiOcaNRotBKsczBO++vw8ENgVpJBuog4q6e1eMXBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiyAAAqptne0HMZdQVJ7WWrcH0m3DbOBl+Xf6Ajf0qsyZseiMxPEgERvNHLR0SvjK
	 aw11uE2dnspfc4R7UoyBPKoGex1hjGdH5P3JKGtBzGSQRUCZuftZuE9EK+lS8EHhFD
	 7TFPF0q5p/b/t+LfyQdfYWaWG/FD9jLmpQZEffWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 338/547] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed,  4 Nov 2026 16:08:42 -0500
Message-ID: <20261104211047.833483533@linuxfoundation.org>
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
@@ -643,6 +643,17 @@ xfs_attr_copy_value(
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


