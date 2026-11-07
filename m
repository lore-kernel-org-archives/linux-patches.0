Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061683;
	b=srUS1LKjbeKDeEAsKRk5Qtt2aUZpm/spO1G1+Vdquf5jG80GuFqWlMp9eba1HH8Z3tK/
	 cU0SVHjWe3tXz3fombm7nQNyntMaVYFh4pm63Ktd9+Y5bWLxhkNxu43p94c6pSPLOPPHN
	 FuzRLcZXjg/NTttDc5H7jASrTWFkYETd7eIIkMn4WKhEZjpZeHkbBiUrWhfxH+iKEydN1
	 JWLiIlBUk/Dwc3348GogNCmQ3WUmsTC1xot/JgFL4E3mQBxWpIth3oF31xf7f2HuK/MN7
	 kVGsu9jpXYVvwBEHptmE1rlgtY+eH3hqKMISXjAR3lGy+HxTDivniQ7XEja+Qm4rtTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdiYCORGG8oXfulpaR7vpFwJIhlws28j5fPpdWsEcgU=;
	b=1MkgwdLwEba/sc5SSazPQBISCq6nZFN9SeyNcBTmn6lORcdoKDR4/MuRP5gFGmpPNZoB
	 suCzNbgUSpihzjwDZdDySHFkGdDCyJo1eM1C57sF9nROLqk7vIsxLO3FSeZls0mf51zGH
	 TNKr35eXcXA89C3wihgmAlk4Co5nXjx47ugpl0HAv6CNsTdCUN+bkVEne9xUsss/7/4D5
	 ftIsoa5pwPmhpDAVoINUfgAwa5eNXRekCmnbvKCjDhzUQ4TtayIvpAD1QS8Mzjj3kf6SG
	 oyw+xNdHGSe4BosILbmSZy0UvpIWlDck6y4r11mIc43Q06ps5wx0TuyMFflw3/4sxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmImTZeV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30305606A32F;
	Sat,  7 Nov 2026 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmImTZeV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E071F008A2;
	Sat,  7 Nov 2026 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061683;
	bh=gdiYCORGG8oXfulpaR7vpFwJIhlws28j5fPpdWsEcgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmImTZeVCFwu8AJFJIo0JVIWBf37QxPixAUv/j9V1ujZJ4xv8+hBivHZNqeYARu42
	 f7pbDhsvgYKMZYx9Zbi9XdmVKrsEH0l63TrKznj9Dlwvownk2nxMJRbsPfMwJt8Q2I
	 Sp+hqEC1fTac/Ho24oPy4fhyfvxl6yCNDTKwO9lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0734/1536] xfs: clarify various parts of the bitmap API
Date: Sat,  7 Nov 2026 08:45:50 -0500
Message-ID: <20261107135018.127568465@linuxfoundation.org>
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

commit 00f32fdf54983371d39162efef7df693e2842ffb upstream.

LOLLM pointed out some underspecified parts of the xbitmap{32,64} API.
Specifically, the behavior of set/clear/test functions when the length
parameter is zero is not well defined, nor is what happens when someone
tries to disunion a bitmap with itself.  None of these situations are
expected, but we'll define zero-length set and clear to be nops, and the
rest to be checked by assertions.

Cc: stable@vger.kernel.org # v6.8
Fixes: 6ece924b952262 ("xfs: create separate structures and code for u32 bitmaps")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bitmap.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -77,6 +77,9 @@ xbitmap64_clear(
 	struct xbitmap64_node	*new_bn;
 	uint64_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint64_t	old_last = bn->bn_last;
@@ -127,6 +130,9 @@ xbitmap64_set(
 	uint64_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -218,6 +224,8 @@ xbitmap64_disunion(
 	struct xbitmap64_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap64_empty(bitmap) || xbitmap64_empty(sub))
 		return 0;
 
@@ -282,6 +290,8 @@ xbitmap64_test(
 	struct xbitmap64_node	*bn;
 	uint64_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;
@@ -352,6 +362,9 @@ xbitmap32_clear(
 	struct xbitmap32_node	*new_bn;
 	uint32_t		last = start + len - 1;
 
+	if (!len)
+		return 0;
+
 	while ((bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last))) {
 		if (bn->bn_start < start && bn->bn_last > last) {
 			uint32_t	old_last = bn->bn_last;
@@ -402,6 +415,9 @@ xbitmap32_set(
 	uint32_t		last = start + len - 1;
 	int			error;
 
+	if (!len)
+		return 0;
+
 	/* Is this whole range already set? */
 	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (left && left->bn_start <= start && left->bn_last >= last)
@@ -493,6 +509,8 @@ xbitmap32_disunion(
 	struct xbitmap32_node	*bn;
 	int			error;
 
+	ASSERT(bitmap != sub);
+
 	if (xbitmap32_empty(bitmap) || xbitmap32_empty(sub))
 		return 0;
 
@@ -557,6 +575,8 @@ xbitmap32_test(
 	struct xbitmap32_node	*bn;
 	uint32_t		last = start + *len - 1;
 
+	ASSERT(*len > 0);
+
 	bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
 	if (!bn)
 		return false;


