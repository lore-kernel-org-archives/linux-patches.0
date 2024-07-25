Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EA19D098;
	Thu, 25 Jul 2024 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918753; cv=none; b=l819/YCY04b/g3w4ABQ3akK9znPZweh7i6TKWYmFKzzeLVsLvDHwCspTMDfMlS4ruc2IhJr7lzL80dLwkknPXOFVkPY+2WIG4qi8i64N8li9WkufherXxif3rsxjYUPP5HDkuTuIkf6lTDW9BSW5r2hFslckiK1dGGdyBLqnOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918753; c=relaxed/simple;
	bh=jYjij26jQ5tVxX2hezHEVDYeI/8OlbxV3WHxPjT5f3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsGXGXq3D1EpYnK7CPhzjtAw/7pi/uQ+e/bCKYghosle27Aruq1lmnXafURwkUrylfv8X2wjZVMRN4LjtSCD4QV0EOwqm2RO1Vl2zqT4QLEmZjBUEtHrCz33Meux8o05mu1/dVb4I23fkzron4Zl/Lh3emmq4ThcJQrW4C+nct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKeRDJCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKeRDJCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122BEC116B1;
	Thu, 25 Jul 2024 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918753;
	bh=jYjij26jQ5tVxX2hezHEVDYeI/8OlbxV3WHxPjT5f3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKeRDJCBGC23reuvZvylqlg+MnS2Rcx5vB80gD44jWrPAjo1UdA4ZH3ubcxuEsPbE
	 0E4RAhQof2K9NcT/OPN/tM3QqV4t7K8pyoS4qrGBBYesJTsZHlgBT9EWkzXc5AUCII
	 eZtUNJUDNwhCxnzwUA1GtKXztuYR4EX39AdD4M5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 12/16] arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:25 +0200
Message-ID: <20240725142729.365197209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 4ae4837871ee8c8b055cf8131f65d31ee4208fa0 upstream.

For Gen-1 targets like IPQ6018, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for IPQ6018 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 20bb9e3dd2e4 ("arm64: dts: qcom: ipq6018: add usb3 DT description")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-2-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -579,6 +579,7 @@
 				clocks = <&xo>;
 				clock-names = "ref";
 				tx-fifo-resize;
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;


