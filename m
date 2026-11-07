Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063923;
	b=Ejus4RawzyPJVIrTrD5kzXMM8WMJEQ51PsLbtsmGDIVsr8tnejsHvaa0A7UJI1sLqoB3
	 rkBpZGarw3bKAG5vZVPXwIiSNAvQFY5S8cVpkSXnnL6EGqlmugOmPgtDwbwoVFXnC4Ci1
	 48QrGxc4UmYoK7zYzOZqDyicYyyFbwk8z09R+O9TZX0ke5Se0F0/n3O72T50zOoMTgNJr
	 EMEXHkRDuSZdxcx4sc5Y52s/4eLE+sT3b8WjbxzNnd8nUdwQaWuIYTV9AShEuCnRYC1Jh
	 iJbQzXUGvzQbP61dx42sqnNHkbDq2PSqLy3tFhs8cnT1w98ofzcvGHbuSiZKrEe9pfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqJIzZjeGW871mTsPQ17IO20mRNuUCrXE5fYBQjkuzY=;
	b=BOGD5C8K+AJ0Y/aAeB6xrW3wZVRP3mJlGAY+EXjPP+A8isGsOGJXSa4OH1+wUCFGUpUl
	 ppK2TBrG3x8yYBYOS156scNVUG+tAgyUUMk/RtIVzQuffyuB+90gOmBLROn4L9gYMqnZT
	 eNOEV/GQtF3+3ez2680DDd2KBWfFurpUxPZGmrarvJxtXVwRat6KhO0qBB/+9sMaY4C5v
	 5kW6itQT9b1c5FS/uZ4+BF2avtpNKwYqqEikOgW2raruGCASS/tz6fFsGPZVl+owP0Y9K
	 FJ8U3TyTvHNbxhz+sVQrQCTPGJ+pQcRCJxG3PWs7JhIddE7xGYwns8CAKo+Ue+ULlmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TkU5l/Fs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B375606E8E9;
	Sat,  7 Nov 2026 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TkU5l/Fs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F461F0089F;
	Sat,  7 Nov 2026 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063923;
	bh=rqJIzZjeGW871mTsPQ17IO20mRNuUCrXE5fYBQjkuzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkU5l/FstDzInzhKEsia2xbzyKvmedTAIHRxRP4S67djOA6462l4FSv5ptD/y2vIG
	 CHn7hbMVHELaxShDPosVEozPLTZ+bKAqgTcTFKFq4KgdcCWVShmWxeuCcx13ujLolc
	 aaQaB9oUEWjTI5BMKY7HuYKl3IUoR49to+xsxhqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0118/1257] pinctrl: renesas: rzt2h: Fix used_irqs indexing in clear path
Date: Sat,  7 Nov 2026 08:40:14 -0500
Message-ID: <20261107134942.598987864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit c0de88659b68402ed7e53fb998a058ef430c787b ]

struct rzt2h_pinctrl::used_irqs is supposed to be indexed based on the
parent IRQ number.  Do the translation using rzt2h_gpio_irq_map and
clear it properly.

Cc: stable@kernel.org
Fixes: 829dde3369a9 ("pinctrl: renesas: rzt2h: Add GPIO IRQ chip to handle interrupts")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260817185700.322370-2-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index eb70aee39f1ae..a37f1e3994467 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -1050,8 +1050,13 @@ static void rzt2h_gpio_irq_domain_free(struct irq_domain *domain, unsigned int v
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 	u8 port = RZT2H_PIN_ID_TO_PORT(hwirq);
 	u8 pin = RZT2H_PIN_ID_TO_PIN(hwirq);
+	u8 parent_irq;
+
+	parent_irq = rzt2h_gpio_irq_map[hwirq];
+	if (parent_irq < RZT2H_INTERRUPTS_START)
+		return;
 
-	if (test_and_clear_bit(hwirq - RZT2H_INTERRUPTS_START, pctrl->used_irqs))
+	if (test_and_clear_bit(parent_irq - RZT2H_INTERRUPTS_START, pctrl->used_irqs))
 		rzt2h_pinctrl_set_gpio_en(pctrl, port, pin, false);
 
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
-- 
2.53.0



