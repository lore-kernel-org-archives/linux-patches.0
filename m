Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773904;
	b=YndJxNeT8LeWFPN56Ebkl0iSVJ7ga4V/K1Sa8edM0gwXiOdUJRlxCK+WtI9ZlmZQr059
	 QZmeQdysxEu085OK4RUy5xETW7UnO0hHcbpstCtx6rx8Bf38pP08WrwdT1N7CzfRvicIR
	 l+4xASRMEUJkvL3c7Ren7nWirY7PEFKvrIutJZQJB9YSyLTzOirNxvelGtZ24yC5heFj4
	 0ZBifvDH22YncQDQGQ7tpykqXdJFdbdz4d7/cf+Jy7X6GWb6ZRpuT4bv+BgJtYloWOSuH
	 3BdRfp4sSkeTMxVGZGeRS4Dh1RKo/A2WYk0qpaEkChrX/wgs4NXjMxtTkFmpMLrdfmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGixhJsr8ByY6girIN1fw4X24S69qL4olB9i1MYmv3c=;
	b=DJRJJBmVii+nhR3SboVheGOHY+lfz3Hl53/SkIOxLTIAqSu0R3SXBNN5Z1yt6b/XY7z0
	 dSLrfg98RkDUiklDt2n4ng18WsU1QiFbHe/VvJC3D9gVNO8l9jaIRi872i/qXDtzsGXcj
	 FhbHPBxfXGmdCLnAbvknyzA/8X5/d+nrKUAc2kJuOGVTcE1U/sjz6YnMdneVQLmp3zog5
	 QTSzeDpRW5HYuodR60qzLRYndRsET0rZbDbWI33kkzJdvZTr9pGsS8aFFGx4XBETdOPxV
	 EGdA4W7vbQ5n5rMxXU3ZtA4VXUjf4B8tPynz3JACyTfzGSklPXaJcOtQl4oTuNmZoWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMeLm4D7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2DE606A322;
	Fri, 23 Oct 2026 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMeLm4D7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EB71F01828;
	Fri, 23 Oct 2026 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773904;
	bh=FGixhJsr8ByY6girIN1fw4X24S69qL4olB9i1MYmv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMeLm4D7Lnl6cVEC4uJCYQPndWpIVpsdeAkWBN5S1Ewx03SUoRVOOIaUQqAVlXE19
	 vbpBsmGucwn7J37PNVOGNlQl+a3Bf6vy0QVVJAv8GlMTbTywEy4iANZ8Rhqhte4Edm
	 LKcmErpJfYtldVblRdfp41soCcHq0KXXkDzzvDT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/193] pinctrl: qcom: qcs8300: Fix intr_target_width
Date: Fri, 23 Oct 2026 18:34:53 +0200
Message-ID: <20261023163714.586816851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit dcb5df182b37587d5ad6bb4388751bf5180957ac ]

The default width of the interrupt target field doesn't match the actual
register layout. Fix it.

Fixes: 0c4cd2cc87c8 ("pinctrl: qcom: add the tlmm driver for QCS8300 platforms")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-tlmm_intr_width_fixes-v1-3-3bc1d056aa6b@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs8300.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs8300.c b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
index f1af1a620684c..0819a29353464 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs8300.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
@@ -46,6 +46,7 @@
 		.intr_enable_bit = 0,		\
 		.intr_status_bit = 0,		\
 		.intr_target_bit = 5,		\
+		.intr_target_width = 4,		\
 		.intr_target_kpss_val = 3,	\
 		.intr_raw_status_bit = 4,	\
 		.intr_polarity_bit = 1,		\
-- 
2.53.0



