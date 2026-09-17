Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003E44848B2;
	Thu, 17 Sep 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660341; cv=none; b=moYh2oxMQ5muEgzPsSg9tvb3ZiIqvBZ+pCOsiNaxNDeN9BloWu6WAMq6IFruFSljnheG+qVn2VdyFmM53ArYyMpCSNJVGOXv8SrXMh3EVRRTGSMM3O90pXSCs49enKQM+9YkjE7dSH5+0Ls5dhq3pQIfz48TdQNn2xNgo6TiCTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660341; c=relaxed/simple;
	bh=sdoT/Vt5M1dWd5HkqiDTLEfrnCDkaG8t3GCuEvu7W48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARYFjyKgGEfSIM9Fy4bi7CegxuXxSh9grWMhlYCQ0pnXX3IdF4dP5mu4dxuFg+vSxQ53ONKDkQJArskwPj/g9msd39V6zuwHCEBU5VkJpO1+HGuyR+r9vT15zjfLx0dCxTYNHlVQ+vq4VZw18uakuStNuxv/Chh0GJaJVSnlaEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzIvtS+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzIvtS+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212091F000FF;
	Thu, 17 Sep 2026 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660339;
	bh=yBHVlfasjJ1hMS42bxzeR0f5xS14bEr2YmMO4yoafa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzIvtS+l+5ZKNFLp2+9WTHx+e2LFckqk9Hp7aATfjPJSif5bau7DKeLaqcWH3sCDY
	 HIdhplcglbv8uc59jX3qVUXkmuZhJebR8FHx9P2ZdusZzd7DtxToOERYhSAM3aC7uz
	 i8pko5I360A7TyLfoZV2zw26LN4R30OC5Q+Z1gpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <xiang@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>
Subject: [PATCH 7.2 559/733] erofs: add sysfs feature entry for xattr prefixes
Date: Thu, 17 Sep 2026 16:14:27 +0100
Message-ID: <20260917151406.228637938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

commit 839f075aabdf5c21048f9801b87c0b841dd3d064 upstream.

Let /sys/fs/erofs/features/xattr_prefixes advertise that this kernel
supports the EROFS_FEATURE_INCOMPAT_XATTR_PREFIXES on-disk format.

Fixes: 6a318ccd7e08 ("erofs: enable long extended attribute name prefixes")
Cc: stable@vger.kernel.org # 6.4+
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-fs-erofs |    2 +-
 fs/erofs/sysfs.c                         |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-fs-erofs
+++ b/Documentation/ABI/testing/sysfs-fs-erofs
@@ -5,7 +5,7 @@ Description:	Shows all enabled kernel fe
 		Supported features:
 		compr_cfgs, big_pcluster, chunked_file, device_table,
 		compr_head2, sb_chksum, ztailpacking, dedupe, fragments,
-		48bit, metabox.
+		xattr_prefixes, 48bit, metabox.
 
 What:		/sys/fs/erofs/<disk>/sync_decompress
 Date:		November 2021
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -95,6 +95,7 @@ EROFS_ATTR_FEATURE(sb_chksum);
 EROFS_ATTR_FEATURE(ztailpacking);
 EROFS_ATTR_FEATURE(fragments);
 EROFS_ATTR_FEATURE(dedupe);
+EROFS_ATTR_FEATURE(xattr_prefixes);
 EROFS_ATTR_FEATURE(48bit);
 EROFS_ATTR_FEATURE(metabox);
 
@@ -108,6 +109,7 @@ static struct attribute *erofs_feat_attr
 	ATTR_LIST(ztailpacking),
 	ATTR_LIST(fragments),
 	ATTR_LIST(dedupe),
+	ATTR_LIST(xattr_prefixes),
 	ATTR_LIST(48bit),
 	ATTR_LIST(metabox),
 	NULL,


