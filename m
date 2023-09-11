Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542FE1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8FEC433C8;
	Mon, 11 Sep 2023 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441257;
	bh=Hx6eyoBYnb+pnGzYPtggFA0mLHPBX3H3UkMymILi7t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YanaccKYaPOAulhXKkCDpO0SsDzdAgwPuBGRPPDrCzT1egk/xVOg1aJfpzcrWE17R
	 jBqFkhdcbhcQkPFbP2TF4OT7FAtFFQtfV2sGBUAuOyOm+oBUw2+3VuP6Lce0mZPFnZ
	 VRB/djMOwIEv6uPLNa1d2T0TJeGhAG0HEuA17m4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 350/739] arm64: dts: qcom: sc8280xp-x13s: Unreserve NC pins
Date: Mon, 11 Sep 2023 15:42:29 +0200
Message-ID: <20230911134700.896062096@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7868ed0144b33903e16a50485775f669c109e41a ]

Pins 83-86 and 158-160 are NC, so there's no point in keeping them
reserved. Take care of that.

Fixes: 32c231385ed4 ("arm64: dts: qcom: sc8280xp: add Lenovo Thinkpad X13s devicetree")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230803-topic-x13s_pin-v1-1-fae792274e89@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 7cc3028440b64..059dfccdfe7c2 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -1246,7 +1246,7 @@ hastings_reg_en: hastings-reg-en-state {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
+	gpio-reserved-ranges = <70 2>, <74 6>, <125 2>, <128 2>, <154 4>;
 
 	bt_default: bt-default-state {
 		hstp-bt-en-pins {
-- 
2.40.1



