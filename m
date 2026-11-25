Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619096;
	b=1ITkl+/2T85IAIxCVGTlXvncs6homNBJy3UpD0O1E3rtoY+fJwhXJER5cIgPeHrKgPVI
	 sHo7ezYiqNFBSUBR8I2Dwrq/RK3DACzaTo14rzYI4YPJNjnhP+fD+bz6trPgKddN2p0Xq
	 ILJdNvCZyBoxvMiG0LLk9pu5i9Vva8ahcGtD6a2f8IuA4+fQUBGxbEDXwBPKHY2859ABi
	 TI2DxFDxav/0X3pZWZcx2CpQXlGkVkwuXsX5jvgoqoW3rm+S03ngH1JZjQgA4rC5GSLlz
	 BvB8lpm7dUUpG9Cb1DYWxzskOI3Uk/0gpXD41Ru1sl1VXpphpSwB24M4XPzy+RM7nKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1vHteEHCWl5BnZlsZzV+9XQuoLQ//Eq/hoEz/hxHIfU=;
	b=nWFHk4Yi6ABJjS61LHB0bFn4R77ChUX5Ug0Yhus4wCX4156TPagZIgXyoVHxTa+5vxbV
	 XuVNwjilIuUmg5kApqiOimWxxLV5ZlVpvnQFvLbgrYsHvM+Nw7NmwvHETW5bIAAKhn34v
	 ARNh/fnZkmBHbtRPg7keqRYwFpVJeiOoPyxDQYSf/xhKuhWHQNF78VpMS5VVfHjpqx82U
	 7e9chdHpDIPf1Ht7Z31mr8HPGc3BYyXV5SkbtYQtiP314KXuiJzeeZ2d9yp3Jx3lwX53R
	 wd1oEikHxbf1gbIROmKaUXwi30mLZkzBTYIPrujXgMoL9RG3aWOj/DLvIKqyqpYQHCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tK3czQAo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E5606A326;
	Wed, 25 Nov 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tK3czQAo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A131F000C6;
	Wed, 25 Nov 2026 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619096;
	bh=1vHteEHCWl5BnZlsZzV+9XQuoLQ//Eq/hoEz/hxHIfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK3czQAoB+b41DSxG8OmnzVl9diCCtEeLLvLZpCrefRoiLsGisJJPPQ9YprRA8d2z
	 lFXdXJ7isiUqwMot/4E3iPZzdAd7OTXCnjBO6DAeqUMAU37KwZDp4Ey3+jyZC8GvQu
	 V7dMXU8OP1t7ZVeygPVYbKIlu19TSQ0DH/myOm7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0487/1005] NFSv4/flexfiles: Hold a device node reference for layoutstats encoding
Date: Wed, 25 Nov 2026 15:30:25 +0100
Message-ID: <20261125143833.155851663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit dbde656f2f7a8dced33413c83a0cb6b634bfb26e ]

ff_layout_mirror_prepare_stats() records a stripe's device under i_lock,
but the layoutstats/layoutreturn XDR encode runs later and dereferences
the mirror's pinned device node (for the DS netaddr) with no reference
of its own.  Once a CHANGE notification can re-point the pinned node,
that read becomes use-after-free.

Take a node reference at prepare time and carry it with the stripe in a
per-devinfo nfs4_ff_layoutstat_priv, released in
ff_layout_free_layoutstats().  The priv entries live alongside the
devinfo array: co-allocated for LAYOUTSTATS, an additional member of
nfs4_flexfile_layoutreturn_args for LAYOUTRETURN.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Stable-dep-of: 788c4f628565 ("NFSv4/flexfiles: limit transport disconnects when cancelling I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 53 +++++++++++++++++---------
 fs/nfs/flexfilelayout/flexfilelayout.h | 11 ++++++
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 8463021511c17..7105790c9ef5e 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -44,10 +44,11 @@ static void ff_layout_read_record_layoutstats_done(struct rpc_task *task,
 static int
 ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			       struct nfs42_layoutstat_devinfo *devinfo,
+			       struct nfs4_ff_layoutstat_priv *priv,
 			       int dev_limit, enum nfs4_ff_op_type type);
 static void ff_layout_encode_ff_layoutupdate(struct xdr_stream *xdr,
 			      const struct nfs42_layoutstat_devinfo *devinfo,
-			      struct nfs4_ff_layout_ds_stripe *dss_info);
+			      struct nfs4_ff_layoutstat_priv *priv);
 
 static struct pnfs_layout_hdr *
 ff_layout_alloc_layout_hdr(struct inode *inode, gfp_t gfp_flags)
