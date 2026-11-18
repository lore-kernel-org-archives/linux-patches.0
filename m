Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058912;
	b=Sq84zucE3wpqAGk6ZeKqYhbNTHhgx5mC3Km/2aUGvofciaZZpqAjdtcT5yQeZmWcdo8h
	 icIEVjhZqal4y3IL4y9El8OK0Bzq7w7ma+jVvlm9FFG4F1Zpoin+20R24O+j3Ce3qPIbw
	 jUi5G5y3cW7CNVtcbw2sUBq6Lgb+y6A0ngUeACWmMLWWguzuoJCFcrKAZiVamdeo7oY7y
	 5ZxvbZr40E94HGwZPFrRkCcR35E1+1/qT37sZQ9pP7pjHP2XDqkQ9LKLWhLOzfbiRkrFQ
	 58rQ82dGjv/EGf0E1X8HgPndRFl4weXMsTgdaRiJLdTtl0SZymEtLjS+iBvqrEJLx+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v8QOcGb0VbBeiuKaHqFrPFHds6Oq5YDlkFDaLq4aa1M=;
	b=QBGwd27Q0SCy2oIQ5bRo2iCaPDg6gZTSJoNWyuZukqiX0uJbBnVLk5hwCnG0sR17ID6H
	 AYrGFORFhBLtsOIuYVA6YQi1dFx6pbUQQczuYLvftn0yofe/2zjpmx5NuindKN8kTRG8h
	 HQfWiCmH2EVG2nS8mkgexdgksbzndkbta5PhBPNq0enjmepVmBdSbSKZv1uhV2V+kWSVR
	 64HScM5qWb0k+QgBhPx6VTxcEtnILKttI0kfXiO47NtRXMJrjFQVCWh5cMJDLDqurVq6U
	 IzbRTXBElvg7onjJmGeLeE5nAjlz7eJkfChsYcLNLVU2wxFaw4A7US6D2JYgX2DOhnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XvynweK/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7B4606A32F;
	Thu, 19 Nov 2026 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XvynweK/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1321F000C5;
	Thu, 19 Nov 2026 03:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058911;
	bh=v8QOcGb0VbBeiuKaHqFrPFHds6Oq5YDlkFDaLq4aa1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvynweK/APX2CjiuHJq37K+fCLx6W4ubWqlpwZEh3Fa4LB1jPDHtI00FUHYjvtVzm
	 XVWBis8E74CUHMQ7WR/s5qzs7M3Nt+AeqzGO7Hu0+poghXWJtQRaFMLYmdzCzrNgLk
	 XDUunbWDNgxDv8gwY2hAd9DzBIX+RZlowvBfBxyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0654/1848] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118145943.171464516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 49d300a51442bd64b627645b7b0b1cd66e492905 ]

LOLLM observes that we never check for fatal signals inside the loop
that checks file fork mappings against the rmapbt.  This can lead to
lengthy delays in responding to a ^C, so add some bailout checks.

Cc: stable@vger.kernel.org # v4.17
Fixes: 5e777b62b0bcb6 ("xfs: bmap scrubber should do rmap xref with bmap for sparse files")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Adjusted loop context to preserve direct updates to rec instead of using a check_rec copy. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fed56d213a3f9..5748545afb5be 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -487,6 +487,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -517,6 +521,9 @@ xchk_bmap_check_rmap(
 	 * entire rmap is covered by bmbt records.
 	 */
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != rec->rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					rec->rm_offset);
-- 
2.53.0



