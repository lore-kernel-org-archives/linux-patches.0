Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EB77D408;
	Mon,  8 Apr 2024 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584662; cv=none; b=Az+HMxGVZPmXEpJBO615sqwUsMUX4KOxK3VJ5FbsZCvJOfO405kZx/vW9BquyYwO7I0iNJjojJxn1jMzfzBtqkecj/fIfXD+WICgs7xQMtXpn7WgtibQ5Uu2+oGRc3NpF9HPVJVQnZiGt8W9kJZ2kb2/sZMWFAvaglajqetqeEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584662; c=relaxed/simple;
	bh=PkSGCuN14fvS5g1j+Jxynvr8LOazr1t9L2CG3hF3EJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKJnUbpBWhsBYOcrFTXrHsruE9XXg0m1X41k+XODgDvmgtW/a5N8mLTMK1biR6TbwLPjA4732H32buQvmEoDSNNXJaoSI5YpHFE7uCIQoTAMwuadsaBQnEoKUxOjNHKwElHH2voBzIDu6445HeXZITbTP4kz/k0LQLvBMjO2/K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfYjiwi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfYjiwi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC97C433C7;
	Mon,  8 Apr 2024 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584661;
	bh=PkSGCuN14fvS5g1j+Jxynvr8LOazr1t9L2CG3hF3EJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfYjiwi8jBtX3LZKu34Cm9Qj4MpBQP85FGUhesrkxHkQdbEDS5ZezU4D8kywylitS
	 ImPSXDv/VA/KTP94OkenPsgHz5UrVjfvPmn7D1ODiKWSuXndP1+OyuzdpJCYvhbDjI
	 w1OqN/VfkLxBBIgSCGQR39E5/QJRmOksVcMNA0e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 485/690] NFSD: Update file_hashtbl() helpers
Date: Mon,  8 Apr 2024 14:55:51 +0200
Message-ID: <20240408125417.213634572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3fe828caddd81e68e9d29353c6e9285a658ca056 ]

Enable callers to use const pointers for type safety.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b2a4d442af669..aa7374933de77 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -721,7 +721,7 @@ static unsigned int ownerstr_hashval(struct xdr_netobj *ownername)
 #define FILE_HASH_BITS                   8
 #define FILE_HASH_SIZE                  (1 << FILE_HASH_BITS)
 
-static unsigned int file_hashval(struct svc_fh *fh)
+static unsigned int file_hashval(const struct svc_fh *fh)
 {
 	struct inode *inode = d_inode(fh->fh_dentry);
 
@@ -4686,7 +4686,7 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 
 /* search file_hashtbl[] for file */
 static struct nfs4_file *
-find_file_locked(struct svc_fh *fh, unsigned int hashval)
+find_file_locked(const struct svc_fh *fh, unsigned int hashval)
 {
 	struct nfs4_file *fp;
 
-- 
2.43.0



