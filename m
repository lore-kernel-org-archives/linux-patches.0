Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018219;
	b=HLrGeI7vy4NY2uvh/19GSgpTTpmmXdNtMRBgWSLxGPGvrd6n1cX4mHj8RFryy0OIJ+Uq
	 Vu28yP196F0LtqU+AFlq9L30j5dx/CU7qYnYGz44eFvns0TlvT8Hxq1ND/8ZXh4lYFxSE
	 ceNEdqt/zOpRSdV3Odps4PnM3BPoL4C62BVuzUwrw2bDTkyyNW0HRWb30QLLngAoISxdI
	 z1Kpnr+jnniAlnX+71gI+OVESdDAQzCbQyvkrEl4/Oaax/8LFrZUljqFqtdLi+kn4sRSv
	 +lz+GewaSXT7Lv9mKH7fYuNY6HCwyAspRc+sOs82XkEd13dZ3fgbDVHzXSQV/Yuo4dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E1O6A8h2NIENZ2bBKqUaFMxYCBqzp3fcYVg+MjQ2Mes=;
	b=m7j30jXJ4+LdSD54dAjTohE6lAFOIJzGyviBSxx3upW9pIVVgZSQc3poNOGkF4x6ouq1
	 2K/1XeYoapr7jdncayhIxyZsNLoxsQYzd8nnwaj4hsJrS0aWow9uEG492NJaszFp7L2D6
	 BOH7Nh5j562Rig5DJYDOnZuRXyYD+AhPu2+XuTsLfB1VxaIw0gDj1cRIj0QA0dWnZJfqs
	 Q8x4x8e/S8NqKCbiPLp6qN6d7U+u0otMK74leWMUd6OfvPRwh/H9ZVlRuYDHrjoAPD2BW
	 Nds1TzdJNsJ36+bBRs4ajUVYioNHfd6A7XJ0WM15U1sZEqh1AUzzBvDvuDX0Mo6unCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0yMq/sYB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBA5606A32A;
	Wed, 18 Nov 2026 16:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0yMq/sYB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5327A1F000C6;
	Wed, 18 Nov 2026 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018218;
	bh=E1O6A8h2NIENZ2bBKqUaFMxYCBqzp3fcYVg+MjQ2Mes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0yMq/sYBpY6FhXMiS8yV1c+AKSHJ9gUc4Qa0bMjoopRYnE53gDq/Nn5PDHSe3G50S
	 k0lkLGJx0d5EsYHu1CoO6UgtOr/0Ll6JALsx8N2WxJdkctm2+dVIw0JzEOq4FWTq9O
	 17SpwRHPU3IARNP5K9gv8hf2IMRszZJoq8Zxli5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1161/2651] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:40:01 +0100
Message-ID: <20261118150329.810459440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



