Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051797;
	b=TRBHGmSLQUvmFGPbIfSaVVIVSmFZT9JLO+QEUmPfeadBZ+xur64LY5EauFYx5tDnwZYS
	 OQaPi+MqkxTg/dFy+IgudQtUWEMSf+1hXV8DBUgFN3FoAcmivoHSMKbDNtOM1N/0dqBD5
	 NYr8LunL1aHnslfMdON/4OHLqnHmeaBs264hFRdBlDFAHtwnFuc8gRe3qFZcw/8eAXaip
	 VATShB2I8cFJwJcEz6YdVQZ/vdUkSUBQcj25S3nenP/Oa3esAvMQP+gGSMc23oUyLdWqU
	 +VgVi833Ues9oxkkcuvy1M1YtbryzWHiODsj2K34AAUyk5jqO46oRJufiwO7TXxCKqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAULvv/i1uY+hDJxUa7uP7TFsDt9r1fTrz+WgSalyng=;
	b=DPV4qfSn3P6KgO4ThVKAz7YHzgkb69w6DdK+at3VtIWEvZPIKo2n0lo69By9+1Y1vIPp
	 BFlTDNrkRNYsNUw4/6p7/McPIgf8QT6ZBdzht1s1629OV+k+iNt4g5HniDHxURPCqSnTc
	 /5aYFtaZ+k1/anHjIf9s1BiswgPN8BlPu263l7g78wLKG2kZbLPuv+IpNFxpC39ZsQVwF
	 1wYTaTDUdxZKCvSOBsaeeRBGkYCaUfUfsZY24K7GV0WORVBRthIP6SuJnCYiYrc4urcJ9
	 HKHNG/iBcqx4F1XgdpqDeEKFULHiAT05VysUzXuRlafR7SQBim/bUR+H3kERZj+X/MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwPIEiy8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2760606A32F;
	Thu, 19 Nov 2026 01:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwPIEiy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8651F000C5;
	Thu, 19 Nov 2026 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051797;
	bh=OAULvv/i1uY+hDJxUa7uP7TFsDt9r1fTrz+WgSalyng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwPIEiy8QA7YcCp+uizQZJCBNvDnbke+W7gVspy1DUj3kuD1yiJlqp3SkQZ2ZvEax
	 sqXHHW6Ds/sqkBoYcGmHCJVudn4Gt8mZZsDKI6/U7eizuEQXhUbyp1KF5/W/sz9E2W
	 i916jFuyzCqtOSlUlRbt+M43KNwcZ9rJDeN46Lq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0336/2214] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed, 18 Nov 2026 15:33:32 +0100
Message-ID: <20261118150023.944092519@linuxfoundation.org>
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
@@ -487,6 +487,17 @@ xfs_attr_copy_value(
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
 	 * No copy if all we have to do is get the length
 	 */
 	if (!args->valuelen) {


