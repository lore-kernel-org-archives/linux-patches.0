Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065105;
	b=kqVgYVjbdtLokk50KxveqmYxdONymPM+pv0qaErVE9LEOQeNaguiUE6tuq9XaEuZGdZz
	 dPeNrhD11cwyYq5t2VPA0CQV2JC/pATvStKc51OaYa2arjxLTJ2QlUgcsI7G74K4tDLwO
	 gi47nkx7yP655Nxaw0zUUtyjbseogt1hm1XGmh7+oiNrKBIBfW/aC/eYXx9bgxBjFio77
	 t9Px04Rcn1lPvoMCFCSDTz2dtrymSWc9eOfCyF6jceL4wJB6DfIcTOVlHqBylvLr8NdyR
	 naRYky9/5YfoxXTcpxBviyBoHHS4yOEMm4kVEDF6D1t7DSRDeG+wiEJSYowWomCXGeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQJNG24D+EEGNb5LA1H1k/YOgMbMEFa/iNLR2sEHPKQ=;
	b=UOrX2rKc2yXoM/eCX+maQgAFefzCge6joJPp16nJOD/DVUdhNqnhHhvBYkm7PHqPDq9T
	 oBQhqBVQZgQgi0jSTTZ1t5w2nNTPPLqLaleLf/Uvt5YYRCFFxPn6ru1mSrqQK6u4xzZ3y
	 QHIM0JA7jdbneZlWfoZB744guVA15lEv1RHjX1aaR3u2y1M2xQ/o4EAOctdLHsM+UGwY3
	 YfPjVJiaN93MZXh3uKmzscQJYO4+Ipa///8tcuGaTNyGxK8oTWv2eIvozqcBIKS6Cvwba
	 sn+Sk6fH9bGLadNBb6YfiYeA7M+erHbAZJ/ngBR01N3jIik3NIYKyccI119ox5PNv/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGCJHIlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16840606A32E;
	Sat,  7 Nov 2026 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGCJHIlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C161F0089F;
	Sat,  7 Nov 2026 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065104;
	bh=QQJNG24D+EEGNb5LA1H1k/YOgMbMEFa/iNLR2sEHPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGCJHIlbu0rsET613VfS1F/2Q7WIkVCqmoIKLEi9GbnZfeyDNJXgVxLhSCNvM+BDY
	 7lJCGNB9gl3z1jlV9T7Cu2dSO+ePn6dp2znlnxyy70VTb9+VP6z8pYeRP3KRdvDvir
	 e6VpxMW4RZqzzwvqk+ImcHk94CR0PrB6it/+WcfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0935/1257] ntfs: add a runlist merge that leaves the source runlist to the caller
Date: Sat,  7 Nov 2026 08:53:51 -0500
Message-ID: <20261107135005.179301396@linuxfoundation.org>
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

[ Upstream commit c6ee0986b80715c44d547e9cbdc1a72ad855071c ]

ntfs_runlists_merge() frees the source runlist once its runs are in the
destination.  A caller that may have to undo the merge then has to work
out its runs again from the merged runlist, where the first and the
last of them may have been coalesced with neighbouring runs.

Add ntfs_runlists_merge_keep_src(), which neither modifies nor frees
the source runlist.  For that, ntfs_rl_append() and ntfs_rl_replace()
now merge the right-hand end into the copied run in the destination
instead of into the last source run before copying it, and the merge
helpers take the source as const, so the compiler checks that none of
them writes to it.  The merged runlist is the same as before.

For every caller, a source runlist without any mapped run, which the
merge already warns about, now fails with -EINVAL instead of carrying
on with nothing to insert: with no run copied, the right-hand merge
into the destination would index before the insertion point.

The next patch uses ntfs_runlists_merge_keep_src() to free exactly the
clusters it allocated when it has to undo an $MFT data extension.

