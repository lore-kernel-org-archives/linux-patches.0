Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051B15D724;
	Tue, 23 Jan 2024 01:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974393; cv=none; b=YjJdjFCZze8RNY+lXG0bUsunMzonDZQMajlSOWA6E6tGXxuB8PyOKtPGL15N7tu0iqPni75Jjklyunju9nkySirQp7X/bjDESZgdpw2sK/hbjX5UeGpSZxtpdZcN4Aq9mkPlXuzH7HF9q4epM0KvTslFtlWhfG+9Hg5f6nwp6jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974393; c=relaxed/simple;
	bh=roWcD+6M1hd2pKkMXTiVZvdN6lss9Z1Eg30+9iWeO58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM0jWsN286iF4RUwlZutyoI3iOu5KLrulWK7kfNOmBjqHTiEhXy91bd3IT9En7/iNJlQgLXooperz4MlPi97aPibe9uO0yED6yPxn+xQCj5WU6fkar21TpjuD7qqEXfrpBrYe/0TPQu613L4cE5T9pSeauVIInrWt49iItnwCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUU9CaS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUU9CaS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA403C433F1;
	Tue, 23 Jan 2024 01:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974392;
	bh=roWcD+6M1hd2pKkMXTiVZvdN6lss9Z1Eg30+9iWeO58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUU9CaS07wVMQCrQPOiIqJU5kSg4bBLN/2aynuQaRuXDdHqOKp7cRsxlkQ72/CbLy
	 baa2osfd5dcLjWzAeBEVl/mHGxIZn4pM6kzTF8/onn6VnsN8pKObLPhbVgJUk/qiXW
	 8vqa8JlZJdnygwOCMFSWt6JGSMv8TY2ghqJQiTik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/583] arm64: dts: qcom: qrb4210-rb2: dont force usb peripheral mode
Date: Mon, 22 Jan 2024 15:52:13 -0800
Message-ID: <20240122235814.667433725@linuxfoundation.org>
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

From: Caleb Connolly <caleb.connolly@linaro.org>

[ Upstream commit 27c2ca90e2f34cd3c4849af996e1a96a69e700d3 ]

The rb2 only has a single USB controller, it can be switched between a
type-c port and an internal USB hub via a DIP switch. Until dynamic
role switching is available it's preferable to put the USB controller
in host mode so that the type-A ports and ethernet are available.

Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Fixes: eaa53a85748d ("arm64: dts: qcom: qrb4210-rb2: Enable USB node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20231010-caleb-rb2-host-mode-v1-1-b057d443cd62@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index a7278a9472ed..9738c0dacd58 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -518,7 +518,6 @@ &usb {
 
 &usb_dwc3 {
 	maximum-speed = "super-speed";
-	dr_mode = "peripheral";
 };
 
 &usb_hsphy {
-- 
2.43.0



