Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061698;
	b=dTPfgNh9M247pQOf2fSmQ7lkFHpCzWIfO6LgxXAzcNC152KB22hojxFycVnFz++rMNBT
	 BUn7bXXVlPaHtZPeWVUViLmo0kEq7RK9CzhLS8KUaRwrsYeId1FznCvj2cgA91k1CnqHF
	 bDZh1cCJZgASwnXquW5w+Y7f6cc4zHL3uByhWl/rGL3qVn/OvoNuv7JWfSi59ksLrPRhj
	 bb/XX9otPioKcyy3y/JsnlIeK3++S1EtS4EsOYSkK87pMjyZE1KeC/Reyz9ts/y2m6thC
	 v3w2SGeBOvSNrbAtUTjsvuQtbn22ZWuCCkRL3U78Vd70pv0HJJgEsu+KkNKctyDXr0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrar5PtGVUVAra+5Tyj146nX18SQctWxAEnhr1HBUo8=;
	b=zq5qAooOlaDAkMrMoqzyVsfboLD0twlCvyZqivlZjfgpS75FVjzuJoqIZaXku3TJOV3p
	 IiOvXzEjcn2lCtlUwEp2+Q+b0Djo8EwblC1fFldFQoL4qfF0t5o76YMfl4xwgf+H9IDVb
	 p1zizOdjaDvN1MN8jWBbJVB5aBfkyXBdFOTPM3IPxDmszTlEZJAkNaGKpdbpAVY3ZNdo7
	 FptMOgeUhdDO14coRj8I3sWn7h532NT2akxF86HS413quMSKvcw3q6vkDKQIgy+O9QY6D
	 XxaRYqCZitghxOoSFtPgOrcH+6G6E9QRBY8j4mVfbdTm8SOfvPLPLC5jzzVN1BYw9dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH3UUtT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB7E606A326;
	Sat,  7 Nov 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH3UUtT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787811F0089F;
	Sat,  7 Nov 2026 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061697;
	bh=rrar5PtGVUVAra+5Tyj146nX18SQctWxAEnhr1HBUo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH3UUtT1FKw7Sx4FW+dsrUcMCskyhp2cixBElyPLGIWVytcey6Sk4EoLfa2c+UxMu
	 10b5x0qHXnKV/HYu6b0GdVgerdITTDRIlPncKRi/V0NC/d5ZevMjmGcjggaXtaPYyA
	 T+aDCT5E6oWZpLU1zLQwZ0HW5W2O0j8Y7IdxeOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0709/1536] xfs: abort dirtree repair if the live update hook dies
Date: Sat,  7 Nov 2026 08:45:25 -0500
Message-ID: <20261107135017.413731016@linuxfoundation.org>
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

commit 07732dea4f5d0410e1566b81a58a1154bf9dcb29 upstream.

LOLLM notices that if the live update hook for the directory tree repair
code hits an error, it will set dl->aborted and stops working.  If the
repair code ever sees that condition, it ought to bail out immediately
instead of continuing with obsolete data.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -831,6 +831,11 @@ xrep_dirtree(
 	 */
 	mutex_lock(&dl->lock);
 	do {
+		if (dl->aborted) {
+			error = -EIO;
+			break;
+		}
+
 		/*
 		 * Decide what we're going to do, then do it.  An -ESTALE
 		 * return here means the scan results are invalid and we have


