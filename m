Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035334;
	b=EEyiuED7MjevOW2c4ggXjn3cfl7H4Td4wa9oAvCfeX859dM2J2IgBn0082Uj3gGRM4ef
	 mjhT3BCCUSPcU68RG5LYbXknYIMIYVTfZD8Ce2WySacC76/WMWLnLFAzh87SzEoxykws2
	 PSgkI0fzCk3RfmgCXZ0s4QfNn6k2f0bBduq68hFdHe3B2L+6HlUyppKf9DP8ydkcap1l+
	 kJT8K4Sdkvwy8vgcFFNTzfVxF5j1ZBY3XEg9jkFXl5B1n1Jnj0yqVqPu+3VCLWzrPYK/Y
	 046qZ71/wpj3uSm00LtVFmgdefXf2cXET06Fmz4s7pJck+ac6H+qHk+Dhurg7oAc2LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5Em5JZbyS3FyGjsXd9OzFDn+MtzWJJfb8VbobuWZeY=;
	b=X3ff2A4d0e70OUsve5QT5BvUJL/MD1vYd+nMb/hRsiOlnyw44YrdqmzZPGfKSyEvsa38
	 DGpJBwENK9jN0Wsl1j057RsxvrCRXUrn+I+h0ksRtvnKOmiKoppcGJLWwT5G3SHPCnk0o
	 MgL8xq8NX4iR9YNzfEDtR+LYimboc2gHQZ5zsH3HK7YoiOY0IfuOhp1F5ePxduKQnQDNt
	 q51mc9nHSB1LsSa0bC+js1BdPHY3WwtqjWUDLnfBPBEg+w3YZhH17PRdjcV+UlvRd10p5
	 bXF2TraCfOQW5BUm0mQcFe1tb408ml4RsKhljElbaE8evl//1FjYmMvMDAd4G0v6v6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXvpgcRA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4A6606A31C;
	Wed, 18 Nov 2026 20:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXvpgcRA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376721F000C4;
	Wed, 18 Nov 2026 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035334;
	bh=N5Em5JZbyS3FyGjsXd9OzFDn+MtzWJJfb8VbobuWZeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXvpgcRAsCxv2gfj2ZY5Ohf04c6UEshVveLqUiXWSSTPhXTNRAhzrAA29lkY8FI+l
	 kT62DjIRCGC7EwUAl7kaX/mv42Cuc/RtjvJadghZIFW9caV8WWLkDK/aYV+dwR1s17
	 8w7I6s19d6frZdrmajvDdvgs0R61TdqPxuLpu3XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0667/3318] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed, 18 Nov 2026 15:21:29 +0100
Message-ID: <20261118150338.115317761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


