Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765542F363F;
	Wed, 20 May 2026 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300794; cv=none; b=NgmC802vJHPU8C9o6ALJ6RnHido/DtYjmfrsqDnuSwOb/RatbGgLFToDbq6MgHDM9RonrGGqhns8P4C7CTTh04F8t63JULSRN/C6tYjuChcmj5fZoW3rc9IFloNbh4BfnlFQiPuFdMby6Pcz7FxFcYwg/+DFVCgkVh7RUEG/Af0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300794; c=relaxed/simple;
	bh=vgUOnvYWiTQNLXbFxIFxuHqtbf/2TSlYiOz2BUHPA50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtvEsTv/eL4yEeUKR0LDK1hOO/UW/IfwV12hyQvedfDitSUDCnKGR2/n3s0SVK3H3QzSnQRoTYITrPP9x6lMDGPIEeZvZJkLIdNvAD7zkWIalfUAdnb7OUiV977BQvy7QlR1mKfFiGFL0iWc0CE7rW6Gyz+C0XGb2x1vgEbXWdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3kbkSBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3kbkSBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB69A1F00893;
	Wed, 20 May 2026 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300793;
	bh=GI2ex3HV6DI7bwnzrJNK/tXBgD7/BMjHsJ4lSFVPHKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3kbkSBbdRb85EWFubLDR+SKEBDsJi9ifqD/D5teb/WEwE5U78hqu+ZGLIWNpeloh
	 zXGcs07opmpKqHMWtd+L/1QQMFjCbfNf+SJBoao48vNQFYdAcEddTpwmC5geI0uGGA
	 4zVv+DEencWdEC2r7gse/2D7BabVscJNGCVaUbow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/666] arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP
Date: Wed, 20 May 2026 18:18:42 +0200
Message-ID: <20260520162117.961635243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <AKoskovich@pm.me>

[ Upstream commit b683730e27ba4f91986c4c92f5cb7297f1e01a6d ]

This resolves the following error seen on the ASUS ROG Phone 3:

cpu cpu7: Voltage update failed freq=3091200
cpu cpu7: failed to update OPP for freq=3091200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260307-sm8250-cpu7-opp-v1-1-435f5f6628a1@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index e17937f76806c..9995fc515e113 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -664,6 +664,11 @@ cpu7_opp20: opp-2841600000 {
 			opp-hz = /bits/ 64 <2841600000>;
 			opp-peak-kBps = <8368000 51609600>;
 		};
+
+		cpu7_opp21: opp-3091200000 {
+			opp-hz = /bits/ 64 <3091200000>;
+			opp-peak-kBps = <8368000 51609600>;
+		};
 	};
 
 	firmware {
-- 
2.53.0



