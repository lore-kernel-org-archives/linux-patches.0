Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693537E5D1;
	Sat, 12 Sep 2026 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216525; cv=none; b=Na+SBaNU2drQiNn/SMP8P3if0QX5HGrHm2oJYZBSPTZxxOnupY4oTxBfm8NeU3i2D9IGNGEFmVBfHhXzgejUEvankCYesLQw60z9q8e8vgK01YuYePKQ67u9XAZnBKnD5rwvLettMKtxUvj5mKC0YdeBsX/jFGxITBGbCJ7r67U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216525; c=relaxed/simple;
	bh=fm9ZVI7ZlNlsIK4SdW5WtIm6T8wBhTdcgGEEqrdSVwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS3uHVpqh7JwQERKlM3wqgGP1FLhvDuV0kpNR27iKUudoYtdZ0p6/p9Xb9Uow3f//33eRJv2kX7YZ+ronnK4Hfqcai60JND3H9QtqB5dJ76DCLNbWbc/LNj67gz5l23Iy3o66mqBc+pJN2I2kGhOeDFY4uSuWSRYziR8UZ8w2N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9nZl4sY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9nZl4sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E7A1F000FF;
	Sat, 12 Sep 2026 12:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216524;
	bh=J38oqTVDX6ShFpAfc0ZMfbiXB/sCywi4cTQUGaYiFBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9nZl4sYYnp52BwBxyAGp8AIttUKSsosNFlt1Layq93jcJEYUuJ5VhdtolOMvYLpf
	 7Pr8L+mRYTbjWwK+kRNEj173D/8y8vU8C4yyNZoB8SrC7ED+WgWeJ1IQpeC+AyUy5g
	 pLsNoxJiJhf7FzrnymlmlyoNPGreJuz+PvOv77/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0755/1376] arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property
Date: Sat, 12 Sep 2026 08:53:01 +0200
Message-ID: <20260912065624.368448100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c82ea31fb783d9ce4080eca1a7bb855f4648fc28 ]

The correct property name is "linux,default-trigger", not
"default-trigger". Fix it to avoid DT checker warnings and let the OSes
consume the intended information.

Fixes: 3176c4d6b9be ("arm64: dts: qcom: sdm632: Add device tree for Motorola G7 Power")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-3-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
index 2f55db0c8ce35..9ea3e5e76bf9e 100644
--- a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
+++ b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
@@ -130,7 +130,7 @@ led-controller@36 {
 
 		led: led@1 {
 			reg = <1>;
-			default-trigger = "backlight";
+			linux,default-trigger = "backlight";
 			function = LED_FUNCTION_BACKLIGHT;
 			led-sources = <0 1 2>;
 		};
-- 
2.53.0



