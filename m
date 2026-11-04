Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831565;
	b=S3FOplDtY1uyZNwpGBa0RMckZn2hmstpzQ4REa6Xt6MSA3pkABwVgaTwX1IxRyZo/SWx
	 3t67RwWZ4lxJ9Uhmm5zCOfsyy13aTgGVrHIJHjl7c0WLeViZ1wPXRnTFQgSsXtWCV/AYK
	 /+sIxNNLLd1zqydI4SEGCbdPBWUYE739lPozPLiPy6ARDBSEiZ1uo1kJRWGBSPvnpwnaX
	 mRhXbIJIfIGEO2NXC+PpwWQaO2zPA73pcMg0ySP4mMVjNZakitznIVUgrj3r+BgJUkUf4
	 vBOUVUhnKLpUjUWYogABhxCAzseiGXNIIQt+a6lBGmpz72/h20LTD7r2+wbFjolNBpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxH7lqaI5CtIGTdGdoRsAJeJjgATSAtsyg0yZ448PuA=;
	b=C1x94gprNKahc7+a5iiZn0NuVMntDbKzhE47mrwoVSEkp+Zh2Zp09kiwn3QbZiBItQKo
	 RkL2xAUv6Q7s5LI+IuIVrLpHz5+9Bv0+Co2A0mfzg20eKOrwu6Xf4mS0tymmcg4GmR/os
	 34taAuNSQm2r30GDgiKfNCkoVVOnZf9HhvDuKhfjxrqI3QOe8VQnbAJfdOHA4AIA7FyaR
	 CDLKaU0ZT7KXGStYM8E4aV+0BjQQSBPmB36DNoXDCIM1cXj8daVU1cDowoKA5vAip++bK
	 GMHPDIhhBfCjYP0blOlwRxPopnp/dJCsKTA4Hldb/JFaGxJE58O+ym7+bFcOpO/DBPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAldFcVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A1D606A844;
	Wed,  4 Nov 2026 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAldFcVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A61F00A02;
	Wed,  4 Nov 2026 22:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831565;
	bh=XxH7lqaI5CtIGTdGdoRsAJeJjgATSAtsyg0yZ448PuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAldFcVPbZwlbMCHcc9XUNw1QoElQPlMudvzCTVyRKiUP2rzHB4yMQdmGN6T/zgZH
	 8g9A9ShHE5D2M0Az/cuz51Xm7y9gqaV/S9+7xstxk1sKa8xjRdTtgwJc9dZMl2JuPD
	 0pCFeh9PGasdEqSJtwTr4Yxm3IM/kIXskQmz9Elw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0779/1005] xfs: fix buffer overruns in xfs_ioc_attr_list
Date: Wed,  4 Nov 2026 16:08:32 -0500
Message-ID: <20261104211105.188052693@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 0b9081a774ee7b9dff1e9ac3765b73c1d6bba5b2 upstream.

When we converted the al_offset array in struct xfs_attrlist into a VLA,
the size of the object shrank by 4 bytes.  Unfortunately, the buffer
size validation in the attrlist ioctl wasn't updated to notice this, so
the al_offset[0] assignment blindly writes off the end of the buffer.
LOLLM noticed the omitted check and complained.

Cc: stable@vger.kernel.org # v6.5
Fixes: 371baf5c9750a2 ("xfs: convert flex-array declarations in struct xfs_attrlist*")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -431,7 +431,7 @@ xfs_ioc_attr_list(
 	void				*buffer;
 	int				error;
 
-	if (bufsize < sizeof(struct xfs_attrlist) ||
+	if (bufsize < struct_size(alist, al_offset, 1) ||
 	    bufsize > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 


