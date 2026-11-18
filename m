Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044510;
	b=YM5s1T9O61BJEb3bLwl2uQr3MIabwvYZmnZguN5lHn//njBfCB6b/dSY6jIT3hQfqv1z
	 rzIRchu7Dz3o8rzFaWJVKSpxY6Q/TD2uv1DRe6QXZnHRtlc5X7UbIQUE6VTDuhgLNQLpy
	 LK+rLvu8whChhxViY5ga6D8QBch59J19ZHV7gAXvlrZ7Hd1bDM+v4bpsZ+OqdTNYPchul
	 A5u2jSLc12BfOHeRWS95r+joeNWJ+kLkuKyox8QS2p/3zMackn2jRZJjpIB8Vm2atbsnx
	 pg8OoZkXDtSyDk+MlO4/R/y/X4bcqayMRI7DZsAnjxSH6J2hBGnYQSkhFj6pgN+cZTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zb0H9uTvN4RxYbAnFFlON+84w8BnUcsnuLW3h7U+Uy0=;
	b=tEn2yRi9EIhqmkNmDJyETKRjp1xqxQZbneHbmLPQqhOskp3QOm/prdORUndFRvaiq0X+
	 qU07jj9FqkbIULUAnF5yT5bvub8tOe7V5eUSUUxQkC2zqPtW3s2vqFSPXlBdrHRYznNRm
	 toHL/aoT2pkIMrihoHqDK83Fq/m7F2aUVMcz4l9jCd1bfh4Zjdcd0JVR/WjvHM5ebPZUl
	 E316sK4kRZuPoZ1hLZeVZrFIXZ5ZM93i/ZxJew6g9Yd9rmUJGP9YHTMJ4iimpVIzSbPQc
	 rgqpcr4bqskM20BIBkGNaemThEVzEUtdy6epPiFqb015RsAWARaq6oQXjE2wJb1tZwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX8Gx3Nc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42451606A335;
	Wed, 18 Nov 2026 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX8Gx3Nc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FC31F000C4;
	Wed, 18 Nov 2026 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044510;
	bh=Zb0H9uTvN4RxYbAnFFlON+84w8BnUcsnuLW3h7U+Uy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX8Gx3NcUefN4JO3IQ7oDfF2OhMFVQGZuqjs+iqsGaKwRiXK06iQujm3KtHyOYqKX
	 mCOH1KxRwMns/VMdebhzPPnM5QjpF+vB4Mnb+jaqpD6gZEnM/k/ppxMGhjI57AVl3t
	 a0Wrrnjll0qvA6ym0QnEe7wKAAikHnPyYM1rGan4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0593/2857] xfs: opportunistically skip btree block checks
Date: Wed, 18 Nov 2026 15:27:07 +0100
Message-ID: <20261118150222.837138633@linuxfoundation.org>
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

commit 4ce244b234c251963fca6dff9de6edf26a209d08 upstream.

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: stable@vger.kernel.org # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -550,6 +550,14 @@ xchk_btree_get_block(
 				 level, *pbp);
 	if (failed_at) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		/*
+		 * The btree block fails basic checks, so we know it's corrupt.
+		 * There's no need to continue looking for corruptions, so we
+		 * null out pblock.  If *pbp is non-null then it's also
+		 * attached to the transaction so we won't leak it despite the
+		 * 0 return code.
+		 */
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)


