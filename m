Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040606;
	b=kh1KIT08KSH8mxoVsvtEEJzsjeAkG3ct93ds9RqA54puwQD2+LpYrgvN/DGsWxn282e3
	 wSQ2fGLOi/K7dqeR9uQLzpVuij/FbFb54Dioz36gIF069+MMo5f5B1NP6Vl24XUU+yS8A
	 EWlr8P0Pba0I7LLMwtSa/JSACJy+K9L6y7yInPC/JkEXfV6uDl4XtKXq0IR+2Eb4qgFKQ
	 +rcRg3NMzgwFsV1/esZUDJxN2j7Tfw0GPBCujaRayvKvEfm5kjVnB07Grm92jDKhawHME
	 5vrb9CMZsOMGtwuEt2815aPjsY82fVuheT3JJZIkuOuMmxw6qA+eRiv1lQR7AUCsedA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jv2fygTQgY/lNa6pUM4L+QktWLAwN9YDuGGILZ4Q6KI=;
	b=Xiatcs7ZWP/PMEgEvSMhCyFfo2nnIokvywbeu+ov0uHNGgkbrhX9ASfoPJRVtO8khVDr
	 rK/Y4r4Ooz7mZX8zG2nrHSZQ0lvE0guUlwByOKJezizREtUywmvzIHV8wF1/hNkAxYV0k
	 sRQo4r5amtGbLBsnqELwNdfwsT2C4iAVhpapjxS6+0EX5spm2HXhqjZ6riF5CalLDFwSB
	 2a0rSJV52HayKa7JNmS1kfgev1xs4ytW4toaicydaXuZcAIF2tyhUWRq/2QYE/NasoSzF
	 Mcc5kyNLHyuwi0FRjvCc92tvBFoXiqW08CQQ+m/qzvKVBodBs0AKO51Npm0TO1Q6/8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCBVwrfC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E71606A320;
	Wed, 18 Nov 2026 22:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCBVwrfC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399FB1F000C4;
	Wed, 18 Nov 2026 22:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040606;
	bh=Jv2fygTQgY/lNa6pUM4L+QktWLAwN9YDuGGILZ4Q6KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCBVwrfCOOzUbRXabc/Kk2Rx4DG1p9lDzswJGr3xMzrEyB0GQrdURJLIOtURemqq+
	 Ds31Gs/XQT0vy/xWvUSLm1V2Iey3IiO/H++PGX+7XPrNOVWev6y+FU5aph7T9ku3YQ
	 xs4nKrECDnqtxvxcSV+ug6rVXpGlv0/E/x6lXaLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2517/3318] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:52:19 +0100
Message-ID: <20261118150436.882636289@linuxfoundation.org>
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



