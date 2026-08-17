Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB53EDAB8;
	Mon, 17 Aug 2026 13:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973873; cv=none; b=ANzryobPX+owOr7+etHbkM4u5qvmVEeshthS5FpEMPuMEFrtB45+ckmV5ovCW/Gb0k4wV49uw4yZx80U9C71K/5xLHxqvh+APab1k/esILs6nwm2857So76/1r73C2rSHbz3SmMveIARaxfeQ/VOymnXFUl3kNIg77RYN/cDIQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973873; c=relaxed/simple;
	bh=YKh884gZoWCwFm/r3FC0ZtoIp8B2bTrxKe0J1k6mgK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXFdOodGLaU+t9xnxxjuO4K7EfAHyOMGDfov0QWo3l0MDArPQ9fvRw41Q+2SrR/M8dGYMmCpXATOd6S8t0sgVMf3ohRlXhKEbfQ+HVttLVVyRkime34MtwBrtuHDIq6dwQI1qNssrkSyQRFcbRgc39myF/d8C0RiSj8ZnHtDkDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8x0qus5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8x0qus5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700BA1F00A3D;
	Mon, 17 Aug 2026 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973869;
	bh=zVVv+rTdQ+PvwTsXKaHOrLP3lQEQntnmKgoNdA/diPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8x0qus5RlmBaRYNSL62QE63KjSQpMhDq47JXvRRtik0be7WXzBTdveNR/avjxDBT
	 +F+QwK1HusOFk4t93CHlMj3nwwDDn4AL/enyZgi1Q91Qg72k8hsfbetLnj5i0toJPf
	 AQ67tBAlrqL8SNI4A3d2g79UysMCd1aPe9fHT2DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 010/271] arm64: dts: qcom: monaco: Add default GIC address cells
Date: Mon, 17 Aug 2026 15:28:55 +0200
Message-ID: <20260817132537.184587343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit d291245e2fb1eba55d751f88613a41e292958a96 ]

Add missing address-cells 0 to GIC interrupt node to silence W=1
warning:

  monaco.dtsi:2326.4-2329.30: Warning (interrupt_map): /soc@0/pci@1c00000:interrupt-map:
    Missing property '#address-cells' in node /soc@0/interrupt-controller@17a00000, using 0 as fallback

Value '0' is correct because:
1. GIC interrupt controller does not have children,
2. interrupt-map property (in PCI node) consists of five components and
   the fourth component 'parent unit address', which size is defined by
   '#address-cells' of the node pointed to by the interrupt-parent
   component, is not used (=0).

Fixes: 46a7c01e7e9d ("arm64: dts: qcom: qcs8300: enable pcie0")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260407201518.24949-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index fa13210fc539a..62e6b60087ee3 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -7384,6 +7384,7 @@ intc: interrupt-controller@17a00000 {
 			interrupt-controller;
 			#redistributor-regions = <1>;
 			redistributor-stride = <0x0 0x20000>;
+			#address-cells = <0>;
 		};
 
 		watchdog@17c10000 {
-- 
2.53.0



