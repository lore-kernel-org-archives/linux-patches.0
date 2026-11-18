Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044493;
	b=FdWMepiDYyq15eSRrSLSIgLoTlvFA2s7ag2dYexKtWpQTAlSxqfjJiDVjbbxi8qIE4v2
	 FjHVg30Yukr0Mqct8/iM8Pi/QMwcqcBQkjVWgvW3pErMOD2yV0N1XhCLRk59YyNNBUhuS
	 G+2OcfckBm1Jyx4t79BG5sdoPEM2reN5VSiJzulrMwdeBvi3M5sLI+8yvBYgdjxwn/gnj
	 v6yisCKUOtEVT8Xio9WKAJkyIKURRuvLdUgLL1gDnh/+E/GPf2B6ZPmJAOtCyoaYsp097
	 wUFwXpcGBrB11UgmyFRty6VzLnsZiUyQ+dJy9ntpLYXcc38MSdbm7goY2OAaFG0TtSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0coT3wumkXuYx7ob76alpY23nxyQpGUK6a4glL9jA8=;
	b=mWQ0uNffpiGN8WrXcVWn/qut1d5uGROY+MJ57YeC/dLMk+JE22WQz3VZ9yZT7CiRyEJG
	 4sKyZh9Z7C1caazOKzvlTAG2satjfRLtDhf51avCfq6K/H+Sc9NnzHLIJVUYsVR0eWyn5
	 orFGyjyNLf/cOz1sWrJLCJ1hXN7CbFKrit4hr/Ab0uVOvCKlSt+goKhqQ3Kx7A9KCyILi
	 UUcmOQSg2GukT81ttMiYumgoilMMwypA1CIVR59W8ESIrxcyM2SMS3maav8J9/KSociuq
	 eURlAuqlnGLTsA7+9CLSE54/k4OPvIRBnSVKeZUREtX7+ERpiDo7QsfKiTqSJK+I8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srxioM3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEB4606A31C;
	Wed, 18 Nov 2026 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srxioM3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B9C1F000C5;
	Wed, 18 Nov 2026 23:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044493;
	bh=L0coT3wumkXuYx7ob76alpY23nxyQpGUK6a4glL9jA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srxioM3tdoqUNqaAWoLjOn96Ljq0q7O36Hiq9LWXf+mmnjOUNo9YnFmv+y0acVLzp
	 uxC4UfwgzfztBEd+VmlEMlEmlbivCnZqF+7T292NrRrLrhNxjFQv3VqM94FUlJKlbl
	 X3cTCVNV0FqD62aYePqji0IK17vOucVAB2gFlyuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0588/2857] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed, 18 Nov 2026 15:27:02 +0100
Message-ID: <20261118150222.656291437@linuxfoundation.org>
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
@@ -517,6 +517,17 @@ xfs_attr_copy_value(
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


