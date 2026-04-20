Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DEB33AD9A;
	Mon, 20 Apr 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700685; cv=none; b=UmeRdoFhDPYrYnNcQZGgl3tjQxjjwuDBSib3xwNk3+5rcDLRJxwivyLLm2OK/zC7FJIfMb7to1uhuxS74jXx5EeOQQ84ZmjCEvjutw9XmMHTjvt1HOyGu6fI5SrJLdZXdBsUqfqrcSzLYmx6gGHtL9qDpOyxdLdi1Np07DWdjB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700685; c=relaxed/simple;
	bh=frx3MvksR5dj8CdkfjC7wKt7aJ2olGt/KTe6qo7w58Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHFZfJOKo3wKhGpmqDiepZzszKDWwaSLsJ/R9bTcf9AQBm9ODUz7O0KyimbX6/9EL6P/DJR1b5xGSiQGW2N1ZjodVl3v577gbNVW4GndQNSF+uh/a9cL3ywtTxccUwf4mBMQGlphTwXEQ59MySWn4YzWBzYtU0/z0rJkrJYmhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpRWoufc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpRWoufc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA020C19425;
	Mon, 20 Apr 2026 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700685;
	bh=frx3MvksR5dj8CdkfjC7wKt7aJ2olGt/KTe6qo7w58Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpRWoufcpMc5MAIPzAX4BSJd7qTvF8aihMAHPKnQbeBf5EW/cHhhprtUHm6UGPtaR
	 ZchA1wWuDqchGcB0Jsxr+gdCEpncgfzy6m54JYSv8K3ab87PhDRZ+TXWlP/uyZLlQp
	 OsLqH4V2QY9uLuk9WO9A6tJFfD+89i68KHWeSex8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/198] arm64: dts: qcom: qcm6490-idp: Fix WCD9370 reset GPIO polarity
Date: Mon, 20 Apr 2026 17:40:27 +0200
Message-ID: <20260420153937.346475502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit b7df21c59739cceb7b866c6c5e8a6ba03875ab71 ]

The WCD9370 audio codec reset line on QCM6490 IDP should be active-low, but
the device tree described it as active-high. As a result, the codec is
kept in reset and fails to reset the SoundWire, leading to timeouts
and ASoC card probe failure (-ETIMEDOUT).

Fix the reset GPIO polarity to GPIO_ACTIVE_LOW so the codec can properly
initialize.

Fixes: aa04c298619f ("arm64: dts: qcom: qcm6490-idp: Add WSA8830 speakers and WCD9370 headset codec")
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260220090220.2992193-1-ravi.hothi@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
index 73fce639370cd..214671b462770 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
@@ -177,7 +177,7 @@ wcd9370: audio-codec-0 {
 		pinctrl-0 = <&wcd_default>;
 		pinctrl-names = "default";
 
-		reset-gpios = <&tlmm 83 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 83 GPIO_ACTIVE_LOW>;
 
 		vdd-buck-supply = <&vreg_l17b_1p7>;
 		vdd-rxtx-supply = <&vreg_l18b_1p8>;
-- 
2.53.0



