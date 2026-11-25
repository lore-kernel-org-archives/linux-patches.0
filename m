Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617658;
	b=S+kOYLXV1PUMRePi/cgarB10hgtCRJmQGHg6w1Vh5IBYAv2kF2q8G3Feui4mp9A5JMGN
	 6KyeRTPyVgX4XE0mMXecRUePOHc/wS4lGpANIhYekG7MuAizjjc3E8nvj9rPerGDaYsk8
	 Yvh13VvU/7HhTfaqSaBu87c3u9EgQ8ZxXAIv6AB8AvIpQC2xTWtH3nTQsZ8oiJ81bF1kC
	 jQJ9WOj8AoqhQVIQ9+dx6iQtM4zL5P2dukH2ga/GFnFuw+skNy/vX2v2mR/pet+Kx/fBm
	 v73MQAWCllTn2WcebjMhxtS99HzyKPmmjx/risE3FEmnSVrsN8M2Y9jcMqEoPuKUn5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h/YrPR/LCS+ggtZg1hjEaP4eUCtOUuH4ZZOwU0E+1bs=;
	b=nykBr2Ssy+9qLOkgIbfBxqAqIifd7bvhtkIzlaCNcRlyoWkcO8YyuiA0D0qwIXc/VNxW
	 jIdnZlEFo/Z8bIBMGTEKlVBkkWXzDObTVdmkemPfj915hbk7kHFaIJT9kaufVhJbDZceQ
	 Ky6NzxGq4ShQhXSItd5HAL1bSU75A/Huhi7sQAmzYQmOFdDzgukJ7BWelAQtFiP1fNwIi
	 FRgfmcbiZ8Wn19hx8BPTDzC7I/PYvUATvZSmrfjquTP91S4cCTwOXcr3f2cD7XeRXBXpF
	 viXC7f/KqUs8aHl+6Ib5Sixw5Ysc5CDqTBWQqEt+zpYb3N4MvarA6YTacx+MchcTP3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTJQee32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2160A260E;
	Wed, 25 Nov 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTJQee32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC511F00AE3;
	Wed, 25 Nov 2026 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617658;
	bh=h/YrPR/LCS+ggtZg1hjEaP4eUCtOUuH4ZZOwU0E+1bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTJQee323cy14r76ufOeHMIvrzfHkgSFl/h3wzYq+R2zbAJs4/O75kivnOXw09I68
	 Q5gZgx/p3+Ww90XxvKBhgdNwqLxoxrC7uGMYPJXQqu89LWL/bdk8RDHo7Pf6rss9pJ
	 zcjHqv77DzQxfZV6H4/cEsIoJqfe9SptiUGp3+ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0035/1005] xfrm: fix use-after-free of migrated state in xfrm_do_migrate_state()
Date: Wed, 25 Nov 2026 15:22:53 +0100
Message-ID: <20261125143822.562642369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 3eb841b771e81e0692b3ebfc75fdb774022cc4f6 ]

A concurrent delete can free the migrated state before
xfrm_do_migrate_state() finishes using it.

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fffce22389e88..48b8a0af95e25 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3479,6 +3479,7 @@ static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
 	__xfrm_state_delete(x);
 	spin_unlock_bh(&x->lock);
 
+	xfrm_state_hold(xc);
 	err = xfrm_state_migrate_install(x, xc, &m, extack);
 	if (err < 0) {
 		/*
@@ -3486,6 +3487,7 @@ static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
 		 * free under xfrm_cfg_mutex. Both SAs are gone if it does;
 		 * restoring x would risk SN/IV reuse.
 		 */
+		xfrm_state_put(xc);
 		goto out;
 	}
 
@@ -3504,6 +3506,7 @@ static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = 0;
 	}
 
+	xfrm_state_put(xc);
 out:
 	xfrm_state_put(x);
 	return err;
-- 
2.53.0



