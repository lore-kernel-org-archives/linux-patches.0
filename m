Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A944ED18A;
	Thu, 17 Sep 2026 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667088; cv=none; b=H6qwnurosneWjnwJ/Kmb7BpIcfsIqIlqOqFUCuBxXpjE2UzKmB9G65QRUECnaFA7Vy3GVxeP1+n+fy00WAIt3jrK2kf44ye31flgj7xA8BeZYSJXl9UX3QtnQF0lGDlmU/ZiLaiGNgAiYk5Cz0rAxfnXOBpnoh0DnqP0FCmQn10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667088; c=relaxed/simple;
	bh=neTVCV3D+KhtpRVJfZvo03QuKsWBqacM91crJQ1A4nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPUZDlOIFOtKagTrgTnsY7xmeKIbZvMH6fpdqJcgOhq7unB45GVXh3UtnXuF/uOZ8O/u/QjbPsc4IYk6exTW4EpYq+qtIte8lwv5O9OdoBPZDwdsYAJZICx3qcK/mFnE8aBHtbX/Noujwp3SJtex64FGxl1vbV2ddJzDRkyg8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6saVlmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6saVlmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285CC1F00893;
	Thu, 17 Sep 2026 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667086;
	bh=jM5N3UWQnqZAwzqnzeefRitiC+NnPNCmerVoF7Kz294=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6saVlmf9XnvuRiy+cxjs+YYp8ZdunISR+RRCKomuGqRpROSEVFtJnbfDY580vk5m
	 ycwfOESDegldqWkoVp85//ULIi+ItUZqG19aEr0IQKgEOirCXQwXQ7cH+ElH/7DfKS
	 5ZnqxNVRD0Vi7LC6TJUwzFaPG1t70qORdWFr13BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <xiang@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1223/1250] erofs: add sysfs feature entry for xattr prefixes
Date: Thu, 17 Sep 2026 16:16:58 +0100
Message-ID: <20260917151625.432672256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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


