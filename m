Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F5819A29C;
	Thu, 25 Jul 2024 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918342; cv=none; b=D5p7JI+J3/LvEIyQBo3JFB/ud3uiPWPSeEzjed4Nfhwasf8jhl9dYkBKWxDdDfRTs8WmFbFdRJwR8sbT0fJcLSV//V+D48lzo7Bj1fLyxZIMUGM5pqhmEjKJzlf8kiTlyZr7Jg5+QSDvIT+BIVuhrXMfuCYVmywq1EA+EKAu4ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918342; c=relaxed/simple;
	bh=DMWS5UvFnNSy/DT8cne3FS3pjpuU77l/RWF93g+hmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CneQOeOhOPDkpI6lar8so2PvwJo0KllOM+2BhsUCzYjfi1JUQb07JhfVhs40nOkpHGlgGIGog6ngVDBY54mToHS2fIMqkLu2xkFy/eiMew11+g/lXDUtaVotfoBN5esku56w+9v0Gvk7CdZz8bje6xqqRjh8SsccuPOntYr+Cwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9PoGpjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9PoGpjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02401C116B1;
	Thu, 25 Jul 2024 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918342;
	bh=DMWS5UvFnNSy/DT8cne3FS3pjpuU77l/RWF93g+hmtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9PoGpjRrBCEuknrw/2uRw8CDLI8LmPEqjKIUOLgXGMmzEXlYaDheE66GjEIilFlA
	 ISK100y4wa3UdBwJGXbui6i8Bd9mxa4Qs3oC+0AOMhYJy3M+gx1GpA0xc5kh5ED/UN
	 iZkWRDlZmQLLPdn0cLnKyYxYAOnsX67fFmQDJH/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 20/29] arm64: dts: qcom: sm6350: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:36:36 +0200
Message-ID: <20240725142732.578540739@linuxfoundation.org>
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
@@ -1890,6 +1890,7 @@
 				snps,dis_enblslpm_quirk;
 				snps,has-lpm-erratum;
 				snps,hird-threshold = /bits/ 8 <0x10>;
+				snps,parkmode-disable-ss-quirk;
 				phys = <&usb_1_hsphy>, <&usb_1_qmpphy QMP_USB43DP_USB3_PHY>;
 				phy-names = "usb2-phy", "usb3-phy";
 			};


