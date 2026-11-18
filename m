Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057847;
	b=AUAP8ZjBIlPG0vqZce/4O+iO9vmMQzRM2kC5Cz+F5Lh1VuPXDs2lycBEC7ysxLccMKG0
	 XSdEX7qjkOJKMsm9Rsp76EzW9K91eodytRY8aKEZFQsAAQj/Xv5Bz2H/MWeboKmJQeu/U
	 sDgZhP6x7ZEGkx3ZRgbwy8ce85GxI0ePR2l0WShoKH7PNZJaPK7o5cFQeBmBGk9Zb2rxV
	 Vr7DnKZCQqizrA9P0oX+aFI/XiVTr32Gb0Qj2tB6YV+Q41cWAC1VMgGlSKYAZODc/j0Bk
	 U3hf6Lxp/e/2bk+57yblnP1JbhNNjNakVQEUQXJfaNuiUmStJtaabnm/NOt0l2QRYsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u2ymRVV0uS5rB/gaLJLXDPiU+1EUqGWEy5FvDGVgYpE=;
	b=aLSZHJ7PNHiwEHqwAZiMNhfQmImvE/b/yD5+qxrQmshZyZa2JWnRZHWD5Aum4J+dvdKy
	 bQ+k8PVqPfENxgY4Km+xNsoNrvDQjTooHaveTP47PckBG023UM0zp/5cIh8NNKgWeclVd
	 Lk2b7BH6HIi+P8LuPaED9ZU6USENAj6P/mawKOzfNnyFrSIRcYfcCqHZVUnlU63SnlonT
	 NdeTgCisrjiRFR67P7UYEPRuPdeS9msYDd2coqpOPLeu7iT8U+zTmS9Js5/RVMXs2zAG4
	 16QZpM6nPQ2wgdr8YTFtbxnxwHJChKaM4NP8R/uv26PPicpJ3rUwRhtcxoccVdGp/fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qegVytmE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272DE60A260D;
	Thu, 19 Nov 2026 03:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qegVytmE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A11B1F000D0;
	Thu, 19 Nov 2026 03:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057847;
	bh=u2ymRVV0uS5rB/gaLJLXDPiU+1EUqGWEy5FvDGVgYpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qegVytmE8PJ3gwxdeDIRNLfF8pAjbjsbyFBAaLWNq/tJkX4QlWYD7EKVWRSM/2r9I
	 ywAqX53B6IQBQR1R/u64ZtDBEbZfQJcMpGX/rwIqmwdlyWE+Y4j+7lO8Mip2WbhSKo
	 Wvjjtd5Om6sYeYOBBDaa2buVNyPHXx1DfRknnxQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0276/1848] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed, 18 Nov 2026 15:38:34 +0100
Message-ID: <20261118145923.790141819@linuxfoundation.org>
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
@@ -486,6 +486,17 @@ xfs_attr_copy_value(
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


