Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2271E89C;
	Thu, 25 Jul 2024 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918769; cv=none; b=TuNZf/hfEXfVGwK5qR8URDqJ1HmvyqitwFHaNlYKvNsRHBr3VmsV3+Xx0S7WjOI2kKs0CG/Zo3qwzcPG0s0FjhB9nyFCqI1DAZ72emwx3Fc/c+oVVf7PFhY7AbPzaPctb5IL0q30hwJZGxUDAEB/Trq9JB8ki1/Tw0YoFBOlaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918769; c=relaxed/simple;
	bh=wzn1VIgZzOxtms4unLqkM82PC9qWgfdmU8IoDQu7cMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOw//JIIJFdEC6QiiTQqVIVeBfclSbmpW3IvL58jjTtdO8vnUYf9HYKRoAQtVb1qKOjDjCNK9ZwY2a62Jq5PKC259Hgs5ZHv24Pgs8xMMCtSt4ThwY3zEmUXzBwKUhsrpDXF0oMOJZ3plGTvcb96xbAsdl27Htod97uDSxf0r5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjefPzWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjefPzWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69479C116B1;
	Thu, 25 Jul 2024 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918768;
	bh=wzn1VIgZzOxtms4unLqkM82PC9qWgfdmU8IoDQu7cMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjefPzWfa5kYZGBradolachlA/aSj0NTjRySex9RKYSroMBxJ8Wy4Qx4I3Njz6zv/
	 a1bZ+C1oz/45Nde3iH2x6cGOaHGfO4vwXzmGMFWztCKllh4CdPslhbZpRsr2uQitf4
	 4VQPs2CqAykncl+KnKmceQo8F3LjLqh2UsrihgeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@google.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 12/29] arm64: dts: qcom: sc7280: Disable SuperSpeed instances in park mode
Date: Thu, 25 Jul 2024 16:37:22 +0200
Message-ID: <20240725142732.138967001@linuxfoundation.org>
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
@@ -4131,6 +4131,7 @@
 				iommus = <&apps_smmu 0xe0 0x0>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 				maximum-speed = "super-speed";


