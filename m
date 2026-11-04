Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831712;
	b=jY/oNfk7Gjwo3ezOieKi0LAntfiQA4mHR+VBIhcDzrK5Ix4IwLKTx+Bw8bYt8yikSwEE
	 F3tbSDhSNkJyXv4CPQoNSPVxF6n25az3MMBuIK6QbTk+zQDrZXp3rJFgWDKjxjGTWUpZD
	 c9WYMfLG8+cYbl/7dGpiA3dYr66V6lkpnovKNz2qdavOfVIPOwUFeqvjHhB4zqt+o74HK
	 I6E68QpYM5N0A2dGuQ7k72NYV9ro0yBKok97t6OPi9UUESgx1+zny53J2I+VJo6DCthwk
	 0r0ouOk92rOY1lQQN8OjoIHWLwpn5u9nXyL31PmofOzdYgvpsv4JB7ItT3lWSKa/CVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=10O8y6j1kYBvPTdFmZEm7iB4pg0ATN1tPkR847hHWRc=;
	b=yGbkXNeTxqdcxC9AAtyvdxkkBWLnKPpjxuLoBoU23KziThw13+rnHplI2HMD1o7JVfyE
	 sIocCCus7uIOrF567neUMxlFklIqI0HLRs9/2HHTkkwRez+isKJ6nNGruhpy/8ku6U68G
	 2rmKEaHyO9zAc/PY2Lqp9ojyyvy6bMcTJs9uQHmDBsOoZqMTTnL8KXGX8NurjPDfimdIC
	 zVTMU5hd2X7djBw2BqMDDRndgATitCa5aUpg8DcJfx7XXYT92caLUZVpifKCfKC6lMw3G
	 +8tSXuo6eXxiOYZN/D25L2/+YR26JKsUz8XqqSJhUYGf0idKBfUOYb+SPmWbLVrgc0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ne18R0/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F24606A337;
	Wed,  4 Nov 2026 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ne18R0/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AA11F000C1;
	Wed,  4 Nov 2026 22:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831712;
	bh=10O8y6j1kYBvPTdFmZEm7iB4pg0ATN1tPkR847hHWRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ne18R0/qJqwjjYNxbI7Y4mARk5HWCvLNNsRolR98GoK26gV7G77NjBwBIVTw93Xua
	 gUFVIVJQu2bj3lOiim+y3x2Je/tR3MTCvFHbWgSl9vzDaZ8EM2rg8HU2Z6Go8Bo81K
	 Cuzqe9rgQMJfxcHM8I64divXEKN71BvvDkn8vII0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0841/1005] xfs: check for fragments when full-extent sharing matches
Date: Wed,  4 Nov 2026 16:09:34 -0500
Message-ID: <20261104211106.879572856@linuxfoundation.org>
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
@@ -174,8 +174,11 @@ xchk_refcountbt_process_rmap_fragments(
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


