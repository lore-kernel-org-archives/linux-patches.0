Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B015746AA67;
	Tue, 21 Jul 2026 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648178; cv=none; b=s0e5T/q63F/fwghPB0tm0DWYUy9lBOnA52nZbaLVXUaxPKlKg4hqFZqtokpoZc8FBURhj1zUwup5xzi/aBtZxuQvD3Fk1uNhz3Jx0mKFARYB7kIbqV4a2sKwBfykk/uCG5+kbZgZLS4D4958m65bKxXCzoHLFalAMvget3C1dgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648178; c=relaxed/simple;
	bh=2e8P0YOl+K+LjUh0E/vLIuBb4k46XD1/LqA6nN13IxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t03sRXPVaYt31NxMwHtAJyvvfeGDpbMKPKzvfubp62v91pDdY5QB4iEi1d8aJzmKcwWdomfHIYtQ7s1KuIsJ1/zpFMsKVrfOUIA5hK+v6st+whTjGdTDrWtIlxthD/jJto2tf2uQ21ID4Ny8V0J+9YQGrXuZTxYvWpFYLHRkJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+83v7IL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+83v7IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC05E1F000E9;
	Tue, 21 Jul 2026 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648177;
	bh=shrX2qzp2h6nfwOiFa+/BojoJeXUrtLxIwVPhHimnHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+83v7ILKcXDyO6+cw/DKdwhcm+xrMqAGWtd/XJkVma6KKkzi3YCRGUviBGYW6mJJ
	 UJHFK7oUe9v/x+E1fgqeLX8bVP4vdYUUK7qnfFKRIREJf5nHrdsHUrtfaFN8WaNq6x
	 kUdBtSojJsMh/1cWXtZKEBkBZJsTV7WQkIej00yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0084/2077] arm64: dts: qcom: glymur: Fix USB simple_bus_reg warning
Date: Tue, 21 Jul 2026 16:55:57 +0200
Message-ID: <20260721152554.677405442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

[ Upstream commit cd66b6d256f94e40922941e14d7f9390d35d072b ]

Correct the unit address of USB node in Qualcomm Glymur SoC DTSI to fix
W=1 DTC warning:

  glymur.dtsi:4027.23-4093.5: Warning (simple_bus_reg): /soc@0/usb@a2f8800: simple-bus unit address format error, expected "a200000"

Fixes: 4eee57dd4df9 ("arm64: dts: qcom: glymur: Add USB related nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-1-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 82436984485d41..ab2a6b577bc9d0 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4016,7 +4016,7 @@ usb_2_dwc3_ss: endpoint {
 			};
 		};
 
-		usb_hs: usb@a2f8800 {
+		usb_hs: usb@a200000 {
 			compatible = "qcom,glymur-dwc3", "qcom,snps-dwc3";
 			reg = <0x0 0x0a200000 0x0 0xfc100>;
 
-- 
2.53.0



