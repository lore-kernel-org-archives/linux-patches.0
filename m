Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035343;
	b=HIrraLEHIdXZmLj+6AbX7I62jiggvsOMjCDAJO5XOuoDdXGEPPhZgN/SVpndxR7JVCOU
	 3EJXDZ9Z7/kpuqhQTw6kaDMf5TE/8KIKuilzl16zijjS2kTo1Xpp8g9Rl4P7hkzLSDU4X
	 Qh/OVG5u13vuwQwW8dpf2DLNtyrqvYe7+7KtwGfA+bQQHffQve6ZbvdPS7WPkIN79J+j3
	 ZELBPUJC01fa9KuPQ3Dwd8Txk1w2LO+Tx7+QIV+sRDeTX4Xw1rEtrXMNMfoR8ywCgEvdC
	 zLZFjyvzG/T3tDCaaPwRQuapy2rSLrUAxp+Nwcf+hjOfxApdphvI3CEnhRzRmCDFlxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOk5pcZF3a5dk0cj8FvImA+yvtw0vbrL23QNcqReQhY=;
	b=F//vDQujgXay/ENX/ziol6vnJ5BoNXEFs1kJb9igt56IaWH/yZqvRAhvrIaj/6zp4yI1
	 3WKTgFSpq3QillBFeVt5YZil+D9AX428liJ4/9FTUliNtPwZ4jJsyOiGRpkyX75zrWLb0
	 lyMWVj5v7CmkH/p5TZEsdki4up2H+XvGX8LHRRn4JdnHHfOSo3uDy3V1o4BGJXUZQLPUj
	 o733sFicMWgLiCei1ZkqPQu3IoPTuRLaANAS9aGZg9m2OA/63b98KWJ/qXV6IcXArUn3Y
	 +GJ13kg8i6sJEzQaB0J+m1ykHXivJh5Wlq4d0RWAgEyJ/C4qG8AdiQYeunHbwzz35ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8utcqNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94780606A320;
	Wed, 18 Nov 2026 20:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8utcqNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DA51F000C4;
	Wed, 18 Nov 2026 20:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035343;
	bh=ZOk5pcZF3a5dk0cj8FvImA+yvtw0vbrL23QNcqReQhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8utcqNYq0CLpF24XUOdY3wcpLZ8R/onvD7AVy6ZFSf2bC55QYTx6mihi29VmDlus
	 udWUAt25RYz9twQGVsr+W3Zy6Qu8+FtYUQ5ralAwzZ/YSCiC5mqm3yzlWDZUi++ppW
	 Jm486A3LihxKHG4O6gPvvbjR/dln9HAMzvJX0CnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0670/3318] xfs: check for fragments when full-extent sharing matches
Date: Wed, 18 Nov 2026 15:21:32 +0100
Message-ID: <20261118150338.220049210@linuxfoundation.org>
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
@@ -162,8 +162,11 @@ xchk_refcountbt_process_rmap_fragments(
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


