Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604B33A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301918; cv=none; b=kpXILx2FRAVY5EUw8BUa9s2hNC4Iadw+jfceSp9GpeAp52QsaXaz6BqzSSKAi44omHLv/tJnsMBhFogzSP+FuYtfueWcXki8jhsszHiV80plkg2Cx7vZNuUfAtahnY/vO/+YwiKYDdybB7kjQpO2xk+tY0v/S///ZWFNHmsDTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301918; c=relaxed/simple;
	bh=SnCo9s7GphGJtEX+BIwUKZYott4qnZNm4M35yIZca3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANPfuMmEXJUnl50koiFg+Tj3MpEjo5qxwSHf3dfcdbDrhWYDyGkSbodMdV9RzOQOp2L0rbfI2DJg59U8/3S2ln09iwaJP6Uz815CRpHOaSISkS7Vm/CD9ZL1Tb1FHaBJgiSZqed0LLuZ8XQVQ3nOuiLMi0hBBsHXxxhoPSZUn64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsATevZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsATevZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE797C19423;
	Sat, 28 Feb 2026 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301918;
	bh=SnCo9s7GphGJtEX+BIwUKZYott4qnZNm4M35yIZca3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsATevZd7s4gGSOFynh63WSsJT6aT6zsaYDxp3l+hagm/hWj4q2zsQF2WV5REm5Kb
	 XGadHM15AC8Voq91c6CeNQKiHsDKgGGQnWj41NTRRpkPdT97hGmCwJgwUxPQOG4Fuf
	 TyMY22xYq7JbQINJ1PGChcHMWUhc+LExyG9EW9Bnv0OmKdySdCVwetLPsGjsgyj6cl
	 8QqP/GUN4sd7aupqhLp+IovjA1j+4FqK1AezkLK1pHHe+UCxuC7ordQJ1aSl8wZjyv
	 8JQRdI6yDLY6kEI4JTkn3y1gOoVwJdfBFaDaTz/g4S3ox7EuYTNbP7p7dw8sKhRHPK
	 C3nkUatIQv6Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/385] backlight: qcom-wled: Change PM8950 WLED configurations
Date: Sat, 28 Feb 2026 12:59:33 -0500
Message-ID: <20260228180011.1568201-351-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 83333aa97441ba7ce32b91e8a007c72d316a1c67 ]

PMI8950 WLED needs same configurations as PMI8994 WLED.

Fixes: 10258bf4534b ("backlight: qcom-wled: Add PMI8950 compatible")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260116-pmi8950-wled-v3-4-e6c93de84079@mainlining.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 79337e84069fb..0d55818f554ec 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1455,7 +1455,8 @@ static int wled_configure(struct wled *wled)
 		break;
 
 	case 4:
-		if (of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
+		if (of_device_is_compatible(dev->of_node, "qcom,pmi8950-wled") ||
+		    of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
 			u32_opts = pmi8994_wled_opts;
 			size = ARRAY_SIZE(pmi8994_wled_opts);
 		} else {
-- 
2.51.0

