Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CCF199E9F;
	Thu, 25 Jul 2024 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918314; cv=none; b=LWTHMAT2g5hl15oj6oRg1KXJpk2A+94GzPH4WbWBh/yBVBYLe/mLovB13XyHvPnZvZmRT7OtKupDKwrZb8i5DUtmXtVjd+Nh+DzKAKuhw0XgRB6D7YDtBe1x8N6BY72bV9A+NoglgjZfANSkqDJPjQZzAEcvW3vgqMYet9NO+AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918314; c=relaxed/simple;
	bh=JSlUaw2LzySg5kC8NJvXS759zktC8iz4ESpV8mpACmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVTaXI9Op+mXqCYhfUkOBOzlDdRbn8lF2EPhMGGvPKq59K72OTgIfvvRlNGYDIBqrQyYLWZZV/OC6Y1YSjjhCBRtpUYLOMC3REVdvkzyvdarlMSpqQpSg2Sar3R3RpYOMSzrJqbS+935kdxZDZoTUI8YR5j1p+zSZXQS5ZVASZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGIJU2pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGIJU2pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A73C116B1;
	Thu, 25 Jul 2024 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918313;
	bh=JSlUaw2LzySg5kC8NJvXS759zktC8iz4ESpV8mpACmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGIJU2pSt/haLOaa5meA2WNCcRN7Dcp5TXNvysItAb4Y//6atDfPDgsB+ianexhr4
	 0mgiRTfn/ke9+zr/Y2VvQs5fSSENm66PMGCY2HFbA4YKz3wV9bvhcAB078abGKg2Oz
	 t3+FWy2DYB8Skx+a955eqN9JJwa3vDlGJJF8fddc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 12/29] arm64: dts: qcom: sc7280: Disable SuperSpeed instances in park mode
Date: Thu, 25 Jul 2024 16:36:28 +0200
Message-ID: <20240725142732.277640941@linuxfoundation.org>
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

commit 3d930f1750ce30a6c36dbc71f8ff7e20322b94d7 upstream.

On SC7280, in host mode, it is observed that stressing out controller
results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instances in park mode for SC7280 to mitigate this issue.

Reported-by: Doug Anderson <dianders@google.com>
Cc: stable@vger.kernel.org
Fixes: bb9efa59c665 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240604060659.1449278-3-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4150,6 +4150,7 @@
 				iommus = <&apps_smmu 0xe0 0x0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";


