Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617651;
	b=T1PaKoH7kJj5OO4bd7AsHf/gu2QcUqnXbYp8AxZhTWIEsM87EkNmc11mbmB+RLoRuxhH
	 k6SGqwhl4BFNjj99xpsvNu/SGiR1wRHCX/e/23e24A+f5/Ek5CkWmHVfaVmhnJ8JiovFY
	 WiD/XTFDpBiazDwO+U6WreZEu+maSnwJrG4q6lQR5qlSIeu7D+Xt5t29XBYCQrC9rkjrw
	 yiojXZWQsG93HqPdsx0/evqjgd12vB5fxD17jd1V7zmMJbVf4/SU7KxnIXr5RAazIvKni
	 LqyxWHtHgT3jcd6dwDCfcDC+7Uh3SW+HWYtVXVR+qwcnBC/95J+vZPLqvV+ZB6F5fmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZimYGvOWculRUmKuXTyXuV+iL0bkMbDV8YqSzy2bSU=;
	b=PM1zXOSWdhHhdS9yPSbmoFILAi5IhwY5SXVhCv0mybouG8xwEPwzsZnuIV/+7DN8jFDy
	 MjVerNsPw8AErMGS5a9aFLawawUivG5bDWw7wX8L6L4k+yK7AnPoVuTUp34x+/UJt7bF+
	 +mi4tXr2zpCGEVEZt4fF0JQD4IAF3Bz+NMTXbFVV9uQIPIf4ttWWVqsBYavNVeh381CEE
	 70Lm1F4h1ei7t01pRMMRlPbboUJ/R5vIcABxmp8bQMZrLAOLeoNcYVXHTdUtfuca/WJyf
	 xsg0MenwwRBj01lDX5F6OXCm9lRkbGF565fZN0S2B9jW+EuxsurGO5Ib9mwqrPz8+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j8eiRRK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A15606A6B3;
	Wed, 25 Nov 2026 14:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j8eiRRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0A21F000D2;
	Wed, 25 Nov 2026 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617651;
	bh=QZimYGvOWculRUmKuXTyXuV+iL0bkMbDV8YqSzy2bSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0j8eiRRKGFk8xj3o2QdbWoOGTJy/mfQCeLcEY3yrrrdzl2BPNw6y+1/HKh4AwVU/M
	 mj6WoQmlnr9+CcoC0ZgqNzN6kD+ckzeRQ0nvcoLa76OfrtyedeFWl8mVlEgZtTbzwn
	 78BCImGcqLOauLUrYts8Nid2CR9Xi5FWffHYOZjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a079f084653164a652d1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0033/1005] batman-adv: avoid WARN_ON for orig_ifinfo allocation failure
Date: Wed, 25 Nov 2026 15:22:51 +0100
Message-ID: <20261125143822.513545245@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit dfa953ba5366b0a80c303700dab2bbcbdc5c27e9 ]

batadv_orig_ifinfo_new() returns NULL only when its GFP_ATOMIC
allocation fails, which is a normal runtime condition and not a bug.
batadv_v_ogm_forward() already handles this the same way, simply
checking for NULL without a WARN_ON.

Do the same in batadv_iv_ogm_update_seqnos() to avoid a spurious
WARN_ON splat when the allocation fails (e.g. under fault injection).

Fixes: 7351a4822d42 ("batman-adv: split out router from orig_node")
Reported-by: syzbot+a079f084653164a652d1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a079f084653164a652d1
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 1c2ab79adabc2..084970404d3e5 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1410,7 +1410,7 @@ batadv_iv_ogm_update_seqnos(const struct ethhdr *ethhdr,
 		return BATADV_NO_DUP;
 
 	orig_ifinfo = batadv_orig_ifinfo_new(orig_node, if_outgoing);
-	if (WARN_ON(!orig_ifinfo)) {
+	if (!orig_ifinfo) {
 		batadv_orig_node_put(orig_node);
 		return 0;
 	}
-- 
2.53.0



