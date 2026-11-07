Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065175;
	b=k15RYMvKLRRqfXM7bN9+8c75VhhVwhChc3GDcJkEB1xzeBdGlTlxnmf/CV1zrMRVZLmn
	 7Q2gOkeVjzNyLnT8fMVCpemcICt6UpWWaE5yfJEKesIQKQe6vCEKqFJMHm2IHOMhcIQwO
	 aWDMg3v3hMsGEtlrYVWiCeA3GIOiB+mvPlLlti5mVyyd85wKqPWdnSVDbRGMlXDZboSwu
	 Hb6iMsAzvQH+DqkEOD0tMzZhTKvnBYyFxfjYvgArebynjtiuGqheFtrjRLuijEPAK7H9A
	 jgEbKvCKUYA8DCR2AyFDqQGxdARl8rQbKnkoV6zfiN5RuhzANA968XquL67wR9pMnaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5sEF4CWhWAIvLxOaWPU0aS4rb7zJzzRZsKiWbuEgtAs=;
	b=qjS+oFpVjmFn0ayNPsclJI847EhXr4mHF2zKm3Al07HSjKu7PSJzdmrREQtCpVv/BBiB
	 u8iXKjUa6MrahdYA/VxjCzdoU5swlzPmuqd4029BMt9yPY4+gp1+jxzNFWuFHeqQuHkJm
	 eYZxB3uFlAQtsumDaNdrQiE6dHuBhBEGN0cPfbDirgzp+Frw+phBzzI498xkUgE26kpMx
	 PIMRFKnypuN42PFIOMLznOAG7fcNfBvC8m88l4zp7672RT4BOEXXhUK9cm2DQZZQ1js0J
	 aOKsMRi59tfTS0GsqRfKD0+4JV8HOs3t/bsDisD5JR6bXPqnCxQcaws4KX4hrYf3zIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM2lDo9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4009606A335;
	Sat,  7 Nov 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM2lDo9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C771F008A2;
	Sat,  7 Nov 2026 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065174;
	bh=5sEF4CWhWAIvLxOaWPU0aS4rb7zJzzRZsKiWbuEgtAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yM2lDo9PGq54mdXiI/fNUa5rfIYhCe3M+uEcDscMot4Bt6Fl50kkZG+iI675+EJgF
	 j1tIHV8LFEVNaTJlcwTS7mlAm+5OIivenhrvbi0hWIvq9e4wJy49thkJbSASTDl40x
	 80wXN2OcYWjcrRI+035OwzUBEBJtzf/pwkHIYHl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0928/1257] ntfs: do not map an unmappable runlist fragment as a hole
Date: Sat,  7 Nov 2026 08:53:44 -0500
Message-ID: <20261107135004.988257258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 2b451a65658fb44017480be8818ab93e9115b420 ]

When the extent mft record holding part of a file's runlist cannot be
read, ntfs_attr_vcn_to_rl() ignores the failed ntfs_map_runlist_nolock()
retry and returns with *lcn == LCN_RL_NOT_MAPPED.  The iomap read path
only rejects lcn < LCN_ENOENT, so it maps the range as a hole and read()
returns zeros with no error.  The first read already does this:
ntfs_attr_map_whole_runlist() keeps the fragments it could read,
readahead drops its error, and the next lookup finds the unmapped tail.

On a file whose runlist is split between its base record (vcn 0-214) and
one extent record (vcn 215-1499), breaking only the extent record's FILE
magic makes the kernel log "Failed to map extent mft record", yet read()
returns 1285 clusters of zeros for vcn 215-1499.  A damaged attribute
list entry, which makes the retry fail with -ENOENT, gives the same
zeros.

Return -ENOMEM if the retry ran out of memory and -EIO otherwise.  Both
callers already handle an ERR_PTR; other negative lcns, including
LCN_ENOENT, are returned as before, and so is LCN_RL_NOT_MAPPED at or
beyond allocated_size, where nothing is mapped: the runlist ends there
with LCN_RL_NOT_MAPPED when only the last extent is mapped, as after a
write into it, and with clusters smaller than a page every read of a
file's last folio looks up such vcns.

Reads of vcn 215-1499 now fail with -EIO.  An intact volume exercised
with buffered, mmap and O_DIRECT I/O, fallocate, truncate, sparse and
compressed files behaves as before.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index e8a672c84a02f..91726e4fd3934 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -317,7 +317,7 @@ int ntfs_map_runlist(struct ntfs_inode *ni, s64 vcn)
 struct runlist_element *ntfs_attr_vcn_to_rl(struct ntfs_inode *ni, s64 vcn, s64 *lcn)
 {
 	struct runlist_element *rl = ni->runlist.rl;
-	int err;
+	int err = 0;
 	bool is_retry = false;
 
 	if (!rl) {
@@ -335,12 +335,32 @@ struct runlist_element *ntfs_attr_vcn_to_rl(struct ntfs_inode *ni, s64 vcn, s64
 
 	if (*lcn <= LCN_RL_NOT_MAPPED && is_retry == false) {
 		is_retry = true;
-		if (!ntfs_map_runlist_nolock(ni, vcn, NULL)) {
+		err = ntfs_map_runlist_nolock(ni, vcn, NULL);
+		if (!err) {
 			rl = ni->runlist.rl;
 			goto remap_rl;
 		}
 	}
 
+	/*
+	 * The runlist fragment containing @vcn could not be mapped, e.g.
+	 * because the extent mft record holding it is corrupt.  Do not hand
+	 * LCN_RL_NOT_MAPPED back to callers, which would treat it as a hole.
+	 * At or beyond the allocated size nothing is mapped, and the runlist
+	 * ends there with LCN_RL_NOT_MAPPED if only a later extent has been
+	 * mapped, so return that end as it is.
+	 */
+	if (*lcn == LCN_RL_NOT_MAPPED) {
+		unsigned long flags;
+		s64 allocated_size;
+
+		read_lock_irqsave(&ni->size_lock, flags);
+		allocated_size = ni->allocated_size;
+		read_unlock_irqrestore(&ni->size_lock, flags);
+		if ((s64)ntfs_cluster_to_bytes(ni->vol, vcn) < allocated_size)
+			return ERR_PTR(err == -ENOMEM ? -ENOMEM : -EIO);
+	}
+
 	return rl;
 }
 
-- 
2.53.0



