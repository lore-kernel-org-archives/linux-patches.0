Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC10364E89;
	Wed, 20 May 2026 17:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297802; cv=none; b=TIuKxBWnMjaUntMrht9hxO1go22wQo1q2efljmdlnvyncGf3OSRItx3+tp8l3MwTcbfX3GDC7LZ1LBoED7Q5D7fIyX1AeYC/kEH6JN9P9Lpjl8xnkXsSJRb8PkAt/l3McxOOLSMrELBFJE+xX3cfVoJy1aiCb0GKl7cvKNLEZa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297802; c=relaxed/simple;
	bh=q3VGHD0AMvyrS1iyD5mLA45GKPw/lMyZir20I1ZrNOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLzg21Uod5IWxhvO1mh85Ux4JUP8P97pmNlFVIco5r7h3ckBY3XdajtaCh+jpk2axLYWYTD2E0CsQBOfuHMMrYgiDFCsTNg2GLge6U8MF9bz5DC796aGatnEnz24XRid0a8QU3CEv24PMBz26UBefTqJneh4NOG33jO/nmPsHpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTbQeiXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTbQeiXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA581F000E9;
	Wed, 20 May 2026 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297801;
	bh=75Q0A3D5qn9SRL/Cf8ons3rjCXNMgpaay/Ld2MnKrf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTbQeiXt++R8UE0a1xpUalRGOErtm7Zr+3WZl/BwX5i3QVVAzEyQY1gWgjuHyz7M/
	 dOZS2t9eAx+li9beoSl0PF5tpfb/ACJMqj/B1OhwlImlJYc7kfw9oRKU0Hr1fKK/Ra
	 z95bbMFa08WuHAPJNmcg4j1u8z0lxhjzbi9YXKaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/957] net: ipa: Fix programming of QTIME_TIMESTAMP_CFG
Date: Wed, 20 May 2026 18:10:50 +0200
Message-ID: <20260520162138.173839176@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit de08f9585692813bd41ee654fca0487664c4de30 ]

The 'val' variable gets overwritten multiple times, discarding previous
values. Looking at the git log shows these should be combined with |=
instead.

Fixes: 9265a4f0f0b4 ("net: ipa: define even more IPA register fields")
Link: https://sashiko.dev/#/patchset/20260403-milos-ipa-v1-0-01e9e4e03d3e%40fairphone.com?part=4
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-ipa-fixes-v1-1-a817c30678ac@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 25500c5a6928e..30fe12e3582b2 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -361,7 +361,7 @@ static void ipa_qtime_config(struct ipa *ipa)
 {
 	const struct reg *reg;
 	u32 offset;
-	u32 val;
+	u32 val = 0;
 
 	/* Timer clock divider must be disabled when we change the rate */
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
@@ -374,8 +374,8 @@ static void ipa_qtime_config(struct ipa *ipa)
 		val |= reg_bit(reg, DPL_TIMESTAMP_SEL);
 	}
 	/* Configure tag and NAT Qtime timestamp resolution as well */
-	val = reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
-	val = reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
+	val |= reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
+	val |= reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
-- 
2.53.0



