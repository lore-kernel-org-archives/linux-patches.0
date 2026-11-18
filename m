Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046153;
	b=quvG+s0BSqKjhWsxmCj5EAZsN70mmcW4GR8ScDgxqQjMRh0q+jdFZsX2TkXyZp6rOsO/
	 UPBMwx4Mc+Ppr0z94JxkuDNHo2BGTar+9TvnaGAb3rjl4caYUTxIbnM+Ilj2hm+Df7Vx3
	 qFrzQkKI8A8n30FQGpb7L+nbklPyHDwDDONjjQy8n792xS4HK8zyNTomsXjV1uzSFn029
	 xWnG9WGVjsg3MfomRVDOofI3h/v6TYJ7WlWpLEox/ysXW7Yw2+aUL5YeiLAjah65Xv1Xc
	 ucQSgNApZNJLM61fPtbNIa/eEPFQetXIgISFM+sX4PuNiET4tAVdhYh6wDv4xUzQzXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZSyCXaSZciliUP9E6wz06cpaOGjQ8MkHJ3hZBwSEG4=;
	b=qXkplrZRb8LyrotO9p0eFyQ8dRr1R8Feew8WBOjsNGKmRVPdwMut2x8y7vIcnqXY2NKP
	 5AcM5pEFen2IIZo/m9H3hGsIOivB/uzkIJPT6mj5q0zOpEr/gYN+aETu8zkz2Zf6lekBt
	 9PAgJANp5zc8sBZBxyFFCv5cvAAoapoXIZmgLE7bnrUeo3f+gHhtBZKci6Q9I9keubFXW
	 gCGpbbtUq5/RCkaEMXMW8bD47LjiqkSisk4HAPV6q7FdJLes96iZeUB/0MEj1QBzRPl0i
	 dWy56Jgo+s1thl0hk9iCmol9qsLt6S3KFU3xJYV6HqTnjyc9VMq5BBVTeh8JxLmpRxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NIzdy7t+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA4A606A31C;
	Wed, 18 Nov 2026 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NIzdy7t+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9731F000C4;
	Wed, 18 Nov 2026 23:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046153;
	bh=nZSyCXaSZciliUP9E6wz06cpaOGjQ8MkHJ3hZBwSEG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIzdy7t+u5aNNPjVXn9wCZhfs2XUEYsz6XE8Ii2SC6ioAqSuaDSXFC32BtjKUL53x
	 fJc5noFqgNgLGtSoq+udF8KRdSNCvao9W3Hlp60lZ0DwNOyrO+nEkckUYpN7sBlWno
	 gr0AFcW5klhPGIuh610PMHMM3NPBcUPIBYI0atKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1179/2857] NFSv4/pnfs: Free the netid when draining a data-server address list
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118150244.055091599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit a7c8e96d1b9fa327cbdea514d047c8295b28d49a ]

nfs4_pnfs_ds_addr_free() releases all three of an address entry's
allocations, but the four sites that drain a decoded list before it
reaches a data server open-code the loop and free only da_remotestr and
the entry, leaking da_netid.  Both layout drivers drain that list when
nfs4_pnfs_ds_add() returned a data server already in the cache, and
again on their error exits.

Lift the drain into nfs4_pnfs_ds_addr_list_free() so an address list has
one owner.  A striping mount reaches the cached case on nearly every
GETDEVICEINFO, since many deviceIDs name the same data servers.

Fixes: 4be78d26810b ("NFSv4/pNFS: Store the transport type in struct nfs4_pnfs_ds_addr")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayoutdev.c         | 17 ++---------------
 fs/nfs/flexfilelayout/flexfilelayoutdev.c | 17 ++---------------
 fs/nfs/pnfs.h                             |  1 +
 fs/nfs/pnfs_nfs.c                         | 21 +++++++++++++--------
 4 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/fs/nfs/filelayout/filelayoutdev.c b/fs/nfs/filelayout/filelayoutdev.c
index e90e1cf2f0aa1..263046faccc59 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -175,27 +175,14 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 			goto out_err_drain_dsaddrs;
 
 		/* If DS was already in cache, free ds addrs */
