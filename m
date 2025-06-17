Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986F22F94B0;
	Tue, 17 Jun 2025 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176852; cv=none; b=mzcPcr9UHSHxQTZoCrvPIEkDH2fpll7OcoCd981j/W5Jr2z/VR2POawVVKWAcYqd/niFGBpa7CuxKAbF9kylTMJx4/sYsgFADDp/UcBJhkUmRJpnUrsOHMBEhdAaqT7OkP2csC5o1LzFfKe73KLhVz/9vOakfUWBiAoxI//vwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176852; c=relaxed/simple;
	bh=g6Z5oVrHQExdqb9L57XlVDyrRrZjWg4sAlVx+MzR84Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGe0WavtXk+lAzGRShb3xaXAhmgk0THOgEldd6CQ7SZGjmiRODiWW1YVRrOF9eI5l+fjbDKhnn0QRk23BNHO6mOZ4yKECIj+6TcIkL9lT7M2xMF2/FbOd6pEGnMoycIBGI+X8dFBqOohcW4sYyAWnxgC3k97LCRx0Mc08IUexVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1TFsW0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1TFsW0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B16C4CEE3;
	Tue, 17 Jun 2025 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176852;
	bh=g6Z5oVrHQExdqb9L57XlVDyrRrZjWg4sAlVx+MzR84Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1TFsW0Sh7ap7jk8PgdAgMaTN4Nfvn9/qAULWnyqdFl7b7nMOFWJaMByWNML4JNyc
	 v23NNyhaaT7CNRNh0R4CwzsoXqWnJe+yb5oz8QyUboOiBOPywvo+P9/VfzETv/S8Z0
	 jVJLZff0HkfqYzwBMVM4kyrujg8ViigM6qIScTS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/512] ARM: dts: qcom: apq8064: add missing clocks to the timer node
Date: Tue, 17 Jun 2025 17:23:43 +0200
Message-ID: <20250617152430.008198396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 4b0eb149df58b6750cd8113e5ee5b3ac7cc51743 ]

In order to fix DT schema warning and describe hardware properly, add
missing sleep clock to the timer node.

Fixes: f335b8af4fd5 ("ARM: dts: qcom: Add initial APQ8064 SoC and IFC6410 board device trees")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250318-fix-nexus-4-v2-6-bcedd1406790@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
index ac7494ed633e1..1d802d931028d 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
@@ -326,6 +326,8 @@
 				     <GIC_PPI 3 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 			reg = <0x0200a000 0x100>;
 			clock-frequency = <27000000>;
+			clocks = <&sleep_clk>;
+			clock-names = "sleep";
 			cpu-offset = <0x80000>;
 		};
 
-- 
2.39.5



