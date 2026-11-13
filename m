Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591027;
	b=jTQyE40w+2V+VlKD2VbNvP56zxens9yJsAVz8Q+DXF+4m28xUvRla4w02bSo/gDTV8yP
	 R5IpnuREVPWkxIo6xh/873ougBMxLquzkOemg1hIR7Tca1YAvnk8FB0I4HgfCUz2HCA4q
	 wpcRlQeVf6wUM+WBDSS3ry//sEHcPsa5+KkyPsIGjEgYKw0vHp62jnqiWUqxrzItEQ6wK
	 nK0jeFzFOiRbjKzfcmxwVrAxaW7khW0M+fpEdHL5FblC/tv4eSMJW0ywRxwkEqpqVwb/Y
	 RsbPHg6bRggCz6LGcKcAy/XrqZoPkm20DTYcC1mjtxH9RbW9f5n+l5lpgQ7QBbIvgCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E+v7bLrrQiWMLgCTI0l3GA8V7pN2DEERaI9oGGAfYdI=;
	b=3vTYy8g9S4dn42r24/qCtsECN3ELCYW+erGCwlTNfDTJDD0CMaNEoQdhESE7mVtWf4Pk
	 YBUT1AK56q1fhiSMqG2ip1H5ZL1ypIxO4DB6OqQ1+3HrpNQjdE+DJ2maaTZoacF6OOG26
	 ELjhr2ebls78GTPPc9Nbg9f1alY/tg7C7NM0XltQk+5Oj4DGCs3i/oGHYfNAxj4K6VB8w
	 o91M+QPyKoFU7IIVY8jznSpVbGLr8EUD3HYKNqzzZ1e70J7SpMXvgzUdM9ixseuUMVJdj
	 79CDAqQZfgQxX2cAoH/WyXYojTS6Alhg+IiB9edZjE148e712s+yTQlnf/rJmUMa2dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4HXwI4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20DF6071424;
	Fri, 13 Nov 2026 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4HXwI4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FC91F000C4;
	Fri, 13 Nov 2026 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591027;
	bh=E+v7bLrrQiWMLgCTI0l3GA8V7pN2DEERaI9oGGAfYdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4HXwI4yOhn6Qb47ewKtEJkaMjRTk+p2WIALA9kzWseMOKseASWRNiXdp3wPk1rEx
	 oIYXx1UwuftRgRr5c2fXVh44kO2OePP1z1Y6IubZ2hmUBNLQlQzIGQcvZfghzj+9ER
	 2Yxo79WHul94WS30aDA1GAgslPg83VOwGUNUzuO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/670] NFSv4/pnfs: Free the netid when draining a data-server address list
Date: Fri, 13 Nov 2026 10:45:13 -0500
Message-ID: <20261113153816.974379500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index b878ea466361b..7142958b1265e 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -177,27 +177,14 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 		trace_fl_getdevinfo(server, &pdev->dev_id, dsaddr->ds_list[i]->ds_remotestr);
 
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
index 53655581f9cb2..f33e4f820dece 100644
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
index 14d2a91250f24..9d612bed74e3c 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -426,6 +426,7 @@ int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 struct nfs4_pnfs_ds_addr *nfs4_decode_mp_ds_addr(struct net *net,
 						 struct xdr_stream *xdr,
 						 gfp_t gfp_flags);
+void nfs4_pnfs_ds_addr_list_free(struct list_head *dsaddrs);
 void pnfs_layout_mark_request_commit(struct nfs_page *req,
 				     struct pnfs_layout_segment *lseg,
 				     struct nfs_commit_info *cinfo,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 634ee58ced12a..1e457dd3b8bdf 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -632,23 +632,28 @@ static void nfs4_pnfs_ds_addr_free(struct nfs4_pnfs_ds_addr *da)
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



