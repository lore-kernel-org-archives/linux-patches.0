Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0107194A75;
	Wed,  5 Feb 2025 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766584; cv=none; b=j2hWtxYbZAN9eELSug4X2KIm6ZW3rMqJqrvZfmeIw5Uqoqo/yUglkynsU3oteFAkUy10lSLjDMPtndlD6akur/UNe7tDuDwUJ4pHYyKeDoVn1N4Oj1+nTLgq9EoIi8YaUskuxnO1P/UDuAaBl8DQZIxA3/CfuxcHmCpW9ZOwZjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766584; c=relaxed/simple;
	bh=8QGXhGHmkQTiJ7GzxHiAI7vlIhToj4qAa++phIbk+RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQm3QyakTb4fTSUaX+0aNC8b/EVchBI4k/QHzL/U/VY6g3iPOADvb7XG4l5YZCCHQGlj0nyzUTP1junVoKFgWYFs3YsONaU0DMCwqz5NxowyE8CRizoSMSpskQW/fI3Z8DWC2SFjBOB6SPSeQ7wdfBHm8j+V9xX4wio2ihnRFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yd7g+v0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yd7g+v0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCCAC4CEE3;
	Wed,  5 Feb 2025 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766583;
	bh=8QGXhGHmkQTiJ7GzxHiAI7vlIhToj4qAa++phIbk+RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yd7g+v0ei3ujD7V6gmoM+UmTau8t44e8snLp5gZ2aRghvtSPFilH9eu46DH4UsDkR
	 9IVACzSPsbhDxHIKDr6TRn0yQm8hkpfvMFBdCyacTEVuzBSvfiYYy3onf+iA189sGK
	 2x3RCof9iKmwxZZBvEJlwrh404CIY/omWCL3fJwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/590] arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property
Date: Wed,  5 Feb 2025 14:41:32 +0100
Message-ID: <20250205134508.169645629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 02e784c5023232c48c6ec79b52ac8929d4e4db34 ]

The LP5562 led@1 reg property should likely be set to 1 to match
the unit. Fix it.

Fixes: 4ac46b3682c5 ("arm64: dts: qcom: msm8996: xiaomi-gemini: Add support for Xiaomi Mi 5")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241006022012.366601-1-marex@denx.de
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
index f8e9d90afab00..dbad8f57f2fa3 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts
@@ -64,7 +64,7 @@
 		};
 
 		led@1 {
-			reg = <0>;
+			reg = <1>;
 			chan-name = "button-backlight1";
 			led-cur = /bits/ 8 <0x32>;
 			max-cur = /bits/ 8 <0xc8>;
-- 
2.39.5



