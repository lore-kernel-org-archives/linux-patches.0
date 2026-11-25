Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625430;
	b=mxbTzzGAq8iFp2xLBVT/WlUOiq32elXTPUw3gjGpquDhF3whiT6nGULPeGGRnp93BG66
	 KuRnpzODRQ/KDGlBaBFrVIECAqi25IOmXque08SMi8AROkjzXk0Jtnv3E+ulPmbKwB4Xo
	 GgsNTYx30DSyYTm6QroIfyCgd9kNefhl2EIm0oTsyPrfRwHPcH7pTlxM8qo1wv+nF5Vfn
	 3Zyj5rB+F/MROgPyR2g9mOnm+u/KdhL8z4XVvyNvxSTwKtxVZryxE7oVrshNjhnUp4P1g
	 Gf7fwMs5NgB3E6KI6ZvgXACr8BRA1lkFYVQ2MjaXNJNzwnRcitSE88iUGRus9aP8xcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i2E++x7xDBV5fXuOxCfbRZWOx3bygB9vlpVPCqGqgA8=;
	b=nMcdwKe1dkBK99p4ByXwtDnU+WV/gWIP5zCXTU2WiEN/g0/a96rdKO4rlYFZ+fdsuAm4
	 fkSKTG/I2+OpmcbPa8q5TiFnxFjg6mmAGvlJZ1FZGl1Y2chbHJk9I/UQFizZllKiThj1i
	 p5AVMyZF5i2Pe/1OjQWxhHHznE4bBuzw5gHxrcyF1MM2urHPlsL2wlq5upg/V3DAdT71x
	 e000hDqkJicZj34C4DnSQD4Uxq2yQYJY8D56B82Ai+JfV+D4we2rydObSz5VtTuzUhbvY
	 nWkQAWoprULd+/JoqiMVbuRr3JC2/y1w0PXonT2MPbrjTmZ03xqGn12tamAPPWIoCsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMRqMPJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0777606A326;
	Wed, 25 Nov 2026 16:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oMRqMPJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB9D1F000C6;
	Wed, 25 Nov 2026 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625430;
	bh=i2E++x7xDBV5fXuOxCfbRZWOx3bygB9vlpVPCqGqgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMRqMPJh1iPwxBWKvVBPRgLs3YJ7rcK6x9sBIP+ZerEWWYx8XtKox/289j7UV8S+b
	 Ipm1L+D80I4rWJaDkfpRLUkduNuS7eIdc7nuboNZTqeEypUxJ1t/5g1qUXifYQKwJZ
	 ocOuuxsHTqX10ySBfasp4VLAxIh9/5FB750Bf/yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/816] fs/ntfs3: check return values in indx_delete_entry()
Date: Wed, 25 Nov 2026 15:33:37 +0100
Message-ID: <20261125143900.057525337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Dmitry Morgun <d.morgun@ispras.ru>

[ Upstream commit 131f7d7abf0f10edc6ea6b032f8a3908bdb13ce8 ]

When the index tree collapses down to an empty root,
indx_delete_entry() calls attr_set_size() and ni_remove_attr() for
both ATTR_ALLOC and ATTR_BITMAP, but their return values are
overwritten by the following call without being checked.

In most other call sites of these functions the return value is
checked, so add the same checks here in case an error at this point
is meaningful.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
[ sashal: adjusted the two attr_set_size() calls to pass an extra trailing NULL argument to match the older function signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 97cbe176a83e5..88a5f336d9040 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2691,18 +2691,28 @@ int indx_delete_entry(struct ntfs_index *indx, struct ntfs_inode *ni,
 
 		err = attr_set_size(ni, ATTR_ALLOC, in->name, in->name_len,
 				    &indx->alloc_run, 0, NULL, false, NULL);
+		if (err)
+			goto out;
+
 		if (in->name == I30_NAME)
 			i_size_write(&ni->vfs_inode, 0);
 
 		err = ni_remove_attr(ni, ATTR_ALLOC, in->name, in->name_len,
 				     false, NULL);
 		run_close(&indx->alloc_run);
+		if (err)
+			goto out;
 
 		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
 				    &indx->bitmap_run, 0, NULL, false, NULL);
+		if (err)
+			goto out;
+
 		err = ni_remove_attr(ni, ATTR_BITMAP, in->name, in->name_len,
 				     false, NULL);
 		run_close(&indx->bitmap_run);
+		if (err)
+			goto out;
 
 		root = indx_get_root(indx, ni, &attr, &mi);
 		if (!root) {
-- 
2.53.0



