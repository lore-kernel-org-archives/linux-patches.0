Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32959361DDC;
	Sat, 12 Sep 2026 08:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200605; cv=none; b=rhImEDfqRn5zfvkuCquJqsV+8x9KeCqHaKqa6hm5Qy3oZiCfSbEucMYXDa9FTVS5u+6vnc/HTn70GadMWw4gvZm8NaF+veMoXFoQPQJlhU5z7cUw4NHMr8HWAi4kfBMX2emGUWAwvxVJ/Ae54/406W1ucexIKBqJ1P+qVe94kKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200605; c=relaxed/simple;
	bh=IZkPG0x8OEtSbu2wD9I0zcrpPcER/vFm7HDYKVwsKj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A43tJvngdkbYKmNYuldm3ySrzB2C9E+QclqrhqA3P9TyhGH8TQ2QI1Oz+PlRitwJXIRzG0k7wjD67AyRCRy/ghxVtmvwWjDIwS+cxOazCvPd8GnipEcMrvSsBR38sFkTTPWNgk81vZwcP3f0XWq+rQkv9dc56S4bwY828pdmD3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+xymFOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+xymFOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCDD1F0089B;
	Sat, 12 Sep 2026 08:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200604;
	bh=1pryLnmTELPgvVa+tUXl4DaJ6XCUvnb+XYbcwPu4kTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+xymFOFOqZapBbtspont5rwHSabnHwTG0R/X/RYoX5hz8mN/Lncu1JOIpY6ouAJv
	 fG+I6mw2fa9F3tjaQZfzaqRQI8kCN4b8lFyqoCvVMSsHN0Mv4KGROwKqiT7/6NnrIL
	 gvFAvVzOKBlbCo63yiGkEmBCmvi6WL/Z/O52GkuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0781/1815] arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property
Date: Sat, 12 Sep 2026 08:42:11 +0200
Message-ID: <20260912065707.243713424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



