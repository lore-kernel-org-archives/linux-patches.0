Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5507A1DFF7;
	Thu, 25 Jul 2024 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919302; cv=none; b=Iw8kbxn9zAcz2WJpdiJtO7NkBVZktlSQ+bqE1gJeaWQ1u5OO1HWNfKJCfqrB0laucVfGfGcZtwfJvT5ooorDmLysPIbEjsSEJxEChjXXKlJyRf9nEMCXA0ayLOFpBZXzpGpdkfzp7a3Tl5s2mle1MP14qcCJq1EUG0icCtvLgmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919302; c=relaxed/simple;
	bh=2wlJC0DcYMhm0GhwkTOCMsFTMb0kS3TrkpMgi5Kc9Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPIVv+USx1MR0iYRkUvCx1TDnNQD0o86hQaBsGf1jqRnCvKQnpXQNAL3JTvjmZ9WAuT3BFwbVJpghjKw38wj4N6clEoXJJxY9fR/6XUq1oZAYVAXuEvDNzTCADYo65IgH3IvBGe5M5QOG+TFe4OrQ+QTYrErDUW0WSbRwXkcv2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKAVxEzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKAVxEzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD05C116B1;
	Thu, 25 Jul 2024 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919302;
	bh=2wlJC0DcYMhm0GhwkTOCMsFTMb0kS3TrkpMgi5Kc9Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKAVxEzmxMcFCtS/p5bMf2qRNeSwaNaMHSocg1lWgM8T1xJDCufFLgNBtXUEbvf1X
	 EDsRblUEKVqgVXzXwp+LtqCooheG00q/ECk8GSRgAAjinC9aRgqtdUYqDPHFoJLO1j
	 igxy/RbvHsT+KI+9LGfzVdVEoTDJutTkoOewT/l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 85/87] arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:58 +0200
Message-ID: <20240725142741.644040989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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
@@ -1236,6 +1236,7 @@
 				interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
+				snps,parkmode-disable-ss-quirk;
 
 				/*
 				 * SDM630 technically supports USB3 but I


