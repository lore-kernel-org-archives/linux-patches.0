Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044476;
	b=lLDtKRkIq/2LLuECd7xJpuD016owccLh52wECIrHwELwFmbrrc5iKlR+1x/HVLx+yizj
	 6NZCPJHLK4fJFzE0WXAamzM8QeDjoQWMwb2PBMscgnfhhdWdJ7nauop2jnfzrnesaZ4vD
	 SMaL8RyklqmpuNvoUwca1egqbRxfjyCL2I0V5+HdiywWV0V0yXHKDhl3VbxnmZG07o02v
	 bBGPFHM/YUdAOf5fUgG1HXfKvTTioR85wlJ8zYuZUSACTZGIjiLPA5yWuhpvfSKD2AHc9
	 6legUZxARJHTAWGMT275dX3vt6DprhaBm42F+oNPaeg5zuuL+eNOB7RVqcUCU86YqMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyqKZENVL9QMTM2QfDdIPb80cwwglLvRR8A7lja7FGs=;
	b=de8SSsbMKXXs6NgDXJjpAY0mN7utZqNplG0OD1PKcI5lH3XJASBF3OQ4c9MNUflx/7rF
	 TPnLafcmjFG9j6OPKMDE+/JwVsJe4NQF5SjbqJ2JuhbzodnfAqn8/Yh3IHyT/PAqweLY9
	 IrV8KcunyQr1BKmKecifhQO3+sMJUeWpnZhnIURF1Wg52PEbo5KmDqg+JwqtEQwGRz9vj
	 DURh7uvdDmLwrNMs3jGG0/65vvbpK9KMqSBdMwDvWF56zj5JWPYDozGJil2T5WNJgwqSu
	 hlAZX9n3KRLLSZckmN/DDwFSSRxRKCTb9k+yNu5jVuqd1Aytjj3zPjXBUo0zDfdQrMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7bty9D8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1516606A325;
	Wed, 18 Nov 2026 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7bty9D8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2F71F000C4;
	Wed, 18 Nov 2026 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044476;
	bh=jyqKZENVL9QMTM2QfDdIPb80cwwglLvRR8A7lja7FGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7bty9D8DqnmMRx/Kklt+alEDE4fo9zNOY5XeaCmCynV3b5o8Pwm9nnigIDTUxp6R
	 hVi/fre6Uc3MAo2dDMus9BIrazns7SUykAqI/0A+gz+LqLsj2kapujo367jUsh/7Xw
	 J+X8qyAKAZYITOZ2Lhpe6XJEUO/v9nJUl3FxSvoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0582/2857] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Wed, 18 Nov 2026 15:26:56 +0100
Message-ID: <20261118150222.437791990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -467,6 +467,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -498,6 +502,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


