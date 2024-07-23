Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1047515099C;
	Tue, 23 Jul 2024 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721742843; cv=none; b=Yazuqe07a1OgdlGeFVrgBsKEAqYLKq0Jt/4NvxCjsVkvs+LLrhjOjVWFULsdcQcJzG+5JuUoqz3ScpsreZpkT6abnpcqLK3bdvRx4a22fyKXz4S1EDC4NbbWaEqebTcpRl/yUo5RshSWcywoC/k+nj2VAnamqD34BYmlDv67cL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721742843; c=relaxed/simple;
	bh=79FNuvOncjyOteU1cfc/iVq+a86SpWnnE/NSw0bVqSo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AJFigw+wbLRbUSFcDE/oAMtFsv0jjio9VOSzM1OaemIXJP7KxiDW4rn+XhVQMUsz+o4bIQtKng8x622O6UXz9BPCfEQR5VTJ6CawxUG0YGP6GX0rx4M1BbP1Sqr6pX9KDaanXzyzoJ2CKsBTc46SkXuiivXJWSFe6IRImNdYrfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgZDpjSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgZDpjSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74891C4AF09;
	Tue, 23 Jul 2024 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721742842;
	bh=79FNuvOncjyOteU1cfc/iVq+a86SpWnnE/NSw0bVqSo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZgZDpjSksu/KVROmWIK69B8qUziVugHF0CmMlnsy2UexzodQu9/rF4CxpGrqenE27
	 suQ8+JV2IOG6OCCnZnb3U1IPw35PJJI3DgEjjYTZ7JxpptjBrZyrkupGDfJJtBmTnJ
	 MPnjO09mZV8B/5tCsfj8BiaWCk3SaBOos+Uy5U1k=
Subject: Patch "netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()" has been added to the 6.9-stable tree
To: brauner@kernel.org,gregkh@linuxfoundation.org,hsiangkao@linux.alibaba.com,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 23 Jul 2024 15:53:46 +0200
In-Reply-To: <20240719132812.1542957-1-libaokun@huaweicloud.com>
Message-ID: <2024072346-dealer-seismic-1a5a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()

to the 6.9-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     netfs-fscache-export-fscache_put_volume-and-add-fscache_try_get_volume.patch
and it can be found in the queue-6.9 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-60606-greg=kroah.com@vger.kernel.org Fri Jul 19 15:31:16 2024
From: libaokun@huaweicloud.com
Date: Fri, 19 Jul 2024 21:28:10 +0800
Subject: netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, patches@lists.linux.dev, hsiangkao@linux.alibaba.com, yangerkun@huawei.com, libaokun1@huawei.com, Christian Brauner <brauner@kernel.org>
Message-ID: <20240719132812.1542957-1-libaokun@huaweicloud.com>

From: libaokun@huaweicloud.com

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 85b08b31a22b481ec6528130daf94eee4452e23f ]

Export fscache_put_volume() and add fscache_try_get_volume()
helper function to allow cachefiles to get/put fscache_volume
via linux/fscache-cache.h.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-2-libaokun@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 522018a0de6b ("cachefiles: fix slab-use-after-free in fscache_withdraw_volume()")
Stable-dep-of: 5d8f80578907 ("cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/fscache_volume.c     |   14 ++++++++++++++
 fs/netfs/internal.h           |    2 --
 include/linux/fscache-cache.h |    6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/netfs/fscache_volume.c
+++ b/fs/netfs/fscache_volume.c
@@ -27,6 +27,19 @@ struct fscache_volume *fscache_get_volum
 	return volume;
 }
 
+struct fscache_volume *fscache_try_get_volume(struct fscache_volume *volume,
+					      enum fscache_volume_trace where)
+{
+	int ref;
+
+	if (!__refcount_inc_not_zero(&volume->ref, &ref))
+		return NULL;
+
+	trace_fscache_volume(volume->debug_id, ref + 1, where);
+	return volume;
+}
+EXPORT_SYMBOL(fscache_try_get_volume);
+
 static void fscache_see_volume(struct fscache_volume *volume,
 			       enum fscache_volume_trace where)
 {
@@ -420,6 +433,7 @@ void fscache_put_volume(struct fscache_v
 			fscache_free_volume(volume);
 	}
 }
+EXPORT_SYMBOL(fscache_put_volume);
 
 /*
  * Relinquish a volume representation cookie.
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -326,8 +326,6 @@ extern const struct seq_operations fscac
 
 struct fscache_volume *fscache_get_volume(struct fscache_volume *volume,
 					  enum fscache_volume_trace where);
-void fscache_put_volume(struct fscache_volume *volume,
-			enum fscache_volume_trace where);
 bool fscache_begin_volume_access(struct fscache_volume *volume,
 				 struct fscache_cookie *cookie,
 				 enum fscache_access_trace why);
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -19,6 +19,7 @@
 enum fscache_cache_trace;
 enum fscache_cookie_trace;
 enum fscache_access_trace;
+enum fscache_volume_trace;
 
 enum fscache_cache_state {
 	FSCACHE_CACHE_IS_NOT_PRESENT,	/* No cache is present for this name */
@@ -97,6 +98,11 @@ extern void fscache_withdraw_cookie(stru
 
 extern void fscache_io_error(struct fscache_cache *cache);
 
+extern struct fscache_volume *
+fscache_try_get_volume(struct fscache_volume *volume,
+		       enum fscache_volume_trace where);
+extern void fscache_put_volume(struct fscache_volume *volume,
+			       enum fscache_volume_trace where);
 extern void fscache_end_volume_access(struct fscache_volume *volume,
 				      struct fscache_cookie *cookie,
 				      enum fscache_access_trace why);


Patches currently in stable-queue which might be from kroah.com@vger.kernel.org are

queue-6.9/cachefiles-fix-slab-use-after-free-in-cachefiles_withdraw_cookie.patch
queue-6.9/cachefiles-fix-slab-use-after-free-in-fscache_withdraw_volume.patch
queue-6.9/netfs-fscache-export-fscache_put_volume-and-add-fscache_try_get_volume.patch
