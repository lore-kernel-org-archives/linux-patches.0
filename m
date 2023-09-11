Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219B511710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979CAC433C8;
	Mon, 11 Sep 2023 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445336;
	bh=shkzRltcLTmXJD/XfSU9ec923aUUSFPshvbiJtfvuOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYVFZYTIXT69d0OaV4nEvfuOjvcvA6XAWKTk+4boXFzjXtSB7M2MCE5NfuESAb7iu
	 7z/uUNYYTjhpq/XmjzKxQLcPPkfskam30UZ9uYNfYQbH+qTK/8GuRRv1kwS11BkYCb
	 WpwdyW6ZE4ANB1vLT2qMvR3X7A3myXaf0mx7foRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/600] arm64: dts: qcom: sc8280xp-x13s: Unreserve NC pins
Date: Mon, 11 Sep 2023 15:45:44 +0200
Message-ID: <20230911134642.827435277@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2b744bb8a538..49d15432aeabf 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -347,7 +347,7 @@ edp_bl_pwm: edp-bl-pwm-state {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
+	gpio-reserved-ranges = <70 2>, <74 6>, <125 2>, <128 2>, <154 4>;
 
 	kybd_default: kybd-default-state {
 		disable {
-- 
2.40.1



