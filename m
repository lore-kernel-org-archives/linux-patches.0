Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044505;
	b=qDcSSA6hifwUrF7Fh15eMDGhVARKdcSCh/StejIhQKVHAmqBf8fDmQ83iZwT3PNPDqvm
	 xh2qxN6Bt35DVynBVsebsLZUFOQ7t7Vtcug3uQBdKKKJweYq1yRgtP4W1qTI6EAAe0Rx6
	 qi6LaD/z3raU//FgfXOgJkRhLdQUd6aA7utOPFZswqEKZGzat/GrAHojW7+Zb9w1XWepP
	 fqQPZPwlstMpn7Wk5Fh32Rc2adHxqXu4nPywFyylpHypfEmH57NWjJpU3PRsdgoUw9JD1
	 Rtia/I0gUVFqxYsH1O/wie5JC4A3+Ak82MkpSxL6X/Sr4VHzxFMxErwkPpDfAdgTDDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YotfEeY6C+cfvPqG9OQ7lEbVpMcpREgvJRvcn2l/xEQ=;
	b=quWQQBvLeozbrl8VgrYUVQXtMg+zgmUK7W+4EoZJ9gclhRjMG1HOUMc6sWLe79tZcDxs
	 C1jMcyDqS1lA2wiYi8RCx5FM/g5AhUSdIlry/+Dx3xuc7pg+H9O5PnrlTblrKswUec6JP
	 QVaTP920HV5jA2eXebCDsOrjv13nLgb7Dxq/oinoSbQu9yVE5bz2MKXl39X4aIJbNPD8g
	 arwV7y0xxSWLzISVHF1TZfIDlX0jCFFwVTDQ4DrxMnN7phkpP3+n4TNPKqIhg4D0h6/65
	 g5IzcIf8m76JcHkPrLHxO7b4iwuhuJRB9rtuiD2GujpUpOUqimbpGHMoRcwA6Q7OBhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWIxP+un;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28C606A31C;
	Wed, 18 Nov 2026 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWIxP+un
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1981B1F000C4;
	Wed, 18 Nov 2026 23:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044504;
	bh=YotfEeY6C+cfvPqG9OQ7lEbVpMcpREgvJRvcn2l/xEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWIxP+unJKvyzFNO+cq0I0cLghXTSzbFyBk84QWed77+GuwqxY2Fc24EON0HejoHZ
	 hzbJRGi5XZEVWgT6N0JmaTAkW5PVFB0KV6BfoCy4DEgPxL5jBVhZeE9Ky96WT6RsTf
	 lVThcjfQadX7LGSh8aHtL1stF91lVsWj38Sz18lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0591/2857] xfs: check for fragments when full-extent sharing matches
Date: Wed, 18 Nov 2026 15:27:05 +0100
Message-ID: <20261118150222.761608368@linuxfoundation.org>
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

commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1 upstream.

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -159,8 +159,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)


