Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572AF1ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB321C433C7;
	Tue,  1 Aug 2023 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883408;
	bh=eN3TeVouy+YgkIOcn66HdzCY3A/6qD8SxHfI+JlouEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoLxEGsnJsI/edmeWMAKncUtYlO0rLOzdHn9/O7x422ENFWpZLMvrBcE/ZEzegzS1
	 7lcLXvJsrYOtFnCVD5VOS3uv7iPEA/nXcFlFUcsRQVRpyAmwAUHOSDV3M7svl8CM9U
	 wjd2Zzr846wp+rjxKatBLJTy8C9Jhu/PZ7Bs1hvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>
Subject: [PATCH 6.4 218/239] fs/9p: fix typo in comparison logic for cache mode
Date: Tue,  1 Aug 2023 11:21:22 +0200
Message-ID: <20230801091933.781790093@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Van Hensbergen <ericvh@kernel.org>

commit 878cb3e0337d7c3096aee301a2a3cd358dc8aa81 upstream.

There appears to be a typo in the comparison statement for the logic
which sets a file's cache mode based on mount flags.

Cc: stable@vger.kernel.org
Fixes: 1543b4c5071c ("fs/9p: remove writeback fid and fix per-file modes")
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/fid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -57,7 +57,7 @@ static inline void v9fs_fid_add_modes(st
 	   (s_flags & V9FS_DIRECT_IO) || (f_flags & O_DIRECT)) {
 		fid->mode |= P9L_DIRECT; /* no read or write cache */
 	} else if ((!(s_cache & CACHE_WRITEBACK)) ||
-				(f_flags & O_DSYNC) | (s_flags & V9FS_SYNC)) {
+				(f_flags & O_DSYNC) || (s_flags & V9FS_SYNC)) {
 		fid->mode |= P9L_NOWRITECACHE;
 	}
 }


