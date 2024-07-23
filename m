Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F11381B1;
	Tue, 23 Jul 2024 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721757350; cv=none; b=aLWoLy1BHniWoyJvcX8iEYLpb2zgD38IIRH7g9DenZiICMoC/gEFwim33evjfJ9gWN1yno+3RVDDcnp9WSPaodX1K4ea4d4lGNhpNq5DZkhn1K1n19JTjoZcHXhjZD12QMxNYNcU4M8g3vGTGkon8HX5OCkNJnsVFUhMlBU0mFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721757350; c=relaxed/simple;
	bh=RLyNm4wTeANGXLv4AP/6N+kqj4/zO6fXmJx16u5GImc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Cq/OVNxQ3nW5o/2h+izxDPb1i2DbCYQ355dJrLpRMI1W6L6bP1+2qTA7MqqXPXugPMG1HUxiNz6mQ0UsuUQoxlDCB+NfmySEFODlRAp0M7TJmaxkKlQkqbpBRDNYMEYm/IfAzZr5vK20FqZE+ytVT9JeMgEogXklSJfENzjQDag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRTd8rg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRTd8rg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A8EC4AF09;
	Tue, 23 Jul 2024 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721757349;
	bh=RLyNm4wTeANGXLv4AP/6N+kqj4/zO6fXmJx16u5GImc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=FRTd8rg3u8QmrWVhEsU980Br0AXYECAov4LVOpJ0QiBB/ViTPYoFq+YhE3Cz8rEsP
	 Mc65MUSyyH9evlbKhmN6Vfgw5zefTWsrGd07LvvyuShDyTXieVq6GF7b+kTM7mR697
	 bOty33L06736Ae6+FpwyFRQ5Moi3lDVs7RRpQwrA=
Subject: Patch "netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()" has been added to the 6.1-stable tree
To: brauner@kernel.org,gregkh@linuxfoundation.org,hsiangkao@linux.alibaba.com,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,yangerkun@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 23 Jul 2024 19:55:39 +0200
In-Reply-To: <20240719134338.1642739-1-libaokun@huaweicloud.com>
Message-ID: <2024072339-mushily-fossil-bb91@gregkh>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     netfs-fscache-export-fscache_put_volume-and-add-fscache_try_get_volume.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-60613-greg=kroah.com@vger.kernel.org Fri Jul 19 15:46:31 2024
From: libaokun@huaweicloud.com
Date: Fri, 19 Jul 2024 21:43:36 +0800
Subject: netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, patches@lists.linux.dev, hsiangkao@linux.alibaba.com, yangerkun@huawei.com, libaokun1@huawei.com, Christian Brauner <brauner@kernel.org>
Message-ID: <20240719134338.1642739-1-libaokun@huaweicloud.com>

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
 fs/fscache/internal.h         |    2 --
 fs/fscache/volume.c           |   14 ++++++++++++++
 include/linux/fscache-cache.h |    6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -145,8 +145,6 @@ extern const struct seq_operations fscac
 
 struct fscache_volume *fscache_get_volume(struct fscache_volume *volume,
 					  enum fscache_volume_trace where);
-void fscache_put_volume(struct fscache_volume *volume,
-			enum fscache_volume_trace where);
 bool fscache_begin_volume_access(struct fscache_volume *volume,
 				 struct fscache_cookie *cookie,
 				 enum fscache_access_trace why);
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
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

queue-6.1/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
queue-6.1/netfs-fscache-export-fscache_put_volume-and-add-fscache_try_get_volume.patch
queue-6.1/mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
queue-6.1/cachefiles-fix-slab-use-after-free-in-cachefiles_withdraw_cookie.patch
queue-6.1/minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
queue-6.1/minmax-sanity-check-constant-bounds-when-clamping.patch
queue-6.1/cachefiles-fix-slab-use-after-free-in-fscache_withdraw_volume.patch
queue-6.1/minmax-fix-header-inclusions.patch
queue-6.1/minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
queue-6.1/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
