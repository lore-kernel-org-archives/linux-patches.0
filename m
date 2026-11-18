Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061120;
	b=q16VaVJu5DHmi0A2iqwA/6TMxC6EPjgVKkBRqOfUrUsKlvp5kWKBXHvaMbZB1kYvHbbN
	 xFE7VC9+LVdN9ct4Jl6sMtm4Zqy4QBLJ5jvConkS7chfPKz3Noh3KQ9y2PK7RunxIzNjE
	 9Y58N20t1HfHTC8lnMDECeiMW29J05McKEtu0sNo+Hvl6DH2ZMmaa4EK3kqsbN1E/IY0s
	 pOLbgugCePqpNU/h3cVcvHYmrto4SKGBNRLMzevp8PddZzsNAPEMVrys4ybWRDp9XZOfO
	 dTzwgKnpK7CvnuU/8ZQEg+jc9izihnRO/iz5d/1c12VCfAaKycXuSXEpX52l5hTDkZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TTKvnvqr1q+hZ36KR6q+8WoyD8iKM1WyTOOHGnG8Bk4=;
	b=V4dGy0rhMDdw9V1KLOOoQ02PGMiNq5SZMS3QBpTdij9LZ//sT2ahUiSl1Xb6Wborq4Lm
	 i7sSsI7kq6hgCAh+asocTAwBwUogtpxA6HkilTyhv+PR9acFOI5VVbkPUOrV0h4jU7bid
	 azl1RKGh6nAMf+NF0vug3jLlzCyf42YNdspNTwjvRY3mg3ndI9xlm5wS+QwabmETqIu7r
	 +8KFPd5aRn2Jg5PLPxdJRMBq6KBGonzJ6R9tClMc6gt8AcsDHxsDSAdIYCQlBJqdEamaQ
	 yORL1vNNhuNfCm6dZdrC51aMR5/8JEkuIAjGgi4GEnYWJEAzL88EONPFb82YXyqibig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OSx+I/Oa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF7E606A325;
	Thu, 19 Nov 2026 04:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSx+I/Oa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE21F000C5;
	Thu, 19 Nov 2026 04:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061119;
	bh=TTKvnvqr1q+hZ36KR6q+8WoyD8iKM1WyTOOHGnG8Bk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSx+I/Oa7lEWfBs6EQU8/At3deMuhdLpaD5K8bEUNkmmj84zj6IgglSnCwCKmCOs8
	 HMQq/siKyu+4ZN0AhyL3CVQsKfVGw/My9TYQWEIrDmJobG0cFa48IN/t0KXDafoY5G
	 p6hpF1MY88T7rCNuTm7FjlplfKfKb9NereO1kbIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1439/1848] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150019.728298380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 996900d017c61..1502d3438119f 100644
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



