Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C0B199E9F;
	Thu, 25 Jul 2024 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918310; cv=none; b=U1dPI+Ka0EYA/7oXo9WhD483ysdvyK3u8VmeiPoy2NNZISxukSTn+YSa2UsC9n781mf5xrZDZW2sroW5q/Dsh7+XA2h5B9u4oRsrvn2KzptH85l8WnN/YLDtqzYlCk6qfMZn3TlKunS1bo74LYO6plaXQiIqmlSr4nFNKpFNayU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918310; c=relaxed/simple;
	bh=xJW5wBuARIUbL7VPo85rmRPDs8X/aCmnc3Se3KxncoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W72hNLGc2hYuHuqZynhR/0XxM3s5DHL7ok0tPf0Cs1wediLxI2x/B2u2uCv0JuKjy77F5AwNVnxhL8552TRnSyIB7Wle1NqE2d0fLxtDwu8vMY1iBe83710dwPoSWGicU1XMQ7KlttQnBUi0+rnlWB5bleUupdrHrSdOQ+MLTQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORqFFrsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORqFFrsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3929C116B1;
	Thu, 25 Jul 2024 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918310;
	bh=xJW5wBuARIUbL7VPo85rmRPDs8X/aCmnc3Se3KxncoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORqFFrsr+T5L3gODD0W2bzGQ3BsQrgCxlDIMogNqxkVt3ycb487VZqaPG4ZRsJviQ
	 nOfUoXQe/Kmy80m9/jwLANRrdoe/H6fKNAwdJI3AJbj2LSY68PlbgNV0ahO/TsxzKu
	 WDQYoIB3rvpnuwlfGAZxCLQSO+QRvMbYnSkXjwrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 11/29] arm64: dts: qcom: sc7180: Disable SuperSpeed instances in park mode
Date: Thu, 25 Jul 2024 16:36:27 +0200
Message-ID: <20240725142732.241532757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 5b8baed4b88132c12010ce6ca1b56f00d122e376 upstream.

On SC7180, in host mode, it is observed that stressing out controller
results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instances in park mode for SC7180 to mitigate this issue.

Reported-by: Doug Anderson <dianders@google.com>
Cc: stable@vger.kernel.org
Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240604060659.1449278-2-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3067,6 +3067,7 @@
 				iommus = <&apps_smmu 0x540 0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";


