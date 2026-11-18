Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035246;
	b=ILsRwVK8Qpwxv/CMyf1Sj49X/MNWe7eXnEfi8NRGVbHBomP9rJ9fQIoaCnOrQI9UHHwv
	 r2VeQHZI8a7y9xC+kvSz6BIJsJWx98WI158NgUZWkmFVaqoenPUATDzj056MHcGpQ9Bda
	 uiXvlKmsG9txkpWUjGvaNoKRZ8RvHHtgLIRa9YUhk3DbonwN8AmeQExJ9aS/SSL8RYoLl
	 y86F7SzKAMLcG2SjsKgllU6MpKAgRMEsaTM+7zRohLuPpkgVDkV/3L2klteNAVZyj5U47
	 tBXf2yLjveIFzgzFTAfZqr00EJ7ycZHKlwHJwBZ04M9R+HjPi0xnVlu5nCV9mKycQTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUyJNc/keVLRXRY0fnAyY+IF8wyLD2WJIDbcq08Dmac=;
	b=w/3cum0KEIxOCd32rbYnB3u3+RWyllfxzHgTvNqMSCWlABe3xCSeh9ukYo+/PA7VMCRe
	 4kdXG57vUHAALvqfDY7PIMhlwpO3SfG5KuPWHP90pcWzoOgeSeySp9mlDA2b/miqaD0cd
	 PAVK/RuWjpiANFm4Een+pWUX+2KdpmyVP1omjujbDz/nDp9oxyGAc+Ev5eRvmf1GHJPj9
	 a08n+v/5gMo/9qL3m7OAtH8s+zcFNyvGHmHDDyu5EXYgSzWa8sMuAHN8pYbtNAQGoBy1F
	 fd+R3pKciau5WfSX3p3TGGJMeEdDfAoyHQkkY6E8CrDpe8nkuF+VTR5eaHiZ46HDHrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fb56s+PT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEB8606A320;
	Wed, 18 Nov 2026 20:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fb56s+PT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12C71F000C4;
	Wed, 18 Nov 2026 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035246;
	bh=qUyJNc/keVLRXRY0fnAyY+IF8wyLD2WJIDbcq08Dmac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fb56s+PTJvJRq4tukSkjMASZdC6SiCATJuXqEnT65ABcpm9IjYrNvFEFO0sCI4y3r
	 Vb+a5WiPpyjUVvfbo0rdZ8Pl7HD5iBWdQ8coo5BjGM4AmR5gh7Q6UHLFIR3ouQGcvK
	 6u6OV+HX6XWRll5vYUU/CIsZxvYwBWHOzzwp9cP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0658/3318] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed, 18 Nov 2026 15:21:20 +0100
Message-ID: <20261118150337.791779423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -542,6 +542,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -573,6 +577,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