-		while (!list_empty(&dsaddrs)) {
-			da = list_first_entry(&dsaddrs,
-					      struct nfs4_pnfs_ds_addr,
-					      da_node);
-			list_del_init(&da->da_node);
-			kfree(da->da_remotestr);
-			kfree(da);
-		}
+		nfs4_pnfs_ds_addr_list_free(&dsaddrs);
 	}
 
 	__free_page(scratch);
 	return dsaddr;
 
 out_err_drain_dsaddrs:
-	while (!list_empty(&dsaddrs)) {
-		da = list_first_entry(&dsaddrs, struct nfs4_pnfs_ds_addr,
-				      da_node);
-		list_del_init(&da->da_node);
-		kfree(da->da_remotestr);
-		kfree(da);
-	}
+	nfs4_pnfs_ds_addr_list_free(&dsaddrs);
 out_err_free_deviceid:
 	nfs4_fl_free_deviceid(dsaddr);
 	/* stripe_indicies was part of dsaddr */
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index e764e5a25f43d..e404b0f660bf8 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -155,26 +155,13 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 		goto out_err_drain_dsaddrs;
 
 	/* If DS was already in cache, free ds addrs */
-	while (!list_empty(&dsaddrs)) {
-		da = list_first_entry(&dsaddrs,
-				      struct nfs4_pnfs_ds_addr,
-				      da_node);
-		list_del_init(&da->da_node);
-		kfree(da->da_remotestr);
-		kfree(da);
-	}
+	nfs4_pnfs_ds_addr_list_free(&dsaddrs);
 
 	__free_page(scratch);
 	return new_ds;
 
 out_err_drain_dsaddrs:
-	while (!list_empty(&dsaddrs)) {
-		da = list_first_entry(&dsaddrs, struct nfs4_pnfs_ds_addr,
-				      da_node);
-		list_del_init(&da->da_node);
-		kfree(da->da_remotestr);
-		kfree(da);
-	}
+	nfs4_pnfs_ds_addr_list_free(&dsaddrs);
 
 	kfree(ds_versions);
 out_scratch:
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 0cc6f9a295f2c..255935a4c9f28 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -416,6 +416,7 @@ int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 struct nfs4_pnfs_ds_addr *nfs4_decode_mp_ds_addr(struct net *net,
 						 struct xdr_stream *xdr,
 						 gfp_t gfp_flags);
+void nfs4_pnfs_ds_addr_list_free(struct list_head *dsaddrs);
 void pnfs_layout_mark_request_commit(struct nfs_page *req,
 				     struct pnfs_layout_segment *lseg,
 				     struct nfs_commit_info *cinfo,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 11bc2c12009dc..c4b61b4b0b1c7 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -679,23 +679,28 @@ static void nfs4_pnfs_ds_addr_free(struct nfs4_pnfs_ds_addr *da)
 	kfree(da);
 }
 
-static void destroy_ds(struct nfs4_pnfs_ds *ds)
+void nfs4_pnfs_ds_addr_list_free(struct list_head *dsaddrs)
 {
 	struct nfs4_pnfs_ds_addr *da;
 
+	while (!list_empty(dsaddrs)) {
+		da = list_first_entry(dsaddrs, struct nfs4_pnfs_ds_addr,
+				      da_node);
+		list_del_init(&da->da_node);
+		nfs4_pnfs_ds_addr_free(da);
+	}
+}
+EXPORT_SYMBOL_GPL(nfs4_pnfs_ds_addr_list_free);
+
+static void destroy_ds(struct nfs4_pnfs_ds *ds)
+{
 	dprintk("--> %s\n", __func__);
 	ifdebug(FACILITY)
 		print_ds(ds);
 
 	nfs_put_client(ds->ds_clp);
 
-	while (!list_empty(&ds->ds_addrs)) {
-		da = list_first_entry(&ds->ds_addrs,
-				      struct nfs4_pnfs_ds_addr,
-				      da_node);
-		list_del_init(&da->da_node);
-		nfs4_pnfs_ds_addr_free(da);
-	}
+	nfs4_pnfs_ds_addr_list_free(&ds->ds_addrs);
 
 	kfree(ds->ds_remotestr);
 	kfree(ds);
-- 
2.53.0



