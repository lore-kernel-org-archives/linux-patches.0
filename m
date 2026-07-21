Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE4284662;
	Tue, 21 Jul 2026 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663108; cv=none; b=CVXEoe9ePxYIDr+4SPwlTtkW6yK552IQK7OFtTewlyhsY6MWBMe4lgy0TqbRJ6FxSjmp0Voag3qxB4r+aKtOGbe/FQcMjRLml/30Wvsr6oYZ2Gxv/hJ681M7R5cHRAN8SQ1WTnQ8+9YmqHnrBdi3g0PD9M8rMoBN2OkTkd9X8L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663108; c=relaxed/simple;
	bh=YzD2jFIBO97QPAt5vNvlWAP4jqZI5+R77IwVzCee2+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYRAfIeKwWquzCpwaFDDZwqwfqv8PBli6Qz9sL4vnwUUoSvuzZGMe61knS9dE5GYJr3Otk/3PXJDlU/VPeiT4fTX/3RBrnkjJ+GBEtylyGw+QQEn+V8Xud0jTzbt4MAhQ6x9v4bNL07rDrwwzVm01kvPro3ZL0GniTma2Fe50Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTtbnww+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTtbnww+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35411F000E9;
	Tue, 21 Jul 2026 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663107;
	bh=h8uay5K6TjvHNbCyiIaGBojgXj8z92h0uvjgsyukS7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTtbnww+h+1NxgkAs0/J6L/hxAM/8+2uf3v+fscvNaHDiUpiu7fVgLchQulVG+jjO
	 9bt0Y1wLmUlUyybYhWWD4SvlJZkmKHKdmKq5mg1bO8qmdq2PHruITq/AhKJI6VRa28
	 bAS9vjvbRWFiKg+Dp7rKcQSS9f25iRop+ZPNi6o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0699/1276] ASoC: codecs: lpass-va-macro: add SM6115 compatible
Date: Tue, 21 Jul 2026 17:19:02 +0200
Message-ID: <20260721152501.740798573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 893e2fd509e968cc1d76caadee0f5d2f2c72f137 ]

SM6115 does not have "macro" clock, so its bindings differ with existing
SoC support in va-macro. So add dedicated compatible in both driver and
dt-bindings to be able to address that difference.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20251031120703.590201-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0773610eef71 ("ASoC: codecs: lpass-va-macro: Fix LPASS Codec Version for SC7280")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index d44b5b0a80a1c8..29260cb9187d75 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1722,6 +1722,7 @@ static const struct dev_pm_ops va_macro_pm_ops = {
 
 static const struct of_device_id va_macro_dt_match[] = {
 	{ .compatible = "qcom,sc7280-lpass-va-macro", .data = &sm8250_va_data },
+	{ .compatible = "qcom,sm6115-lpass-va-macro", .data = &sm8450_va_data },
 	{ .compatible = "qcom,sm8250-lpass-va-macro", .data = &sm8250_va_data },
 	{ .compatible = "qcom,sm8450-lpass-va-macro", .data = &sm8450_va_data },
 	{ .compatible = "qcom,sm8550-lpass-va-macro", .data = &sm8550_va_data },
-- 
2.53.0



