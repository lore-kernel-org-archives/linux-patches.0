Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051783;
	b=Kb6c7M0broRXBoEOyOYKP/bgyKoP4xvRdRQW2bA/uL3sMicEr7e8y7fOMpGetRH/swhb
	 ShLt3Sx564BX8N2G2U3Fg1carCyX6Xe0IMymMYSQhgz05tisxPI0l6C3rJRpFtyLEaQxV
	 0gRWY4R9rnfnDva58dmiPLpgV/r6v3uYvgJKVc4fXKoH3sF21CFSc6ElNlHH6sgT3QMx6
	 xPzpoYmkQZ5siZoWtUNyPY+LWHOGRblFU9E5ZbZdTy5B7flnEdkcRXgNJ6qblAgPnxB5/
	 lmMneR2iMN/Af7mEloCVo8xkxuruNVmpAhc1+GecmkxV63NDHR5OncTshCKxfXEwmrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sld7Kn3W28YC49ppOhdJF9mFYO1cNPvt+YyH/HwJX4c=;
	b=mblI3WTNE7Ds9TV2phQa6VIVIZQOyBTMDCzOqWic+TIOeQShSI19MlohEJBEt6g9cZhc
	 mNM5TcuNrZU9TZcnuOd+s76XcQe7k+3b7+A/KEcm7yQM67HpFHrj2VnuoXmpHaie8vlHV
	 lFV+ZnnCWBKCmhnnM7goVmjJp8IqTu9XXlCki91wjHezaPA9Lmyqr26XqsB3/6erUaPMV
	 TvP6/kLkaOoIh6bRnL0dzpgm/KF2MRbd0aPpcEpcxOTqSfYJsemvQz3yMCP3QvVt0NdJH
	 K59EGpyUjS/r4y/srwxUvNwsgz/KayOkO67s9ocM9F1Q1Go9Ap3j8HRudyGCbJnHhmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H/k1Spvb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7F606A320;
	Thu, 19 Nov 2026 01:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H/k1Spvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06001F000C4;
	Thu, 19 Nov 2026 01:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051783;
	bh=Sld7Kn3W28YC49ppOhdJF9mFYO1cNPvt+YyH/HwJX4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/k1SpvbDY78EA7xfPGvfpTIpR7tomCO8/uYOOb9iKaEfQCuBn6E5TvxkvHfy9+21
	 kmHMJrZ5admvGENXfvTwebiMwoGXlQm4RMlLjvEj9dsHqw5Etn4v2qwT2xe5gw9WRF
	 PZC9YNTyNCy5jMJFSxeDtuv1x9uncqQaHnXGpvek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0331/2214] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed, 18 Nov 2026 15:33:27 +0100
Message-ID: <20261118150023.679663216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 49d300a51442bd64b627645b7b0b1cd66e492905 upstream.

LOLLM observes that we never check for fatal signals inside the loop
that checks file fork mappings against the rmapbt.  This can lead to
lengthy delays in responding to a ^C, so add some bailout checks.

Cc: stable@vger.kernel.org # v4.17
Fixes: 5e777b62b0bcb6 ("xfs: bmap scrubber should do rmap xref with bmap for sparse files")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -483,6 +483,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -514,6 +518,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


