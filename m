Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335161714A1;
	Thu, 15 Aug 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730200; cv=none; b=EiHbueOd71bA7+eYoFNhWsE0HCJP0SymsgQwrzIHOFS8jEjXL8qc4TeJpDVTM44rDDmolFrbDVYv4FEQkBi/e7bCk5IZNbgfXL/ulF+fu/PrWkEpeHYGxlaWP+KIB+rt8Wl5N2hdHhKYzHanoNQPG99xnqTvoh6QSAD7WJZy8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730200; c=relaxed/simple;
	bh=NhfZc0w/lkBQDuXf9B/m/US5oiKldJ5cXuTGhTOqNJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDB2BSyi57Mu6JjeVbqhTqvczrqoxDiD6yuZ78hjwQKU9b/IMAvDkXf0o0P0HrgZlgCDAhz/LZ9duTBGdQqv2yPwrvPfAcz5j9WUZYv+U7lsRNPi+hmhKDKeQFIOxZMSiaY/WSnwzinf5CHlx2ohfuY9s7Jh60he65eLV21mqes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0CVVgwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0CVVgwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AE0C32786;
	Thu, 15 Aug 2024 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730200;
	bh=NhfZc0w/lkBQDuXf9B/m/US5oiKldJ5cXuTGhTOqNJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0CVVgwdAbixjgvo3aXZCHTT8UT25mNij2Z5oMySn3MShmY6dF5iCug3nTegBrUU6
	 O84ggQaktRbWBGH7UJPhwsGzNqYbjJdb6JDLZsADiBQKa6Y8n0OXQNFAVFaMAuL7l7
	 3DTJA8wdr+XGrAiS2D75WngBenXihBO6B9uuXt7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/484] arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB
Date: Thu, 15 Aug 2024 15:22:40 +0200
Message-ID: <20240815131953.072359529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit 0046325ae52079b46da13a7f84dd7b2a6f7c38f8 ]

For Gen-1 targets like MSM8998, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for MSM8998 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 026dad8f5873 ("arm64: dts: qcom: msm8998: Add USB-related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-4-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 8037288359482..8ca6a6f1a541d 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1982,6 +1982,7 @@ usb3_dwc3: dwc3@a800000 {
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&qusb2phy>, <&usb3phy>;
 				phy-names = "usb2-phy", "usb3-phy";
 				snps,has-lpm-erratum;
-- 
2.43.0



