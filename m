Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831666;
	b=5pGoDAiy79k5sp+ncpEl2Wbd3anxS5E+2o0ua4LVLSQj4vLVK9qQedRbCWkgAK7OVtXp
	 QajsbSFG8KJQF9rVhDNicSgpjtKxxpJT6E6N69SL6wMdRWeUmWIul+egOHMrF9rlmLLgN
	 wIC/x6P4kwSESxThRVOj2sS6qrhvSVNRNlMtYreSSg0+Vt8NW3g0YNNJvsYrwD7jkdXr4
	 0AQMPqalMuevP5Mit1WJjgOflYCON6bjO5keaqlykKBfT3OTDvyR1hmI3xvZJH9zughxL
	 jfM0Pwpbo6Ccyw4WCnPVNPs/aZlyGaV7uy0xqV7BKTFmpevvHhplcRbvSFpdL1f72KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QxyXXy4zUpfNu5iK1TS+FVzl/1GaNHEaZFqnsjNptRs=;
	b=XA8JsoKlQOBbSa818MUWnT51TU05kNovsSNI4GC5jJLR9B91W0NLLJit0V3rV79rFYmi
	 ud9AQBM0olEOmwROzwh0XceJ5esW+1q1qZzXA3HX8koufVSRo4QXzk1x4q09y87fvR2Fh
	 38E+FO0fenSodFpf2NkgJqkEJS7JC6DjFSGX/AOvBzqIHUbAr3hLKZF6dyxNXaZ0jeOfX
	 j656PMoKTnVrYNhfZZIDg1Q78Uw8ia9LI9NiTmCbJrTSk45qoPX8hyNk78MNPVvLqExWY
	 p1Mm22bZS0V0OIWi1r1soOKjcMtJtboTG8c3baitU7jxd6G4hroIso4CjLCel9iF7eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ago8FWIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3421606B2FE;
	Wed,  4 Nov 2026 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ago8FWIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7151F000C1;
	Wed,  4 Nov 2026 22:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831665;
	bh=QxyXXy4zUpfNu5iK1TS+FVzl/1GaNHEaZFqnsjNptRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ago8FWIWNut9zxa5Ku18SB++h47htYQZBNV25Js8WqCvd+c8QXEkkscHbA3/vABF6
	 rCPpd6oNgKJuNAUyswSCCC1ckKNpFK8BZ0ioIY1iF0JiqBp3HHr6cQpT9bco5HhhL0
	 IqJyRSQ7VJSh73w9iPwjGOLuZ2yn0ULBemgxRIyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0804/1005] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed,  4 Nov 2026 16:08:57 -0500
Message-ID: <20261104211105.871788318@linuxfoundation.org>
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
@@ -626,6 +626,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -657,6 +661,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


