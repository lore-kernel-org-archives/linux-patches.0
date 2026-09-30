Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FEF501291;
	Wed, 30 Sep 2026 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790188; cv=none; b=GEffRzJ3UlDYeiS1bCVKsj6KJfb9a/4odnCoODwtNTqKrGvMOsH8YME2/oYJwalU2TXrU/eg58epmP8agyaob0qxm2nwVVTO8Yj5G7Ok7Ec5FL8Vw6KjPYKe0xHyHQkt9rljXCA5IUBIzDQnE0c3idy4xcLbfX3Pgjxx58hgJbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790188; c=relaxed/simple;
	bh=N7/3tlqOqFN5UxA4Z2vNjQ/ujS56bjw6382mzzSfTzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDJB+VE5H0lkVwJ5cBEMJqQyPJ7uvwOxmk6XqaCQcIYlbaAeBzUfCD0p6nHu6DmtZJQdSgzsUDScg6ulcsaF7CbQaER7xTLXzwd8x5Z5oApF2IbtfuCHajoRKvnjjPxnjn6iO8qFPzgZkqUtpwfyNaBZapMFxjPiFBS4rMzSets=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxYYPNpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxYYPNpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C221F000FF;
	Wed, 30 Sep 2026 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790187;
	bh=9Q6T6nTNdj11K5pcgUziskONh7FlcbVF9c9efQl9zs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxYYPNpDjDwB9qFiR9ID+B22o7BJWNzQPdrWql4uMb946EVGIk4bT2HkHvM9HCZnj
	 OPGWTdTIjQ+LUfvDzH3oYyWkk2LYcJgQwYQIXuQ57YtZzLQWwylQGWrgiamTUXkIRy
	 3Al78vyxS3KcrwYFY1fIPBq+RCokJfSTKLGCk+64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <xiang@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 742/877] erofs: add sysfs feature entry for xattr prefixes
Date: Wed, 30 Sep 2026 17:27:33 +0200
Message-ID: <20260930152430.705132953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-fs-erofs |    2 +-
 fs/erofs/sysfs.c                         |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-fs-erofs
+++ b/Documentation/ABI/testing/sysfs-fs-erofs
@@ -5,7 +5,7 @@ Description:	Shows all enabled kernel fe
 		Supported features:
 		zero_padding, compr_cfgs, big_pcluster, chunked_file,
 		device_table, compr_head2, sb_chksum, ztailpacking,
-		dedupe, fragments.
+		dedupe, fragments, xattr_prefixes.
 
 What:		/sys/fs/erofs/<disk>/sync_decompress
 Date:		November 2021
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -81,6 +81,7 @@ EROFS_ATTR_FEATURE(sb_chksum);
 EROFS_ATTR_FEATURE(ztailpacking);
 EROFS_ATTR_FEATURE(fragments);
 EROFS_ATTR_FEATURE(dedupe);
+EROFS_ATTR_FEATURE(xattr_prefixes);
 
 static struct attribute *erofs_feat_attrs[] = {
 	ATTR_LIST(zero_padding),
@@ -93,6 +94,7 @@ static struct attribute *erofs_feat_attr
 	ATTR_LIST(ztailpacking),
 	ATTR_LIST(fragments),
 	ATTR_LIST(dedupe),
+	ATTR_LIST(xattr_prefixes),
 	NULL,
 };
 ATTRIBUTE_GROUPS(erofs_feat);


