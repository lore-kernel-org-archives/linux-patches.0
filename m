Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4346EFC18;
	Thu, 25 Jul 2024 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918834; cv=none; b=dZzF5uEazOQuRNgCH4aqyJpxsB8vgJUuPsZi2UqUasKX+hMGmGtS1loWh8170oFeKTUd1pxZNXDo+r58CbeVq2fTa7eKst3wR/P0GkhwwBb02eJBwLC5wb+QdLLLaM8yLkbODRPjXwodHrWi4GsaeaWzuk4slBMDOvZ4zf75atY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918834; c=relaxed/simple;
	bh=Nua7gH/Ow4fo1bsKMi9mHpvZ/c+Y273m9959YaOSAzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3rIrrM85erQlq2xBanU/TQq5REnfWEOKtCERX97AX2EraePRzOBgn/iU2WSIAywUPeFsuZS5AOHKn3MUDBAKdzOOqAnscDgfTVYuxZm6iE3JuZ6dgNyothJoDdIks9Vbe3FpwA2y9zLEEUxnWAhnGVlwBAsH/1e+t8UMPB0RA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQNscySs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQNscySs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F3FC116B1;
	Thu, 25 Jul 2024 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918833;
	bh=Nua7gH/Ow4fo1bsKMi9mHpvZ/c+Y273m9959YaOSAzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQNscySsBhuQ4ul8OiM0em1+WRGVjE71ktRA6KaJSgILKGF/dpxv/Eu3fO3IGKiR8
	 3OJ+yPwii0DhPfVxvFW8+iEPfMIJCIz27J/y/OSwfdLFFYX2ezTLUl3ehZGUOXUCoH
	 fWFKuO3Msrq60lVlLi3drFfXN+T3senwuI4YbX6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 24/29] arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:34 +0200
Message-ID: <20240725142732.584357823@linuxfoundation.org>
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

commit dc6ba95c6c4400a84cca5b419b34ae852a08cfb5 upstream.

For Gen-1 targets like IPQ8074, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for IPQ8074 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 5e09bc51d07b ("arm64: dts: ipq8074: enable USB support")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-3-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -647,6 +647,7 @@
 				interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&qusb_phy_0>, <&ssphy_0>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;
@@ -696,6 +697,7 @@
 				interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&qusb_phy_1>, <&ssphy_1>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;


