Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046097;
	b=pMKmo0wvn7j2jB0Kacbr1tngkpeeSoDVnmfo00vtFmLdYJ5/Ngl7EZkntVujx8Z+XgE6
	 Lu7i608wrthms6myaKVM1rfyIAjtNfAT6QQAIe71SJxWalxAd2KNyqGoXHkHKIQg2rhFz
	 K730vQvL2mQsQSgt5OOAwGiwniA5x4AXdarr/jifNsn+v7H3Vh4C5t8JEoZfg2tnT/0xF
	 Bvz8JWk/G+2uV+aJtaroSjhLzxSLE/05JN/gyMcPzI5dZghv7G9yOBJFVod7Zb+usfPbk
	 eGSad1LL8o8Vn19q1S9UQhwyUEOF3glQ1sZaUfquZRITrbeGhttryohW8H8MXZwJ5Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DlLmMMeQXbloeMUfOP37gIr0qMwEN3SiTlrfL9Er1xU=;
	b=0HO7+AaHXA+LNgZe7zCy39DlOvSkHAPvkCGdvA4eS0y+xnP9LmzQlPd11g2TsiJt6Lwr
	 LCreMDpNj6oXxxBlIgHle9oC8sadOGGlpPqbpYdhg2coa6aeUO+8Yp99H5FQKZnZpHRgR
	 v6ekVwjSfcdB1BQ0fH88ZXif9+OJOc5u2So7/Q5PaUdl9DoEwp1H9tzRLBFJvKrrxdTbC
	 O17qkIQOozbzto9e8gkX1zjL9F9r6SmFiBrXz7RLGx8K2m7+PpYtMKSek6bkDr/P4+Rx3
	 SaGmf7jY8j1iJiBieO1yMN6wKVADmgQE1GNrzJF4w+E5pdrYuKgyBI7Xry43xZbUDxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7Uu5q0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EBE606A31C;
	Wed, 18 Nov 2026 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7Uu5q0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CC21F000C4;
	Wed, 18 Nov 2026 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046097;
	bh=DlLmMMeQXbloeMUfOP37gIr0qMwEN3SiTlrfL9Er1xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7Uu5q0q2HlicfSz84EaZQ7cafEXQ0kakSkuOdV0cqFHq3wQOMDPHTMgSBRovT83D
	 S7fH6OP53rIEvzL+Ys3SXA5kuXGBA4Y64H6o0mSPTjA3ViAtKVnG+64ig8EcKzlzhL
	 2C6r8ddmWL6amR+hfNxag6AZBLVVBdgeUTvVMwEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1157/2857] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed, 18 Nov 2026 15:36:31 +0100
Message-ID: <20261118150243.245949701@linuxfoundation.org>
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

[ Upstream commit fd012955641881169a9f01a00f656f6ca73842ec ]

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: stable@vger.kernel.org # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted the check to xchk_xattr_listent() using sx->sc and goto fail_xref instead of returning -ECANCELED ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index dba6b6bf8e3c9..47c4bad11fcea 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -133,6 +133,12 @@ xchk_xattr_listent(
 		return;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
-- 
2.53.0