Suggested-by: Hyunchul Lee <hyc.lee@gmail.com>
Cc: stable@vger.kernel.org # needed by the next patch
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/runlist.c | 98 ++++++++++++++++++++++++++++++++++++++---------
 fs/ntfs/runlist.h |  3 ++
 2 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 3a61f19bcbeef..89e13a452a845 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -47,7 +47,7 @@ static inline void ntfs_rl_mm(struct runlist_element *base, int dst, int src, in
  * @srcbase.
  */
 static inline void ntfs_rl_mc(struct runlist_element *dstbase, int dst,
-		struct runlist_element *srcbase, int src, int size)
+		const struct runlist_element *srcbase, int src, int size)
 {
 	if (likely(size > 0))
 		memcpy(dstbase + dst, srcbase + src, size * sizeof(*dstbase));
@@ -152,8 +152,8 @@ static inline struct runlist_element *ntfs_rl_realloc_nofail(struct runlist_elem
  * Return: true   Success, the runlists can be merged.
  *	   false  Failure, the runlists cannot be merged.
  */
-static inline bool ntfs_are_rl_mergeable(struct runlist_element *dst,
-		struct runlist_element *src)
+static inline bool ntfs_are_rl_mergeable(const struct runlist_element *dst,
+		const struct runlist_element *src)
 {
 	/* We can merge unmapped regions even if they are misaligned. */
 	if ((dst->lcn == LCN_RL_NOT_MAPPED) && (src->lcn == LCN_RL_NOT_MAPPED))
@@ -186,7 +186,8 @@ static inline bool ntfs_are_rl_mergeable(struct runlist_element *dst,
  *
  * It is up to the caller to serialize access to the runlists @dst and @src.
  */
-static inline void __ntfs_rl_merge(struct runlist_element *dst, struct runlist_element *src)
+static inline void __ntfs_rl_merge(struct runlist_element *dst,
+		const struct runlist_element *src)
 {
 	dst->length += src->length;
 }
@@ -214,10 +215,11 @@ static inline void __ntfs_rl_merge(struct runlist_element *dst, struct runlist_e
  * On error, return -errno. Both runlists are left unmodified.
  */
 static inline struct runlist_element *ntfs_rl_append(struct runlist_element *dst,
-		int dsize, struct runlist_element *src, int ssize, int loc,
+		int dsize, const struct runlist_element *src, int ssize, int loc,
 		size_t *new_size)
 {
 	bool right = false;	/* Right end of @src needs merging. */
+	s64 right_length = 0;	/* Length of the run merged at the right. */
 	int marker;		/* End of the inserted runs. */
 
 	/* First, check if the right hand end needs merging. */
@@ -235,9 +237,9 @@ static inline struct runlist_element *ntfs_rl_append(struct runlist_element *dst
 	 * original runlists.
 	 */
 
-	/* First, merge the right hand end, if necessary. */
+	/* Remember the run that the right hand end absorbs, if any. */
 	if (right)
-		__ntfs_rl_merge(src + ssize - 1, dst + loc + 1);
+		right_length = dst[loc + 1].length;
 
 	/* First run after the @src runs that have been inserted. */
 	marker = loc + ssize + 1;
@@ -246,6 +248,9 @@ static inline struct runlist_element *ntfs_rl_append(struct runlist_element *dst
 	ntfs_rl_mm(dst, marker, loc + 1 + right, dsize - (loc + 1 + right));
 	ntfs_rl_mc(dst, loc + 1, src, 0, ssize);
 
+	/* Merge the right hand end into the copy, leaving @src intact. */
+	dst[marker - 1].length += right_length;
+
 	/* Adjust the size of the preceding hole. */
 	dst[loc].length = dst[loc + 1].vcn - dst[loc].vcn;
 
@@ -279,7 +284,7 @@ static inline struct runlist_element *ntfs_rl_append(struct runlist_element *dst
  * On error, return -errno. Both runlists are left unmodified.
  */
 static inline struct runlist_element *ntfs_rl_insert(struct runlist_element *dst,
-		int dsize, struct runlist_element *src, int ssize, int loc,
+		int dsize, const struct runlist_element *src, int ssize, int loc,
 		size_t *new_size)
 {
 	bool left = false;	/* Left end of @src needs merging. */
@@ -374,12 +379,13 @@ static inline struct runlist_element *ntfs_rl_insert(struct runlist_element *dst
  * On error, return -errno. Both runlists are left unmodified.
  */
 static inline struct runlist_element *ntfs_rl_replace(struct runlist_element *dst,
-		int dsize, struct runlist_element *src, int ssize, int loc,
+		int dsize, const struct runlist_element *src, int ssize, int loc,
 		size_t *new_size)
 {
 	int delta;
 	bool left = false;	/* Left end of @src needs merging. */
 	bool right = false;	/* Right end of @src needs merging. */
+	s64 right_length = 0;	/* Length of the run merged at the right. */
 	int tail;		/* Start of tail of @dst. */
 	int marker;		/* End of the inserted runs. */
 
@@ -405,9 +411,12 @@ static inline struct runlist_element *ntfs_rl_replace(struct runlist_element *ds
 	 * original runlists.
 	 */
 
-	/* First, merge the left and right ends, if necessary. */
+	/*
+	 * Remember the run that the right hand end absorbs, if any, then
+	 * merge the left hand end.
+	 */
 	if (right)
-		__ntfs_rl_merge(src + ssize - 1, dst + loc + 1);
+		right_length = dst[loc + 1].length;
 	if (left)
 		__ntfs_rl_merge(dst + loc - 1, src);
 	/*
@@ -432,6 +441,13 @@ static inline struct runlist_element *ntfs_rl_replace(struct runlist_element *ds
 	ntfs_rl_mm(dst, marker, tail, dsize - tail);
 	ntfs_rl_mc(dst, loc, src, left, ssize - left);
 
+	/*
+	 * Merge the right hand end into the last run of @src, now in @dst at
+	 * @marker - 1 (or into @dst[@loc - 1] if that absorbed all of @src),
+	 * leaving @src intact.
+	 */
+	dst[marker - 1].length += right_length;
+
 	/* We may have changed the length of the file, so fix the end marker. */
 	if (dsize - tail > 0 && dst[marker].lcn == LCN_ENOENT)
 		dst[marker].vcn = dst[marker - 1].vcn + dst[marker - 1].length;
@@ -461,7 +477,7 @@ static inline struct runlist_element *ntfs_rl_replace(struct runlist_element *ds
  * On error, return -errno. Both runlists are left unmodified.
  */
 static inline struct runlist_element *ntfs_rl_split(struct runlist_element *dst, int dsize,
-		struct runlist_element *src, int ssize, int loc,
+		const struct runlist_element *src, int ssize, int loc,
 		size_t *new_size)
 {
 	/* Space required: @dst size + @src size + one new hole. */
@@ -488,11 +504,12 @@ static inline struct runlist_element *ntfs_rl_split(struct runlist_element *dst,
 }
 
 /*
- * ntfs_runlists_merge - merge two runlists into one
+ * __ntfs_runlists_merge - merge two runlists into one
  * @d_runlist: destination runlist structure to merge into
  * @srl: source runlist to merge from
  * @s_rl_count: number of elements in @srl (0 to auto-detect)
  * @new_rl_count: on success, set to the new combined runlist size
+ * @keep_srl: leave @srl to the caller instead of deallocating it
  *
  * First we sanity check the two runlists @srl and @drl to make sure that they
  * are sensible and can be merged. The runlist @srl must be either after the
@@ -515,13 +532,14 @@ static inline struct runlist_element *ntfs_rl_split(struct runlist_element *dst,
  * On success, return a pointer to the new, combined, runlist. Note, both
  * runlists @drl and @srl are deallocated before returning so you cannot use
  * the pointers for anything any more. (Strictly speaking the returned runlist
- * may be the same as @dst but this is irrelevant.)
+ * may be the same as @dst but this is irrelevant.)  If @keep_srl is true,
+ * @srl is neither modified nor deallocated, and @drl must not be NULL.
  *
  * On error, return -errno. Both runlists are left unmodified.
  */
-struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
-				     struct runlist_element *srl, size_t s_rl_count,
-				     size_t *new_rl_count)
+static struct runlist_element *__ntfs_runlists_merge(struct runlist *d_runlist,
+		struct runlist_element *srl, size_t s_rl_count,
+		size_t *new_rl_count, bool keep_srl)
 {
 	int di, si;		/* Current index into @[ds]rl. */
 	int sstart;		/* First index with lcn > LCN_RL_NOT_MAPPED. */
@@ -553,6 +571,8 @@ struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
 
 	/* Check for the case where the first mapping is being done now. */
 	if (unlikely(!drl)) {
+		if (WARN_ON(keep_srl))
+			return ERR_PTR(-EINVAL);
 		drl = srl;
 		/* Complete the source runlist if necessary. */
 		if (unlikely(drl[0].vcn)) {
@@ -582,7 +602,8 @@ struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
 		si++;
 
 	/* Can't have an entirely unmapped source runlist. */
-	WARN_ON(!srl[si].length);
+	if (WARN_ON(!srl[si].length))
+		return ERR_PTR(-EINVAL);
 
 	/* Record the starting points. */
 	sstart = si;
@@ -652,7 +673,8 @@ struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
 		ntfs_error(NULL, "Merge failed.");
 		return drl;
 	}
-	kvfree(srl);
+	if (!keep_srl)
+		kvfree(srl);
 	if (marker) {
 		ntfs_debug("Triggering marker code.");
 		for (ds = dend; drl[ds].length; ds++)
@@ -714,6 +736,44 @@ struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
 	return drl;
 }
 
+/*
+ * ntfs_runlists_merge - merge two runlists into one
+ * @d_runlist: destination runlist structure to merge into
+ * @srl: source runlist to merge from, deallocated on success
+ * @s_rl_count: number of elements in @srl (0 to auto-detect)
+ * @new_rl_count: on success, set to the new combined runlist size
+ *
+ * See __ntfs_runlists_merge().
+ */
+struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
+		struct runlist_element *srl, size_t s_rl_count,
+		size_t *new_rl_count)
+{
+	return __ntfs_runlists_merge(d_runlist, srl, s_rl_count, new_rl_count,
+			false);
+}
+
+/*
+ * ntfs_runlists_merge_keep_src - merge two runlists, keeping the source
+ * @d_runlist: destination runlist structure to merge into, not empty
+ * @srl: source runlist to merge from
+ * @s_rl_count: number of elements in @srl (0 to auto-detect)
+ * @new_rl_count: on success, set to the new combined runlist size
+ *
+ * Like ntfs_runlists_merge(), but @srl is neither modified nor deallocated,
+ * on success or on error, and remains the caller's to kvfree().  Even when
+ * runs of @srl are coalesced with runs of @d_runlist, @srl keeps describing
+ * exactly its own runs, e.g. the clusters a caller has to free to undo the
+ * merge.
+ */
+struct runlist_element *ntfs_runlists_merge_keep_src(struct runlist *d_runlist,
+		struct runlist_element *srl, size_t s_rl_count,
+		size_t *new_rl_count)
+{
+	return __ntfs_runlists_merge(d_runlist, srl, s_rl_count, new_rl_count,
+			true);
+}
+
 /*
  * ntfs_mapping_pairs_decompress - convert mapping pairs array to runlist
  * @vol: ntfs volume
diff --git a/fs/ntfs/runlist.h b/fs/ntfs/runlist.h
index cc92e09fbf682..0d4c32b1a338f 100644
--- a/fs/ntfs/runlist.h
+++ b/fs/ntfs/runlist.h
@@ -68,6 +68,9 @@ enum {
 struct runlist_element *ntfs_runlists_merge(struct runlist *d_runlist,
 		struct runlist_element *srl, size_t s_rl_count,
 		size_t *new_rl_count);
+struct runlist_element *ntfs_runlists_merge_keep_src(struct runlist *d_runlist,
+		struct runlist_element *srl, size_t s_rl_count,
+		size_t *new_rl_count);
 struct runlist_element *ntfs_mapping_pairs_decompress(const struct ntfs_volume *vol,
 		const struct attr_record *attr, struct runlist *old_runlist,
 		size_t *new_rl_count);
-- 
2.53.0



