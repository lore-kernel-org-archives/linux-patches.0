Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC292EA15F;
	Tue, 17 Jun 2025 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177767; cv=none; b=XPHWTqefk2HdMJj4hbFzQ/yYaB7O42I1ITB/Pc1rUVVL4Eku86BGNP5JD8fi/Ol2kNCWvwA45gueH+czVyBwvmTx61JzRpn1TJZuTLQFn5xZsZsRDvNbUOPbZqaXbxbPnfmQ5UELqIWb2uY0GZ3MOiOc+n8NiTZQ06Bi/c3hOh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177767; c=relaxed/simple;
	bh=T92tT2jq8zzZ0Hzv5vibcsTsnI7R3h/2uN24nSontzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyLQNv+saFvxd35gBhHY4vNO984skgVOSEu9NHhOfaL+QsfYnDGB5cJWa2xkWUkEXcjwaNti8FNivLQnCJqmhjB4ZkPUNw1aMTRXBr1vk/+7vApyg1nsYCxy3xrSG2sx7jZP3EPbdnd/aLQLDxbyQd3Lum/upRgMqaLlw86M1gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrTn5yNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrTn5yNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB2C4CEE7;
	Tue, 17 Jun 2025 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177767;
	bh=T92tT2jq8zzZ0Hzv5vibcsTsnI7R3h/2uN24nSontzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrTn5yNRhJrXph2v1Ul4zuWkXPsqIwnlhuxp0uxxeih++Gajre++WgkQFQWbY4aYx
	 zttYlS0dMI7QE8eKlhshHkb6rZvkRJFM2tXZjW/CyFL+/5vUZGtjfy0TMY3Bzq6aOi
	 5t0TcrubeRS6Fymd9h3c9MRAV5q+t/L+Fiwyvg78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tingguo Cheng <quic_tingguoc@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 360/780] arm64: dts: qcom: qcs615: remove disallowed property in spmi bus node
Date: Tue, 17 Jun 2025 17:21:08 +0200
Message-ID: <20250617152506.118644979@linuxfoundation.org>
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

From: Tingguo Cheng <quic_tingguoc@quicinc.com>

[ Upstream commit 54040a3e3da67ef0e014e5f04f9f3fe680fc4b55 ]

Remove the unevaluated 'cell-index' property from qcs615-ride.dtb
spmi@c440000 to fix the Devicetree validation error reported by the
kernel test robot.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202412272210.GpGmqcPC-lkp@intel.com/
Fixes: 27554e2bef4d ("arm64: dts: qcom: qcs615: Adds SPMI support")
Signed-off-by: Tingguo Cheng <quic_tingguoc@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250117-fix-kernel-test-robot-unexpected-property-issue-v2-1-0b68cf481249@quicinc.com
[bjorn: Fixes commit message wording about LKP]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
index f4abfad474ea6..8db06d17eb474 100644
--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -3304,7 +3304,6 @@
 			#interrupt-cells = <4>;
 			#address-cells = <2>;
 			#size-cells = <0>;
-			cell-index = <0>;
 			qcom,channel = <0>;
 			qcom,ee = <0>;
 		};
-- 
2.39.5



