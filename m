Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061606;
	b=QhbLN+nb5IcmC2g/MuK2Ngu9espo+wK4DvjVil4ufiEmqjEEAuJgfWoXAC/y7Gf4txwT
	 b/KClf2CHDokxau+wCVmlhtI74k3mqgTrex/+q2tQuatdBSty1aLrXDlfhPsgtHKnJPhK
	 KVcM50IK7i7C1aPD2iafHEiXOa6uTI59pzXlbZM6fVKV17qHmxJTXieo3RFPMFR5y3xVj
	 qfcdmLVstMgjFl1io6ZlaC5lqGwzqGxWECvdyBGf6PuF5krbSDCEXPUPUbJ6bDBbCZ8ot
	 T0Bw/PF2Pq842WWPDmbr+FD7YoHGzNn1f4yo/tqKppEBieKJQfNJDjzrFLI4qqJApug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0//cFpAymZdMwMfODsYScoTAh/8Zfs9jBpz4d6dXXd4=;
	b=bMuSi7P9kDFnWt+V9+Al1w3uQIGvo4GhMCpoPkTHE2HnH3d1HjoN8SENMWXJmUdRd5By
	 bs7Ex9+JeLfUiDohD5G9Wb3ZNSEtzll/Jc8J4mYIWDuxn8/GojeU12TfoEy5GEbo2/Sg5
	 FPeZDqFZQi2rB92dd6VdFkvoR+z3DMF33NrUiCmAIMqsrjkyXoo/wcW6MgQ/zXGMG55hO
	 EAatnsMQBF6K4hE08GF9PEWv1QgtBogrHa4ceKuDxKzEAMtH80PTLwM7WBhVdusYIhUtP
	 0QlBW29AfIVEV+rAl4ddkz+rLHoNWwd+4uzrxO5FZYJ7IvjR8dgUc/JLYwNohUp+riA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKFLonOc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B2A606A32D;
	Sat,  7 Nov 2026 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKFLonOc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E151F0089F;
	Sat,  7 Nov 2026 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061605;
	bh=0//cFpAymZdMwMfODsYScoTAh/8Zfs9jBpz4d6dXXd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKFLonOceXO8tNRfgTZwFYRP21YayuYrPMK5lNsGaPJyS0nLvQEchgU7r+2CKI3J9
	 TMCYZD6B0wBsmw4Ou+mDbnlAKSB6y+w0kWUIeyPJHdITpJXkXqy5VsK2GYX//2ePQ9
	 J+OyBv1LqBAZ6Qz2Sm+cNlRXEq1P+nHyLIfFmUak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0678/1536] ovl: take a snapshot of the name for copy up
Date: Sat,  7 Nov 2026 08:44:54 -0500
Message-ID: <20261107135016.526219974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb upstream.

The copy up of a directory reads a freed dentry name when a lookup
moves the directory at the same time.

A pointer to the name of a dentry is only valid while something stops
a move of the dentry. ovl_do_copy_up() keeps a plain copy of
c->dentry->d_name in c->destname, and ovl_copy_up_start() only keeps
ovl_rename() away. When a lookup finds the same directory under another
name after a change to the lower layer, d_splice_alias() moves the
dentry and frees its external name.

With a delay in ovl_do_copy_up(), a chmod of a lower-only directory with
a 60 byte name raced with a rename of that directory in the lower layer
and a stat of the new name, and KASAN reported a use-after-free in
lookup_noperm_common().

Fix this by using take_dentry_name_snapshot() for c->destname.

Fixes: 829c28be9bb9 ("ovl: use d_splice_alias() in place of d_add() in lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -948,6 +948,7 @@ static int ovl_do_copy_up(struct ovl_cop
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct dentry *origin = c->lowerpath.dentry;
 	struct ovl_fh *fh = NULL;
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -985,12 +986,15 @@ static int ovl_do_copy_up(struct ovl_cop
 		goto out_free_fh;
 	} else {
 		/*
-		 * c->dentry->d_name is stabilzed by ovl_copy_up_start(),
-		 * because if we got here, it means that c->dentry has no upper
-		 * alias and changing ->d_name means going through ovl_rename()
-		 * that will call ovl_copy_up() on source and target dentry.
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
 		 */
-		c->destname = c->dentry->d_name;
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
@@ -999,7 +1003,7 @@ static int ovl_do_copy_up(struct ovl_cop
 		err = ovl_set_impure(c->parent, c->destdir);
 		ovl_end_write(c->dentry);
 		if (err)
-			goto out_free_fh;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -1033,6 +1037,8 @@ static int ovl_do_copy_up(struct ovl_cop
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 out_free_fh:
 	kfree(fh);
 	return err;


