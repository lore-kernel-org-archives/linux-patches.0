Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784873AF666;
	Sat, 17 Oct 2026 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256057; cv=none; b=ruOr0uwJuf+0lfi0BoCgfH/5ICEabyUZH8CGoiTt/TTCuSokNWbcc6ZUs2fx9Od1n/1Ww9CxT4n1pOd0SM2edIey5oX3ctoWEBhUxpnQGwCzah+FAZvT7hAPjHflysoWyibgGjY9LU0NUVrPwzqH1YyHKjnf6aVA1+peZdhy2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256057; c=relaxed/simple;
	bh=PU1wcgFUkI87Wy9i3LRFLokmEtiaBPSgsggcktQ1F3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQSWFP3wWwecBzroCDBQeqhtuDDfSEnMZvi/wWKETSBD15SleuHERzq4ZeD1Vtovt7mxaMROz5o2AXDVKP3l9fuajvFe4ZFJz0LifA3XZerLPfro64XwjlDsMUx9gxPrmBNExlIICvAE/D/2H/ZV2ef1p+//Dl6ZkaRuZeHIBQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAdPlRQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAdPlRQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6801F000C4;
	Sat, 17 Oct 2026 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256056;
	bh=VmNepfIdSjMJsQUBQ8SsqhWK4iSGGyoQBZ178fd7Ojs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAdPlRQbXFlkXSto5wnzLBFl1xl2XcvcpCK6/UvWiUr73YbRfCm2Z/MLSVY8I7xlm
	 gTb7OqKdqPKFCaeuBBVMvQK59i7oqU+9lJXvE/emR+E9UR+DrVGQBgSu8VveoSOaQv
	 hBPo8xkSOP2vlOjEBQ7y1FT7Bm85x0mtQQX0e0OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <xiang@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0108/1674] erofs: add sysfs feature entry for xattr prefixes
Date: Sat, 17 Oct 2026 17:39:40 +0200
Message-ID: <20261017160433.920271035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 839f075aabdf5c21048f9801b87c0b841dd3d064 ]

Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.

Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
Cc: stable@vger.kernel.org # 6.4+
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
[ adjusted feature-list context for missing 48bit and metabox entries while retaining zero_padding. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-erofs | 2 +-
 fs/erofs/sysfs.c                         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-erofs b/Documentation/ABI/testing/sysfs-fs-erofs
index 284224d1b56fe..2997379bf8044 100644
--- a/Documentation/ABI/testing/sysfs-fs-erofs
+++ b/Documentation/ABI/testing/sysfs-fs-erofs
@@ -5,7 +5,7 @@ Description:	Shows all enabled kernel features.
 		Supported features:
 		zero_padding, compr_cfgs, big_pcluster, chunked_file,
 		device_table, compr_head2, sb_chksum, ztailpacking,
-		dedupe, fragments.
+		dedupe, fragments, xattr_prefixes.
 
 What:		/sys/fs/erofs/<disk>/sync_decompress
 Date:		November 2021
diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 435e515c07920..92f0bc13623cc 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -78,6 +78,7 @@ EROFS_ATTR_FEATURE(sb_chksum);
 EROFS_ATTR_FEATURE(ztailpacking);
 EROFS_ATTR_FEATURE(fragments);
 EROFS_ATTR_FEATURE(dedupe);
+EROFS_ATTR_FEATURE(xattr_prefixes);
 
 static struct attribute *erofs_feat_attrs[] = {
 	ATTR_LIST(zero_padding),
@@ -90,6 +91,7 @@ static struct attribute *erofs_feat_attrs[] = {
 	ATTR_LIST(ztailpacking),
 	ATTR_LIST(fragments),
 	ATTR_LIST(dedupe),
+	ATTR_LIST(xattr_prefixes),
 	NULL,
 };
 ATTRIBUTE_GROUPS(erofs_feat);
-- 
2.53.0



