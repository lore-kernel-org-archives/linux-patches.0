Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064182;
	b=F2IPUKFQexw9Eq+nvth7/PppYFDTHWdAbtvR6UteE2AQUNeaUggJZR3jQbWZpzZ7pg9G
	 hopBu7IW0TRHaf0qgp7VrmH4oEiODfJfF+PMfgi7G+Sw+ozivHyL2bxeMaW4l7oZWCnem
	 tMuBBgRUxmDrDfKf6Ts/SeNiTpZlxvzHH0hiMlin9KnRn4M69D/xL8Og5tr40usnuG1h2
	 Kx2RMqnt+besTM/jNtIlbBxhVtEPpvP2xxMGM7H4xbsLn/qcU9eqSM18IMWQuL3CSTf7J
	 iMBFxDd8mEjMwey04dsGP99cv4D3pl2eXqFLR17RPG2cyi9Cj/C5Gn1hHrAdqIueBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4/mJEaJPL8mQkCqIcFDp5BXtDiJC3Oyu0g1vAQAzjE=;
	b=WAvtWclMXNVlId0Ofw1P8nq0ZawJYl/5xpR1+gJgAX4jKbk50T9nkEuj4jZY3PEsO/eB
	 oR9tGkcUNcB4S6aDIIzKdhX8/P+7yZ0pXvTdQKXjCAFqe4EABJPXtzOWoHuVvv6Z+Lqwq
	 ospgWjgX4oFIjAjFUVdubVaWuB8ayau2EQqBSe/O1JQC3OGwWPu3TmkhD1aAs9j7KrYOv
	 lk7aj+46IF8OZZwMMS+MZFRpeEwk3aonP/0cHrzHbtwHzAhsSNzoPVA18WnELH/paftzP
	 aQMv2Se7L1sGZur+SatbRp8kgCpKqoVVR7xsqW+ylrP5Y6obBBWGNX6YaqS3gctfcLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fedBshm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76B9606E8EF;
	Sat,  7 Nov 2026 15:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fedBshm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6453C1F0089F;
	Sat,  7 Nov 2026 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064181;
	bh=r4/mJEaJPL8mQkCqIcFDp5BXtDiJC3Oyu0g1vAQAzjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fedBshm/NxngchmHFEya7uG57fL4TM4Y5baWBTglLfazg72h5jg1lYvO6dqe81l9j
	 wXO4yClrpv2JhLVK0uSXD0RzToA7f6vpYZb1hxSYZWVK7PYk5bkhveRoTd9EmTwPRe
	 SCZB6sEWWb+GEPKRgp5qijCPUQ/K8mWw7CnW/4Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0324/1257] arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC
Date: Sat,  7 Nov 2026 08:43:40 -0500
Message-ID: <20261107134948.373995618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 117d8d40be1ded4f35f3252efa83607a7134d5e0 ]

Connect the QMP PHY USB3 output to GCC so the USB3 PHY pipe clock can
propagate to the USB controller.

Cc: stable@vger.kernel.org
Fixes: a98bfb31f676 ("arm64: dts: qcom: ipq9574: Add USB related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-4-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 5a5bda5f21a11..dd1dcd955c952 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -428,7 +428,7 @@ gcc: clock-controller@1800000 {
 				 <&pcie1_phy>,
 				 <&pcie2_phy>,
 				 <&pcie3_phy>,
-				 <0>;
+				 <&usb_0_qmpphy>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#interconnect-cells = <1>;
-- 
2.53.0



