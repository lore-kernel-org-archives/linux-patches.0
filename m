Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025130;
	b=AtHaw/WLmQshgFQ4Nn6x/dj0k1KqLOSAd0nSsSAEhEngGRgA7milYRbcY/20bWiGv45F
	 c73286By0sqjBCu5gJvUYwRvzllDHrxUGsnTP6Qc50sf5qag9+GfWtoHw18M8KKcMkaao
	 Y9twJJnFHLpsRoOWaqlzvY7Y3BLC+U37tTe74m2q06cXNn05wA75s+zzxb/i8p5z75/SD
	 X9dt67dmYZlQt46t4zBb4hN2cqZwUVWMFpWMy6AzGtwQWnV3gW9CUmEZEYcnBA/fwGKJ3
	 om+CTgCUr932ZLP+Y1VZKCjipAbv0jvDbDsOMz9n85+wM6uxPdOdxnnaNC+PH/qaG2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LFbqkUJq1dSpl/siXFwxeccQlMsVPsHyjAT6CYvYtQE=;
	b=KDin2GM7yyS5O7B8WbpWeD1o65LUqNpo9U6Cs/1APK0Qfok4mljt0ifHq5US+xyANVC4
	 tEOybEWgh6y3x9hY50EmR7OiM8CYOVZ+oLREYvCtU9WCfNNfuJn6R6JvsbHNlRm2Pv9mB
	 GusSPDQj2DvXT8uT3//uZJqv3Agb30tjuHx5ShtyKv6P2MYJ8RBN1dZxGFJWjBbkEiJzW
	 d41X7oohw46ihdhup/gKeHbRHPiIcrAFBlR9leKweurJpgA1meK9CJPw8aRJnryMvCMPy
	 w8ANFjZeCtTCpEQnfdHi3IYfPQqi1iZby/vnaLLTgPkOJeV40gQg4mbuLUAegIEmNHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0PdKC7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A4A606A32C;
	Wed, 18 Nov 2026 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0PdKC7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D85E1F000C4;
	Wed, 18 Nov 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025129;
	bh=LFbqkUJq1dSpl/siXFwxeccQlMsVPsHyjAT6CYvYtQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0PdKC7ZJOePEq1B/NTryJ0KWpsc9ZKvjn+f6d/41xQ2emWluGM1STzxNU5vBUiHq
	 WLdVZofXWw4pceST6NT6MCU+5ME4kJqtT6Nz5gD63SeEMJzaI9di+8xUROUenJ7HzM
	 S80H86No+EDn/evhU3JLN3V8fGzgfBS6J8Q02RCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0968/2151] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118150157.775032684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 8f30b035a6676e292ee8e54334711d9905dd0495 ]

Return -ENOMEM if of_iomap() fails, before reading or configuring
the timer register block.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 9d2aa8c7961a ("ARM/clocksource: use automatic DT probing for ux500 PRCMU")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260911060917.94310-1-bolin.liu@seu.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 2fc93e46cea38..1af223b0e8963 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -52,6 +52,8 @@ static struct clocksource clocksource_dbx500_prcmu = {
 static int __init clksrc_dbx500_prcmu_init(struct device_node *node)
 {
 	clksrc_dbx500_timer_base = of_iomap(node, 0);
+	if (!clksrc_dbx500_timer_base)
+		return -ENOMEM;
 
 	/*
 	 * The A9 sub system expects the timer to be configured as
-- 
2.53.0



