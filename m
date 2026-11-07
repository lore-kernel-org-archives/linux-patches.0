Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061652;
	b=Df2NqBunhATDodiu/syHdSHERBv0xxtMWwzrgqf4e58QnxX5XRqp0ZUIiaAmJHAE2vxP
	 zTEAz2vr9/+7E6R33CbNBkWLAmfnYs7j4EsR6qhFM2kcnN33x9eDZRKeS9IZEjhgzdNXB
	 a4sbNB+cOdRhodyYzfA+jx540RQds+1sOOm412CFNvka8Ml0hsSFBQCFA7C7lKq3TwjWc
	 MX+zO023ECftVn7gC71BcO2fD3hbG290u8Kn6rsoopeP+P4wPtGv8yl0MiSmFqtT8wAW4
	 lsB/Kr1jWnPYkY2JoLG0RQIivUeBCVjiH5hgijy7W5BWZFfqTaMXlNUmr9BGb1S7sAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0w2dXPIOFXbgULe5Fs+Ip1zKs1tPXsBkdmZH7JcGm0=;
	b=hcSm4PuFzhvFtwKO5QbbjcF2BOY3IA9TvyE73Jk0zMbYVeJS9J7KuBDPnDkjX4foOQFc
	 vncWAscQ8jtcvRJOF/vm9Dt842WSPePsZv38QfJmAQPdEV5mV+btRI898bWdEFTJQ7YVo
	 ngMXuxi9vxhsfpyNManTFusCYfD4FKipojJVFdYSNQxuZsy1rSFmdEAdvKhdCkNIC2tuR
	 Q4SQf6PrUw6meqsAb2dTbA6ctPzG7ILK8CCbohc3cRcEV53EGIM1CxXIpiEVsAsOEKmdN
	 QVGjQC0YCuGo/fC3E3sr9ji3cQ+39UUBeKui5D366PJY+t5fyTVjVuyqhH7wLVc5cMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OxkLMrzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F6606A32F;
	Sat,  7 Nov 2026 14:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OxkLMrzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D0A1F0089F;
	Sat,  7 Nov 2026 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061651;
	bh=c0w2dXPIOFXbgULe5Fs+Ip1zKs1tPXsBkdmZH7JcGm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxkLMrzJ/1Y590/KJbML8SXOW8Q7l3gK5nfbE2AZ4IYVf4WkTCW7hu30xYn/B08Tf
	 3bCKGndivePBZb/FzRFs/dCyk1Jkkbhxjyo6SGXXOWm3F4m94Hg5wU5ValBWaO7dOb
	 6pCZ3AuqmpezIz0TDpmsHi07CMPMth2HFxjFPWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0712/1536] xfs: jump out of xchk_bmap_check_rmap if fatal signals
Date: Sat,  7 Nov 2026 08:45:28 -0500
Message-ID: <20261107135017.496660151@linuxfoundation.org>
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
@@ -566,6 +566,10 @@ xchk_bmap_check_rmap(
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
 	bool				have_map;
+	int				error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Is this even the right fork? */
 	if (rec->rm_owner != sc->ip->i_ino)
@@ -597,6 +601,9 @@ xchk_bmap_check_rmap(
 	 */
 	check_rec = *rec;
 	while (have_map) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);


