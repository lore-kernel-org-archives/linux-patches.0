Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C119D097;
	Thu, 25 Jul 2024 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918352; cv=none; b=XGTZPrIP8KkGbEBVarRR7f3QLPBQ7f/5WgLQYlXPYuo2PfLVVGIAw+Rf1O0p9ZoOT6XsJKLLLmUEfRM/o4yfVbSdbCgsBwF9k/YM24atX1rDZjxF8QteqJow5DLi31EGPSBbZx6kSnJtbxXNn8b6S6tGCM8dcXW3p2H2HVIdU50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918352; c=relaxed/simple;
	bh=GWT+SOuVSqpTm4m3wEAAdXCWS9Y8cJeTulzol05+5+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6YCMKAKjFzLeZkdSdRPnyWivELUUW111OLip/LbDgx/eAOQrBOiLEmkZtoSx26tU8KvBhCx6c4u0GkeiDMrfCENnQDLTC87YQWiF4ivYd4gespp/Lqo1NXO6MC6qF38YJDmBbxggBDjevY+9iPoPiJaZMrJnkx1GlvgWkF5WJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vehuGW2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vehuGW2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F288C116B1;
	Thu, 25 Jul 2024 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918351;
	bh=GWT+SOuVSqpTm4m3wEAAdXCWS9Y8cJeTulzol05+5+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vehuGW2AfWAANwSIRSwjyn3tgrZaYuACbSK+omM0i+Ln7w3ckmAKtUcII9ZfLrKR9
	 /Zhdy0Il21ggy3+di3cWMXCmITL33g8/lMKxGJJw/Ltn9iWmrsoUaBtsmdDcgQcX8N
	 VFBYR0eSCOWp4G2WD8WwcI51KVL2FDZhN8m/Gp1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 23/29] arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:36:39 +0200
Message-ID: <20240725142732.688773708@linuxfoundation.org>
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

commit fad58a41b84667cb6c9232371fc3af77d4443889 upstream.

For Gen-1 targets like SDM630, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for SDM630 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: c65a4ed2ea8b ("arm64: dts: qcom: sdm630: Add USB configuration")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-5-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1302,6 +1302,7 @@
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 
 				phys = <&qusb2phy0>, <&usb3_qmpphy>;
 				phy-names = "usb2-phy", "usb3-phy";