@@ -2805,7 +2806,7 @@ ff_layout_prepare_layoutreturn(struct nfs4_layoutreturn_args *args)
 
 	spin_lock(&args->inode->i_lock);
 	ff_args->num_dev = ff_layout_mirror_prepare_stats(
-		&ff_layout->generic_hdr, &ff_args->devinfo[0],
+		&ff_layout->generic_hdr, &ff_args->devinfo[0], &ff_args->priv[0],
 		ARRAY_SIZE(ff_args->devinfo), NFS4_FF_OP_LAYOUTRETURN);
 	spin_unlock(&args->inode->i_lock);
 
@@ -2980,10 +2981,11 @@ ff_layout_encode_io_latency(struct xdr_stream *xdr,
 static void
 ff_layout_encode_ff_layoutupdate(struct xdr_stream *xdr,
 			      const struct nfs42_layoutstat_devinfo *devinfo,
-			      struct nfs4_ff_layout_ds_stripe *dss_info)
+			      struct nfs4_ff_layoutstat_priv *priv)
 {
+	struct nfs4_ff_layout_ds_stripe *dss_info = priv->dss_info;
 	struct nfs4_pnfs_ds_addr *da;
-	struct nfs4_pnfs_ds *ds = dss_info->mirror_ds->ds;
+	struct nfs4_pnfs_ds *ds = priv->mirror_ds->ds;
 	struct nfs_fh *fh = &dss_info->fh_versions[0];
 	__be32 *p;
 
@@ -3030,10 +3032,10 @@ ff_layout_encode_layoutstats(struct xdr_stream *xdr, const void *args,
 static void
 ff_layout_free_layoutstats(struct nfs4_xdr_opaque_data *opaque)
 {
-	struct nfs4_ff_layout_ds_stripe *dss_info = opaque->data;
-	struct nfs4_ff_layout_mirror *mirror = dss_info->mirror;
+	struct nfs4_ff_layoutstat_priv *priv = opaque->data;
 
-	ff_layout_put_mirror(mirror);
+	nfs4_ff_layout_put_deviceid(priv->mirror_ds);
+	ff_layout_put_mirror(priv->dss_info->mirror);
 }
 
 static const struct nfs4_xdr_opaque_ops layoutstat_ops = {
@@ -3044,12 +3046,13 @@ static const struct nfs4_xdr_opaque_ops layoutstat_ops = {
 static int
 ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			       struct nfs42_layoutstat_devinfo *devinfo,
+			       struct nfs4_ff_layoutstat_priv *priv,
 			       int dev_limit, enum nfs4_ff_op_type type)
 {
 	struct nfs4_flexfile_layout *ff_layout = FF_LAYOUT_FROM_HDR(lo);
 	struct nfs4_ff_layout_mirror *mirror;
 	struct nfs4_ff_layout_ds_stripe *dss_info;
-	struct nfs4_deviceid_node *dev;
+	struct nfs4_ff_layout_ds *mirror_ds;
 	int i = 0, dss_id;
 
 	list_for_each_entry(mirror, &ff_layout->mirrors, mirrors) {
@@ -3057,7 +3060,8 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			dss_info = &mirror->dss[dss_id];
 			if (i >= dev_limit)
 				break;
-			if (IS_ERR_OR_NULL(dss_info->mirror_ds))
+			mirror_ds = dss_info->mirror_ds;
+			if (IS_ERR_OR_NULL(mirror_ds))
 				continue;
 			if (!test_and_clear_bit(NFS4_FF_MIRROR_STAT_AVAIL,
 						&mirror->flags) &&
@@ -3066,9 +3070,14 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			/* mirror refcount put in cleanup_layoutstats */
 			if (!refcount_inc_not_zero(&mirror->ref))
 				continue;
-			dev = &dss_info->mirror_ds->id_node;
+			/*
+			 * The mirror's pin holds the node while we're under
+			 * i_lock; take a reference for the encode, put in
+			 * ff_layout_free_layoutstats().
+			 */
+			atomic_inc(&mirror_ds->id_node.ref);
 			memcpy(&devinfo->dev_id,
-			       &dev->deviceid,
+			       &mirror_ds->id_node.deviceid,
 			       NFS4_DEVICEID4_SIZE);
 			devinfo->offset = 0;
 			devinfo->length = NFS4_MAX_UINT64;
@@ -3084,9 +3093,12 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			spin_unlock(&mirror->lock);
 			devinfo->layout_type = LAYOUT_FLEX_FILES;
 			devinfo->ld_private.ops = &layoutstat_ops;
-			devinfo->ld_private.data = &mirror->dss[dss_id];
+			priv->dss_info = dss_info;
+			priv->mirror_ds = mirror_ds;
+			devinfo->ld_private.data = priv;
 
 			devinfo++;
+			priv++;
 			i++;
 		}
 	}
@@ -3097,21 +3109,28 @@ static int ff_layout_prepare_layoutstats(struct nfs42_layoutstat_args *args)
 {
 	struct pnfs_layout_hdr *lo;
 	struct nfs4_flexfile_layout *ff_layout;
+	struct nfs4_ff_layoutstat_priv *priv;
 	const int dev_count = PNFS_LAYOUTSTATS_MAXDEV;
 
-	/* For now, send at most PNFS_LAYOUTSTATS_MAXDEV statistics */
-	args->devinfo = kmalloc_objs(*args->devinfo, dev_count,
-				     nfs_io_gfp_mask());
+	/*
+	 * For now, send at most PNFS_LAYOUTSTATS_MAXDEV statistics.
+	 * The per-devinfo private entries are co-allocated after the
+	 * devinfo array and freed along with it.
+	 */
+	args->devinfo = kmalloc(dev_count * (sizeof(*args->devinfo) +
+					     sizeof(*priv)),
+				nfs_io_gfp_mask());
 	if (!args->devinfo)
 		return -ENOMEM;
+	priv = (struct nfs4_ff_layoutstat_priv *)&args->devinfo[dev_count];
 
 	spin_lock(&args->inode->i_lock);
 	lo = NFS_I(args->inode)->layout;
 	if (lo && pnfs_layout_is_valid(lo)) {
 		ff_layout = FF_LAYOUT_FROM_HDR(lo);
 		args->num_dev = ff_layout_mirror_prepare_stats(
-			&ff_layout->generic_hdr, &args->devinfo[0], dev_count,
-			NFS4_FF_OP_LAYOUTSTATS);
+			&ff_layout->generic_hdr, &args->devinfo[0], priv,
+			dev_count, NFS4_FF_OP_LAYOUTSTATS);
 	} else
 		args->num_dev = 0;
 	spin_unlock(&args->inode->i_lock);
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.h b/fs/nfs/flexfilelayout/flexfilelayout.h
index f9e491a0347e1..31f3c1a20d401 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -124,9 +124,20 @@ struct nfs4_flexfile_layout {
 	unsigned long		flags;
 };
 
+/*
+ * Per-devinfo private data for a layoutstats/layoutreturn encode: the
+ * stripe the stats describe plus a reference on its device node so the
+ * node (and its DS addresses) stay valid until the XDR encode runs.
+ */
+struct nfs4_ff_layoutstat_priv {
+	struct nfs4_ff_layout_ds_stripe *dss_info;
+	struct nfs4_ff_layout_ds *mirror_ds;
+};
+
 struct nfs4_flexfile_layoutreturn_args {
 	struct list_head errors;
 	struct nfs42_layoutstat_devinfo devinfo[FF_LAYOUTSTATS_MAXDEV];
+	struct nfs4_ff_layoutstat_priv priv[FF_LAYOUTSTATS_MAXDEV];
 	unsigned int num_errors;
 	unsigned int num_dev;
 	struct page *pages[1];
-- 
2.53.0



