Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20262A1F;
	Tue, 23 Jan 2024 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974988; cv=none; b=ob3KHfi31yCQXR9s9WLYzokzdln6CsWGwNiapVYAMOTPERECeJsUaSxF5h2HgMvW4J43I3hz0/x9G9w+DIRKljKv8y/nBr611byFbH27TAXE7xE7450mFscyKLl7IhNbeeQRogaINCUtzFOkJTRQjhR7/rJx5UyAq9LbbkqMsA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974988; c=relaxed/simple;
	bh=GwcU2pSIbydwbJiU6IuHormamlt/mT09dfYLqMj4oWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prwQ/jIg5XdHMPo7DQWoZMjZbQ3mJ8ErHhpXk/m5wx9c/mReNCpWjn0m0fs2MJ92gDLhB7FGE2s9jBZnBuw8oqeF7SywzpQcuD0Igp9GJ47nspwikyy1l0b8is2+aZ0+03ocdVwAo9KnxSGKY4WEoRtNMXE73hHuTwdD/EmlTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiNPfmDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiNPfmDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5DDC433F1;
	Tue, 23 Jan 2024 01:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974987;
	bh=GwcU2pSIbydwbJiU6IuHormamlt/mT09dfYLqMj4oWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiNPfmDw7U6uNQsYu3vi43mcVCMYZ/nhTYgPIgPo9sb4NudIB8+juueCfQvQoU1G7
	 tJIkWXJuWZrMFSX6HBTP00HQ3Wz8HDFz2Wvqt2887nzijFeT26iH8vHHeN7t6dG3PO
	 P4VDJuWHz/MXPgf4uwE8LYqCD9u1B4giFZ8wBo+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/583] arm64: dts: qcom: ipq6018: fix clock rates for GCC_USB0_MOCK_UTMI_CLK
Date: Mon, 22 Jan 2024 15:53:53 -0800
Message-ID: <20240122235817.579636443@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 5c0dbe8b058436ad5daecb19c60869f832607ea3 ]

The downstream QSDK kernel [1] and GCC_USB1_MOCK_UTMI_CLK are both 24MHz.
Adjust GCC_USB0_MOCK_UTMI_CLK to 24MHz to avoid the following error:

clk: couldn't set gcc_usb0_mock_utmi_clk clk rate to 20000000 (-22), current rate: 24000000

1. https://git.codelinaro.org/clo/qsdk/oss/kernel/linux-ipq-5.4/-/commit/486c8485f59

Fixes: 5726079cd486 ("arm64: dts: ipq6018: Use reference clock to set dwc3 period")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20231218150805.1228160-1-amadeus@jmu.edu.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 264845cecf92..fc907afe5174 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -565,7 +565,7 @@ usb3: usb@8af8800 {
 					  <&gcc GCC_USB0_MOCK_UTMI_CLK>;
 			assigned-clock-rates = <133330000>,
 					       <133330000>,
-					       <20000000>;
+					       <24000000>;
 
 			resets = <&gcc GCC_USB0_BCR>;
 			status = "disabled";
-- 
2.43.0



