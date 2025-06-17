Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CF41ADC97;
	Tue, 17 Jun 2025 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177919; cv=none; b=oikNxc5Ms4nyxLT/Ungj92vHz+becqGE+vKDnTow5HstGrXRD6EFf0JF3uDq5T0ePjuPxPdCP/dEjAzAtvW6XD/EGVzOV/xeUZnwyOzx7zuEe+2UlArS/B6SEUO9F5rUaZk/PKQy2FVZSvrtIOjwRjtK1MRtskWaQ4PjCZMtYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177919; c=relaxed/simple;
	bh=HQSJkV+VwNRnO5B7o5sBuau5k2knXEp8o8ZbBh4avQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovbLRWAPYOKbY9c/JjRvbRTgbKIzbRY6HVtWAvvj3HHfIDW08cMDX13edyS3GS+cktNgshrUN2HQjK8aF8UEN1zCanOeGCYSGwDUiRzkgfRwMfStmTmicuMnSx41ioNowLuGpe+5Rj9flwrrjpz8tYJ2WRrrkWyjW+tKKc2Nyt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeRzxqNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeRzxqNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544A1C4CEE3;
	Tue, 17 Jun 2025 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177918;
	bh=HQSJkV+VwNRnO5B7o5sBuau5k2knXEp8o8ZbBh4avQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeRzxqNG/mQIqHYCbUXRSKv8wCCRtNXD5lcSFVmsW8T6zHjl3xoNTMNRtP3mJ1JQy
	 +PjOLiSRX24Tab5JN49ErCXFgagJPzNeu6KS3J7pcuh0ea32AdnQ9nsWJd6z4LyyDR
	 Xz4z7Pg0BChvqEwC73LCtqGAADubqSdnjao/DFnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Mylavarapu <quic_mmanikan@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 354/780] arm64: dts: qcom: ipq9574: fix the msi interrupt numbers of pcie3
Date: Tue, 17 Jun 2025 17:21:02 +0200
Message-ID: <20250617152505.876377836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>

[ Upstream commit c87d58bc7f831bf3d887e6ec846246cb673c2e50 ]

The MSI interrupt numbers of the PCIe3 controller are incorrect. Due
to this, the functional bring up of the QDSP6 processor on the PCIe
endpoint has failed. Correct the MSI interrupt numbers to properly
bring up the QDSP6 processor on the PCIe endpoint.

Fixes: d80c7fbfa908 ("arm64: dts: qcom: ipq9574: Add PCIe PHYs and controller nodes")
Signed-off-by: Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
Link: https://lore.kernel.org/r/20250313071422.510-1-quic_mmanikan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 3c02351fbb156..b790a6b288abb 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -974,14 +974,14 @@
 			ranges = <0x01000000 0x0 0x00000000 0x18200000 0x0 0x100000>,
 				 <0x02000000 0x0 0x18300000 0x18300000 0x0 0x7d00000>;
 
-			interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 129 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 221 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 225 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 312 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 326 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 415 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 494 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 495 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi0",
 					  "msi1",
 					  "msi2",
-- 
2.39.5



