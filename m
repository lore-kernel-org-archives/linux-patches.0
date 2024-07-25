Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68C21E895;
	Thu, 25 Jul 2024 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918765; cv=none; b=AdHcK7xMTk4MY80YFLRuq0JJGeYKr5Rpg4M03HHcpIfXJfmoAlF8xm7igg3v8d/WXj8trTRqDLea24KNAORrd/lXwRJ76RAOuF/LDKI6kr0AiYsSED106wQOPdtQSK6vzakTIi9YLBKPOG8PjEyuSbohKpi92c2PCJoUmNl5Wxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918765; c=relaxed/simple;
	bh=6KJq4BFsK/vwchqCAdeqi+M98eXGG1bdAUhOwudwkqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdQ+bbfYV8jjbvA+hhJ5xtDmWTCob7HNdUF7yLeYLVglV8zU7UnZ+K6+0lQO8j+mmLUc38jAaXx/yLoyGhCGIAgQ44MSVFhJYeHKjETRazv79vwTPPofbmLslbbWjbpCWi9nSRRKJPeGiSOCNmeUNy57hIHJN0brGPXP0G2S9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9ifWfNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9ifWfNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF18C116B1;
	Thu, 25 Jul 2024 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918765;
	bh=6KJq4BFsK/vwchqCAdeqi+M98eXGG1bdAUhOwudwkqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9ifWfNeF+WJUC9L4U7sfHLzj9S0wiitb0r0pTMtSe8VrTyv+dSsJBDuVz9NvDFp7
	 u8nePbZKIX6d0p1lx4CQwqm6rVRvO8U8SEnJXZt0sTbbvAbIa+LBOQb8Yjpk4N7fsb
	 t3XjJbXcl0vdHlRnsbSHZ4tEM0pOvdnZan0HtCRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 11/29] arm64: dts: qcom: sc7180: Disable SuperSpeed instances in park mode
Date: Thu, 25 Jul 2024 16:37:21 +0200
Message-ID: <20240725142732.102803278@linuxfoundation.org>
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
@@ -3063,6 +3063,7 @@
 				iommus = <&apps_smmu 0x540 0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";


