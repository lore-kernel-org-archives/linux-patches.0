Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061695;
	b=ZlTyYmCbWQYyQGxi3aC5NQJHFRA+23Ot7+ou027gRRW8V7Djv+z8F1TeLZC8F6aIPPbv
	 bp3HZ4GiWPSsmRr3xHYLnHWEhZCyDP4EMNtp8s3O7Ngdq26VVua1REmCWPvSPNIikh3Vu
	 I2yZYznkVb8h/dqs5cFjfDMSQV/DtSkZA5YjxvgZA0XXmIV4QNybYMhNfFMSHXx9OuBlb
	 vOr4WeGVtMydNPqluiVdsafKhEuLiv0O1rf7uPU5+YSHx5wX1FbavG4IMKVWgWRZZ50Gl
	 3W3eVd51e27SGymu8vVqfhQmnTHmu/AqnUY8JKQBRzOmw8r7QFWHgWuK0QUI3u5t4Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7BuWmz1z0EGStd3ClCq8tfO0fO3AXi1TxjAzXdgc+4=;
	b=MLB9pDlomuQslfeg2gmbIUUVF8CCZPbKPfi0qdXB5frG7LjC8pD1605IIa2PPwlYGq/H
	 zJrREabxLl1YOzCjvwAgpLPxM4D/x7TngMAcZ3zYjrIe5ltcOkLsFRMTi0Fi14gCnhvVE
	 exFP7n+TQEnlpvn9yao2R08eMBlkoNskzvvM7x0v4b6DIPSdJmLTPS+X/jlt9wj6ZjHPL
	 1waRsjsCDxt9XSnSDuaaCm547NvP8E3UbTked7hOSezHY1XCNgdOG6xYjxzf9W5k+Ibql
	 sud3PTl2VJKlJLcI1LnYaiG9e0u3b+5x1tUMf8KTbLCzfzS4P01Irz76qNSdOdewjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrD8z6k8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07A606A326;
	Sat,  7 Nov 2026 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrD8z6k8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FCF1F0089F;
	Sat,  7 Nov 2026 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061695;
	bh=Z7BuWmz1z0EGStd3ClCq8tfO0fO3AXi1TxjAzXdgc+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrD8z6k8H/umP38PJxSiaUZ4bL46kYhSYfy/lZhvv+bc/0ZaBPVjMaCaFx/J6XZ7j
	 mwNJsM1lD4w5sFU27ktYkVwquQ05LQQTgrez6t8ruGcGhgrlEdw2GNufQ6rPvKdS/e
	 CuN8REZ9KHMfBhIV5LqPTJ+PxDkDdHYKhdd0kurk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0707/1536] xfs: bail out of directory tree repairs on error
Date: Sat,  7 Nov 2026 08:45:23 -0500
Message-ID: <20261107135017.356640008@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit d83ca4e7cc65dce6a02fd3427cefd174517657a3 upstream.

LOLLM complains that we ignore errors returned by
xrep_dirpath_retain_parent and can set the dotdot entry to random stack
garbage.  Fix that by passing errors all the way out.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |   57 ++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -94,7 +94,7 @@ xrep_dirtree_delete_all_paths(
 }
 
 /* Since this is the surviving path, set the dotdot entry to this value. */
-STATIC void
+STATIC int
 xrep_dirpath_retain_parent(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirpath		*path)
@@ -104,18 +104,20 @@ xrep_dirpath_retain_parent(
 
 	error = xfarray_load(dl->path_steps, path->first_step, &step);
 	if (error)
-		return;
+		return error;
 
 	dl->parent_ino = be64_to_cpu(step.pptr_rec.p_ino);
+	return 0;
 }
 
 /* Find the one surviving path so we know how to set dotdot. */
-STATIC void
+STATIC int
 xrep_dirtree_find_surviving_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
+	int				error;
 	bool				foundit = false;
 
 	xchk_dirtree_for_each_path(dl, path) {
@@ -124,7 +126,10 @@ xrep_dirtree_find_surviving_path(
 		case XCHK_DIRPATH_LOOP:
 		case XCHK_DIRPATH_OK:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -136,16 +141,19 @@ xrep_dirtree_find_surviving_path(
 	}
 
 	ASSERT(oc->suspect + oc->good == 1);
+
+	return 0;
 }
 
 /* Delete all paths except for the one good one. */
-STATIC void
+STATIC int
 xrep_dirtree_keep_one_good_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
 	bool				foundit = false;
+	int				error;
 
 	xchk_dirtree_for_each_path(dl, path) {
 		switch (path->outcome) {
@@ -157,7 +165,10 @@ xrep_dirtree_keep_one_good_path(
 			break;
 		case XCHK_DIRPATH_OK:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -172,23 +183,28 @@ xrep_dirtree_keep_one_good_path(
 
 	ASSERT(oc->suspect == 0);
 	ASSERT(oc->good < 2);
+	return 0;
 }
 
 /* Delete all paths except for one suspect one. */
-STATIC void
+STATIC int
 xrep_dirtree_keep_one_suspect_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
 	bool				foundit = false;
+	int				error = 0;
 
 	xchk_dirtree_for_each_path(dl, path) {
 		switch (path->outcome) {
 		case XCHK_DIRPATH_CORRUPT:
 		case XCHK_DIRPATH_LOOP:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -206,13 +222,14 @@ xrep_dirtree_keep_one_suspect_path(
 
 	ASSERT(oc->suspect == 1);
 	ASSERT(oc->good == 0);
+	return error;
 }
 
 /*
  * Figure out what to do with the paths we tried to find.  Returns -EDEADLOCK
  * if the scan results have become stale.
  */
-STATIC void
+STATIC int
 xrep_dirtree_decide_fate(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
@@ -222,36 +239,32 @@ xrep_dirtree_decide_fate(
 	/* Parentless directories should not have any paths at all. */
 	if (xchk_dirtree_parentless(dl)) {
 		xrep_dirtree_delete_all_paths(dl, oc);
-		return;
+		return 0;
 	}
 
 	/* One path is exactly the number of paths we want. */
-	if (oc->good + oc->suspect == 1) {
-		xrep_dirtree_find_surviving_path(dl, oc);
-		return;
-	}
+	if (oc->good + oc->suspect == 1)
+		return xrep_dirtree_find_surviving_path(dl, oc);
 
 	/* Zero paths means we should reattach the subdir to the orphanage. */
 	if (oc->good + oc->suspect == 0) {
 		if (dl->sc->orphanage)
 			oc->needs_adoption = true;
-		return;
+		return 0;
 	}
 
 	/*
 	 * Otherwise, this subdirectory has too many parents.  If there's at
 	 * least one good path, keep it and delete the others.
 	 */
-	if (oc->good > 0) {
-		xrep_dirtree_keep_one_good_path(dl, oc);
-		return;
-	}
+	if (oc->good > 0)
+		return xrep_dirtree_keep_one_good_path(dl, oc);
 
 	/*
 	 * There are no good paths and there are too many suspect paths.
 	 * Keep the first suspect path and delete the rest.
 	 */
-	xrep_dirtree_keep_one_suspect_path(dl, oc);
+	return xrep_dirtree_keep_one_suspect_path(dl, oc);
 }
 
 /*
@@ -824,7 +837,9 @@ xrep_dirtree(
 		 * to walk again.
 		 */
 		if (!dl->stale) {
-			xrep_dirtree_decide_fate(dl, &oc);
+			error = xrep_dirtree_decide_fate(dl, &oc);
+			if (error)
+				break;
 
 			trace_xrep_dirtree_decided_fate(dl, &oc);
 


