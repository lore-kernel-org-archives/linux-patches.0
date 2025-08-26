Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332F29D27E;
	Tue, 26 Aug 2025 11:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208542; cv=none; b=LqbnOIucSNHSx6br+Uc01QopUh3mPggZBldzCWUKc9vgXZRon8F7dDRbSU52O6/aUPAP4OmUjmo3gvpsOH8OEi5XbH1nbzY80/eJ6QoqHL2J4GlE9QtMDGmj+WrN5aRF7J+orJMdyQx2PBga26xh5ShqMTLeyXz9TnFQL8kbPdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208542; c=relaxed/simple;
	bh=aAoztSmTHBh/D/KoW9vV6ejeoxOQnH4YmjXFktilivs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5hzujHQbmS8yTVZdUJORq+WQ95rW0q8aPqEwKgtMGHmCG9A1RX+qVdX03GlM2EXPuAoGwg4QJLZT5z6cpE3DGXudxYY0wDH+skUxcfZIcpfXIYSfkaY2Dp0gLaKkmOMDy9NKeqGU7RkdqnmMyBIHWvLRR3rghxvUWpK8iS3Eyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKaWGNd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKaWGNd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A63C4CEF1;
	Tue, 26 Aug 2025 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208542;
	bh=aAoztSmTHBh/D/KoW9vV6ejeoxOQnH4YmjXFktilivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKaWGNd1CI5mJLNtQDB2QsvYsFAecrVtT3TbhZzcVsO57XYVReVjAxfUpwf8KDbjD
	 OZs1k/FWxs0ysite+4sclKmdZMpS/FXrCImlEEEfP74196J2BYZp5IPl7h/SaFvgN2
	 N6e8OvNn9WztBjn1Av+qG9iCxvfKoEnvFRlKvhs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/322] btrfs: send: only use boolean variables at process_recorded_refs()
Date: Tue, 26 Aug 2025 13:09:27 +0200
Message-ID: <20250826110919.569744676@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9453fe329789073d9a971de01da5902c32c1a01a ]

We have several local variables at process_recorded_refs() that are used
as booleans, with some of them having a 'bool' type while two of them
having an 'int' type. Change this to make them all use the 'bool' type
which is more clear and to make everything more consistent.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 005b0a0c24e1 ("btrfs: send: use fallocate for hole punching with send stream v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4179,9 +4179,9 @@ static int process_recorded_refs(struct
 	u64 ow_inode = 0;
 	u64 ow_gen;
 	u64 ow_mode;
-	int did_overwrite = 0;
-	int is_orphan = 0;
 	u64 last_dir_ino_rm = 0;
+	bool did_overwrite = false;
+	bool is_orphan = false;
 	bool can_rename = true;
 	bool orphanized_dir = false;
 	bool orphanized_ancestor = false;
@@ -4223,14 +4223,14 @@ static int process_recorded_refs(struct
 		if (ret < 0)
 			goto out;
 		if (ret)
-			did_overwrite = 1;
+			did_overwrite = true;
 	}
 	if (sctx->cur_inode_new || did_overwrite) {
 		ret = gen_unique_name(sctx, sctx->cur_ino,
 				sctx->cur_inode_gen, valid_path);
 		if (ret < 0)
 			goto out;
-		is_orphan = 1;
+		is_orphan = true;
 	} else {
 		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen,
 				valid_path);
@@ -4453,7 +4453,7 @@ static int process_recorded_refs(struct
 			ret = send_rename(sctx, valid_path, cur->full_path);
 			if (ret < 0)
 				goto out;
-			is_orphan = 0;
+			is_orphan = false;
 			ret = fs_path_copy(valid_path, cur->full_path);
 			if (ret < 0)
 				goto out;
@@ -4514,7 +4514,7 @@ static int process_recorded_refs(struct
 					sctx->cur_inode_gen, valid_path);
 			if (ret < 0)
 				goto out;
-			is_orphan = 1;
+			is_orphan = true;
 		}
 
 		list_for_each_entry(cur, &sctx->deleted_refs, list) {


