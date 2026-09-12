Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1A361DDC;
	Sat, 12 Sep 2026 08:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200600; cv=none; b=eKhshoV1R2lXGfwNzWt04q6QDcx25OUni109bEVzZ39mEeoT9e+/9l+eF/76c8yqZdcADf8898VzxZ1GxQu+EHmHJCJ5RtP3matIJgtGO3dCu1InMEbyJccrMFghRxla+6/KR6U6b6PbNwhHb3lUrMVTyLY7dIWJ12UArlcLIus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200600; c=relaxed/simple;
	bh=IdeNrgcTpjS5QsXd7PMT/CPrWscP9TZa6NKvoJ4Cing=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMDYosH87yr4pOzUGnvNvL/A6BysAM4BeopbEyHmpzSgX+pTGEiMmk4M02oDj16KOs/zuq8NH565sknLJm+Mvs8VnEOA8yAN9vAmnLWvRoLBNoxN+9IuS04rdiG8MW+DuLSmGmQtTWIoVB+AM90JT+SPU7cZaIpZndGxSMZRz9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hf36zMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hf36zMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6B11F000FF;
	Sat, 12 Sep 2026 08:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200599;
	bh=JFF9KUrq6jSpnMNvmKRLTRCRjNAVW19nBP28pYDDcYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hf36zMrMpWBngD1FCgmPv+X3l0xTW5inwX+I7JQ8rvunn1hPaUYqIaahWcjqxqqr
	 GkbnW7HW9lQ/MaNkYtpqljbSCEmSArxOBE3Wrgp9RMTE2lujNRKrVwqlOHvYeM0vDW
	 Fj2mq0abKwXJKp0lPx4jjtGt9b++ZF22h+0o8G4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0780/1815] arm64: dts: qcom: msm8976-longcheer-l9360: Fix accidental node override
Date: Sat, 12 Sep 2026 08:42:10 +0200
Message-ID: <20260912065707.220144718@linuxfoundation.org>
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

[ Upstream commit bd0bb7d97773026c9f5d5f8ff1dcf987f8051045 ]

The active and sleep pinctrl states for the touchscreen interrupt pin
shared the same node name, creating a single node, accidentally
overridden immediately after the definition. Alter the names to make
them distinct and to silence DT checker warnings.

Fixes: 79b896e7da7e ("arm64: dts: qcom: msm8976-longcheer-l9360: Add initial device tree")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-2-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts b/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
index 18832a3b9a1c3..57f549f06f73c 100644
--- a/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
+++ b/arch/arm64/boot/dts/qcom/msm8976-longcheer-l9360.dts
@@ -455,14 +455,14 @@ sdc2_cd_sleep: sdc2-cd-sleep-state {
 		bias-disable;
 	};
 
-	ts_int_default: ts-int-state {
+	ts_int_default: ts-int-default-state {
 		pins = "gpio65";
 		function = "gpio";
 		drive-strength = <2>;
 		bias-pull-down;
 	};
 
-	ts_int_sleep: ts-int-state {
+	ts_int_sleep: ts-int-sleep-state {
 		pins = "gpio65";
 		function = "gpio";
 		drive-strength = <2>;
-- 
2.53.0



