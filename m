Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064430;
	b=PEQr8+np1nZomSgHr/UCGCYFybB5E2GpTMcNxYQUxJQSj+5PzY9kcX/cfOEFFwvjUfhy
	 ftR6Gfuc8t9MXvNspxNc3URrdpwwXjTbnFqFUMs0tnpN7zFuKn1BYg/7C+pa+g/00tE5O
	 N02dFa4UBDmHAZ99dyKBoVI70HuVdiyIWtiyE7fiKjPUyRlPyrxsynSX3kc+G2p68+T6/
	 K/GqB9Cm1tdzYClwgwDg0kd1i7Wqw4RekobkAbayhIZUOQY1X/8XZAMRx21X8iBF4r3E4
	 +O+z3I/S8Q4RAp0aUZBY4b7+/kPyhLpsbvzI8DIFLK/yVgDaLBYCTwPhpoJEiqRqkag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVQoagnpjswp06qGRUWStKf4eBSlqy7kSJJnKuQc6r8=;
	b=QnGRkFwtc40JfhD4Q4ajHs3CxP1cuXqkaOb6x3yafM6lRcKbUeMvDu/zzLKbJ2KPdzju
	 44wBmb2LbEabzk5r8/Gmdk2On+3KbsK8OjO8vK67E948Tic/jRnoF+JN2RnlPfb2kJsWz
	 GY/relHdjkKTh7yYXcDWdSOFObmhqUFjjVXOlYbqm8G/40rKAkE5ZGU3jTXmP0Ak3bXBy
	 xw52n+ZQQVsiCH8slWsC8oDcFvLZQGcwZ7K24Ukje2ufdYtR937gAqmboExdrDtYJtquy
	 9hZlzDK/mCRL+AcvzOFQsteW0oai2JsZePE4Hcm/MJgYh9/2Bue2MeTnqZfN30y7lgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjH7tZPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F181606A326;
	Sat,  7 Nov 2026 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjH7tZPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D1F1F0089F;
	Sat,  7 Nov 2026 15:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064430;
	bh=uVQoagnpjswp06qGRUWStKf4eBSlqy7kSJJnKuQc6r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjH7tZPfmB0+/Ws2gDb7SHf6E9zDyXs7edoKy4I/r1T/94cEdSLyuPkU6ih1PWpOz
	 OnisTIvhuORktjamMyrstIS5A5X3f+OHoDkYrjFQcoVeV+olPn8mmyGLdHP7JBz3J7
	 Qv98PzH1z1fF4FlFZxhvScU2yfeVRyesDD6qVO/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0479/1257] xfarray: dont crash when sorting if array element crosses a folio
Date: Sat,  7 Nov 2026 08:46:15 -0500
Message-ID: <20261107134952.679811210@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 329750292e9dfbb594b375d7b30cf5ddb58b7bb9 ]

LOLLM points out that if an array element crosses a folio boundary,
xfile_get_folio returns a NULL folio pointer.  If this happens,
si->folio is also set to NULL, and calling folio_pos/folio_address will
just crash the kernel.  Teach this function to handle this condition by
falling back to reading the array element into scratchpad memory.

Cc: stable@vger.kernel.org # v6.6
Fixes: cf36f4f64c2d4e ("xfs: cache pages used for xfarray quicksort convergence")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 69 ++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index dc18c6310cbd8..24e9837211f35 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -794,6 +794,46 @@ xfarray_sort_scan_done(
 	si->folio = NULL;
 }
 
+static int
+xfarray_sort_load_folio(
+	struct xfarray_sortinfo	*si,
+	xfarray_idx_t		idx,
+	loff_t			idx_pos)
+{
+	struct folio		*folio;
+	loff_t			next_pos;
+
+	folio = xfile_get_folio(si->array->xfile, idx_pos, si->array->obj_size,
+			XFILE_ALLOC);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	si->folio = folio;
+
+	/* No folio?  Get the caller to read into the scratchpad. */
+	if (!si->folio)
+		return 0;
+
+	si->first_folio_idx = xfarray_idx(si->array,
+			folio_pos(si->folio) + si->array->obj_size - 1);
+
+	next_pos = folio_next_pos(si->folio);
+	si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
+	if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
+		si->last_folio_idx--;
+
+	/*
+	 * If this folio still doesn't cover the desired element, it must cross
+	 * a folio boundary.  Get the caller to read into the scratchpad.
+	 */
+	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+		xfarray_sort_scan_done(si);
+		return 0;
+	}
+
+	trace_xfarray_sort_scan(si, idx);
+	return 0;
+}
+
 /*
  * Cache the folio backing the start of the given array element.  If the array
  * element is contained entirely within the folio, return a pointer to the
@@ -819,33 +859,18 @@ xfarray_sort_scan(
 	    (idx < si->first_folio_idx || idx > si->last_folio_idx))
 		xfarray_sort_scan_done(si);
 
-	/* Grab the first folio that backs this array element. */
+	/* Grab the folio that backs this array element. */
 	if (!si->folio) {
-		struct folio	*folio;
-		loff_t		next_pos;
-
-		folio = xfile_get_folio(si->array->xfile, idx_pos,
-				si->array->obj_size, XFILE_ALLOC);
-		if (IS_ERR(folio))
-			return PTR_ERR(folio);
-		si->folio = folio;
-
-		si->first_folio_idx = xfarray_idx(si->array,
-				folio_pos(si->folio) + si->array->obj_size - 1);
-
-		next_pos = folio_next_pos(si->folio);
-		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
-		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
-			si->last_folio_idx--;
-
-		trace_xfarray_sort_scan(si, idx);
+		error = xfarray_sort_load_folio(si, idx, idx_pos);
+		if (error)
+			return error;
 	}
 
 	/*
-	 * If this folio still doesn't cover the desired element, it must cross
-	 * a folio boundary.  Read into the scratchpad and we're done.
+	 * If we don't have a folio mapping the entire array element, read into
+	 * the scratchpad and we're done.
 	 */
-	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+	if (!si->folio) {
 		void		*temp = xfarray_scratch(si->array);
 
 		error = xfile_load(si->array->xfile, temp, si->array->obj_size,
-- 
2.53.0



