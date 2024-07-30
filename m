Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BA2189521;
	Tue, 30 Jul 2024 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355462; cv=none; b=gVy7wwD6A0WE+ZKkllzMfIZQAQpyimhocYxHec8in0LwDs3L9NKIectKJk8sJteyr/43XCaWc9gBU6R1efAMqHyUNzxRH76AQvFjjJJVoquVNbFOnAEZu61P1swuKr+DOGWuyBR6sG5j1PIsGE5uik/cHOp9VLCvJVsfKrp1E54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355462; c=relaxed/simple;
	bh=li8YwyOUHaS1uvNdRf9lBM5+pleV5wtt6OJNXnCGdKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBsu6yGk9bN/VwukQwAYA6+cK3cRegtRbtpghjgYVmW/IqM9W/DQKYCBZjglECJXIeE99/ZH5+qNZoU9IdExudqUxt8XdVZ88uf3Y01t+vWu0uz0SRuXO4NU63OeO00WlHYKpuhWGZdb7Y3COKLqdhVow2NrVq7JuLZP5HOL3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY3UmVsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY3UmVsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808BBC4AF0A;
	Tue, 30 Jul 2024 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355462;
	bh=li8YwyOUHaS1uvNdRf9lBM5+pleV5wtt6OJNXnCGdKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OY3UmVsUAF7mK8G69qj911ZIU2s6tLravtayRJvkUF8/41LJCfj3O+oOhPt0e3l4E
	 cvdVl5/g4g5Zmn+zj7XbDBcdBRwIWlIKCG4zCfa8Ha5vdOxwKWzCeyi1Bzbg7E5WoX
	 N5vAerRimJvk1m3uOGw/zcyv378shlUz/vtRUJ10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/568] arm64: dts: qcom: qdu1000: Add secure qfprom node
Date: Tue, 30 Jul 2024 17:42:47 +0200
Message-ID: <20240730151642.203368923@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Komal Bajaj <quic_kbajaj@quicinc.com>

[ Upstream commit 367fb3f0aaa6eac9101dc683dd27c268b4cc702e ]

Add secure qfprom node and also add properties for multi channel
DDR. This is required for LLCC driver to pick the correct LLCC
configuration.

Fixes: 6209038f131f ("arm64: dts: qcom: qdu1000: Add LLCC/system-cache-controller")
Signed-off-by: Komal Bajaj <quic_kbajaj@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20240618092711.15037-1-quic_kbajaj@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index 1ef87604549fa..dbdc06be6260b 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -1452,6 +1452,21 @@ system-cache-controller@19200000 {
 				    "llcc_broadcast_base",
 				    "multi_channel_register";
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
+
+			nvmem-cells = <&multi_chan_ddr>;
+			nvmem-cell-names = "multi-chan-ddr";
+		};
+
+		sec_qfprom: efuse@221c8000 {
+			compatible = "qcom,qdu1000-sec-qfprom", "qcom,sec-qfprom";
+			reg = <0 0x221c8000 0 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			multi_chan_ddr: multi-chan-ddr@12b {
+				reg = <0x12b 0x1>;
+				bits = <0 2>;
+			};
 		};
 	};
 
-- 
2.43.0



