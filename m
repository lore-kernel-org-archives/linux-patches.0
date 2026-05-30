Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3529B78B;
	Sat, 30 May 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164253; cv=none; b=sRYWRWH84TNdtfyXV32ixLi0ZQ1JY0Zlilw0HBHEZFJdypP9GHzX9ZvD52fl92VN6C0hYBUduC6/hBwx7eCOFO3jnJWzj0pVXrEx7ZkISphQR+nslA7gDSyCqkETsWt+V9Jg+rsf1QaNwzpPwHyEICuyXc7MgpOtR/Kw82YQQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164253; c=relaxed/simple;
	bh=CdZULcP2IwSI0SncK67EH7p20T/6GgSPCkHnS9N0DXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP+/2CODaqwdALTX1I5czLM2VsZptWB1moSHY+B5jVTKNUV7BtIUY0+wPC4TmVDUHReEH93im4kfbLK82JTyNaVu9U7upFuBfecJweCYgjCqjc8cbYN8SJqQu/RwWqp44j3wYnRVh1nhy9hiXq/T9hwRjeDtz4/EK5Gh7RzS+k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ND2SAfiR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ND2SAfiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19181F00893;
	Sat, 30 May 2026 18:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164252;
	bh=MhY1Cz9iLoOuwhzcwNYEvXC0AW1GvARfwstjWFQUx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ND2SAfiRZpk5NgrXsd5eRuHLymkndafBf71e0sujHCMbp9Tqy5lWTd3qUZxOeu4EQ
	 iB+Aq+7M/LMk14iI+VTjNXD+CQzUTJFnkAbc/hn+QNsEoPn5jnZuaYcnT9CklTZ7FI
	 IIy8sZWL3Ll//ITx2arsH3RjjY3+zRKWq0ymTv5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/776] arm64: dts: qcom: sdm845-xiaomi-beryllium: Mark l1a regulator as powered during boot
Date: Sat, 30 May 2026 18:03:26 +0200
Message-ID: <20260530160253.026399019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 3b0dd81eea6b7a239fce456ce4545af76f1a9715 ]

The regulator must be on, since it provides the display subsystem and
therefore the bootloader had turned it on before Linux booted.

Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260320-beryllium-booton-v2-1-931d1be21eae@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 736951fabb7a9..a4ff9e67a1684 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -133,6 +133,7 @@ vreg_l1a_0p875: ldo1 {
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l5a_0p8: ldo5 {
-- 
2.53.0



