Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831733;
	b=UYVBH74YzGFO3tEbnLf8VvAcITFJUQLHxcs//H40KTVz6S5DvvtWJ0rfV0DyCAS8S5je
	 3E6/M/kx6aXlv3u4H5z6QtYBRECZMGRUO6U9nRRJ/Ptqf1S+yZGB2q9oPEqrZB4t/NIJn
	 7atlFohjT3URtk7Z/LniTTC7eVRWRsrJ71wdD20mGXFuCoP8xBq39InOPHqk/7H73IMio
	 m4w7Rk+3r2NU5ZImiT01hFqJ8v4S1kMqBwhi27EwKspBiRx1G+CPAI0iTNCcPU8rtisTA
	 gsBZwv5PQOnpybKFiYn7mGi0/rxStPgYx1R2/S0yZj2As0suOrrBmQNUGCyoUsVq5Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LwXanBVlAt6CKurPkmBcViqlGKABGIQEjMerNVaIcWk=;
	b=OoTugLsmt4u3hUr/OHsqCPOPUOde4NjEzoiiG+q1aL8yQ7hLajmWM73fsKuyDC8ahRw8
	 vu+vEzID/bAy55ckq6cdHxyL7Qm8nkb07vvHfu4TorOaYBqyGHEQ8nMMAI3vSxysHMTas
	 CXnD3Ptr6gBVdCEAHrhF0j/XrzJwY2cTd7HhWUutzq8E2n2hCOi+VDJ+E4e0vLecsTjSl
	 v57vhTczewMQeWB8HnVtet+eGVmdFozgxzctF8gcIPXULVDJMJ3En+ZcpjncidVxMTjan
	 5g/xdNbznQkvz6NQ+gUC7IGQeITTP//r05IFbk+0eEo8prmRvVmOvsYdguIHZUZhJPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J81brM6l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17493606AB2F;
	Wed,  4 Nov 2026 22:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J81brM6l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA101F00919;
	Wed,  4 Nov 2026 22:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831733;
	bh=LwXanBVlAt6CKurPkmBcViqlGKABGIQEjMerNVaIcWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J81brM6lbZ3rRpBxV2J1e8EMcBUedh0qxXMXJBKyaeFus4UXeP93YL4T7N2drUpl7
	 08BmyTURHU7WXuQd/U7cR2GrOPCbr1PXiZKMoOmMLcl+PauyGZXjpl3F7uXfeoQ2lF
	 a0VQZlaLoUvllgWOYqI9WBCo/MPCaJ6mTRYF3ILk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0879/1005] NFSv4/flexfiles: Use the full 64-bit offset for read DS selection
Date: Wed,  4 Nov 2026 16:10:12 -0500
Message-ID: <20261104211107.866860327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 448591e1f82902e5714bd436d6367adc7fbaea90 upstream.

The read data-server selection helpers declare their offset parameter
as u32, truncating the file offset before nfs4_ff_layout_calc_dss_id()
computes the stripe index.  The write path already passes the full
offset; make the read path match.

Fixes: 4934ccbeaed3 ("NFSv4/flexfiles: Read path updates for striped layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -880,7 +880,7 @@ ff_layout_mark_ds_reachable(struct pnfs_
 static struct nfs4_pnfs_ds *
 ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 			     u32 start_idx, u32 *best_idx,
-			     u32 offset, u32 *dss_id,
+			     u64 offset, u32 *dss_id,
 			     bool check_device)
 {
 	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
@@ -916,7 +916,7 @@ ff_layout_choose_ds_for_read(struct pnfs
 static struct nfs4_pnfs_ds *
 ff_layout_choose_any_ds_for_read(struct pnfs_layout_segment *lseg,
 				 u32 start_idx, u32 *best_idx,
-				 u32 offset, u32 *dss_id)
+				 u64 offset, u32 *dss_id)
 {
 	return ff_layout_choose_ds_for_read(lseg, start_idx, best_idx,
 					    offset, dss_id, false);
@@ -925,7 +925,7 @@ ff_layout_choose_any_ds_for_read(struct
 static struct nfs4_pnfs_ds *
 ff_layout_choose_valid_ds_for_read(struct pnfs_layout_segment *lseg,
 				   u32 start_idx, u32 *best_idx,
-				   u32 offset, u32 *dss_id)
+				   u64 offset, u32 *dss_id)
 {
 	return ff_layout_choose_ds_for_read(lseg, start_idx, best_idx,
 					    offset, dss_id, true);
@@ -934,7 +934,7 @@ ff_layout_choose_valid_ds_for_read(struc
 static struct nfs4_pnfs_ds *
 ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 				  u32 start_idx, u32 *best_idx,
-				  u32 offset, u32 *dss_id)
+				  u64 offset, u32 *dss_id)
 {
 	struct nfs4_pnfs_ds *ds;
 
@@ -949,7 +949,7 @@ ff_layout_choose_best_ds_for_read(struct
 static struct nfs4_pnfs_ds *
 ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 			  u32 *best_idx,
-			  u32 offset,
+			  u64 offset,
 			  u32 *dss_id)
 {
 	struct pnfs_layout_segment *lseg = pgio->pg_lseg;


