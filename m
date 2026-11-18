Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032077;
	b=VoiR1ILYVs36yt7BH+wxOYVzTC0NAmaz8cdUjQcBigO7vpGWHT40KSFw6lk3JFUSDMi7
	 fL3/Qb1HBc+dcd5SrsRLXzEJ4mSLZniJyy5KBzMbRNn/ZfrnwWM+guBtcfdiBhlyOzicg
	 AYq00yT0tH/o/Z9vhBR+y0p8NwpWruUcp1yR9+5Rov8QySpnKBazCMQV8SAxW5q6s0qQ3
	 HZ06FEg66GyJZkus+u95FWrAUXSXKrcuoSscIOwpX5trNOndLI6FgoDgtKx6F+711x9qV
	 M4aCAYQwm4Ao9d4NSdC8LSIP1D0XIomilCUI6yKL8ChFNOW5i500MtmviUIMNKggPUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pW+AbpcmupqDHxn2RqSHhJdvNf+Fx3YX7OGundMsvDs=;
	b=tBBJlqmSvNV2NNvs1iZXxyYHu3VxojXiGySoL0wZ6UnpRLJv1p/OdVnJg9G8rWu9AhlI
	 eCA1yylf580CJdCWv7hA+5gbWIwNUMKzTVEIu3wtY8dkcjzuA5KH4OmqQWbjG/zbVPgIc
	 YkKf3esKoO4tv8CBwlSY55EuNlrpISQfaqIs/fbhGdBycMhYjlM/CvTw/kQeP26JeuW/1
	 thG9ymAG8eB4813rvN1X3FxCk0huJZ8CRKsVIQ0C4M1Vqx5eW51P47iYbeekAW9uKIENA
	 gks0aHqvplD/A5hlXBsKZAb4BIkfov8bLA6XRDL/GhBgA+DtRWU68S5FWuKU4gm2FOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjnqT7uH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D860A2601;
	Wed, 18 Nov 2026 20:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjnqT7uH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800911F000C4;
	Wed, 18 Nov 2026 20:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032077;
	bh=pW+AbpcmupqDHxn2RqSHhJdvNf+Fx3YX7OGundMsvDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjnqT7uH8hvdYbkI/94pH8u8zQQQa+Yd9C5ZrmKu18Zo8Oh/GrCvr7/rKRwbyvgk9
	 ZcrPqXuU7H1pE29dkLXfOgiqqNQyP9QV+874Toi6Sr/h2hBBAphkevUSK7DlLdxqvp
	 g9pthGvQRPkHfb6KP2sI03f5JN1syQZttFBpSquM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1242/1756] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150059.194973299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit fbd3a301b1378423a5cfc23a42e3c0b04e26192c ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index ef27594d6a996..82647e77d6bd3 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -190,7 +190,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



