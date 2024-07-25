Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C265919D8AE;
	Thu, 25 Jul 2024 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918818; cv=none; b=pL1t6uUP0pn6moh1flOZHctXEHUDCQry0G5yuY8c5CZrMjahMB0Dm2FBdsG+DNlTWssOL/MXPLGQTri21iirUWZd4uV/O2M9ZJLu7AbLQZIIWRBZ6ClK/nyOm4Rwb/usHDMKVfukd1Cg6CfYUHoug+Ilovo6qDiUFEuYKK220AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918818; c=relaxed/simple;
	bh=MVI5+D1U77I5nOO3J3CwNC3FVZNfxRh9UmXVuTZN/Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5tXenp9xQnif0eaVi1H+ujuQb1WIgfsj3ZhWRTr0bxZiJShSuJtwyYh5xhrs0EblKgeBjxmqKwHpDCI0BVDEJSrEBsfG/xIAwm8RRNvPig6DrKwWWgCZRl91kTVq3C+k/DqGQPgkaeTp+GuR3Mpob0H6tQ+mEHO2voWULlgHgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONdYOAHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONdYOAHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D44C4AF07;
	Thu, 25 Jul 2024 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918818;
	bh=MVI5+D1U77I5nOO3J3CwNC3FVZNfxRh9UmXVuTZN/Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONdYOAHWbAVwiQTCoBieSLTrUwWPZAq5wfpQqaBHA1Qcn1Q4i607fLAVkWzyLUI6s
	 YgvPMnqc5expE6IHtHOzm/ro/Td/gMGVZN0ualJny0V/7V/yQVffNLr+qOO289C6HP
	 PIDVx/kSNCF2jMavelaXMSoj/XCcgB44WiwNmAlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 20/29] arm64: dts: qcom: sm6350: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:30 +0200
Message-ID: <20240725142732.438300228@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit c5d57eb7d06df16c07037cea5dacfd74d49d1833 upstream.

For Gen-1 targets like SM6350, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for SM6350 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 23737b9557fe ("arm64: dts: qcom: sm6350: Add USB1 nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-7-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1859,6 +1859,7 @@
 				snps,dis_enblslpm_quirk;
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 			};


