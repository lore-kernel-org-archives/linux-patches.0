Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131172F693F;
	Tue, 17 Jun 2025 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177800; cv=none; b=ao7EPHNDIahno1mMQFUQ/A7i+LeiOgbFh4DOyNIButTB/JuoZc2+s4GE8R0ThKCEGuGorIRItym2JjqAJZXowbb/FMGDFqMxLz8fpUXQKQMjETYOfcf1MS6rm2ltesTQSo6hp5opgYbwxu39fAkSnBuBLguX9IuoU0BIipOfJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177800; c=relaxed/simple;
	bh=SnnX3vxW698vUKv/eG/rNmbKytbNKx8Z1WXbpVom5nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQxoa9/YFIh5VVSNpdyGxmbinlFS3puenz9Mw0lXLVRwV/qm99QUZak5jv/OM0zQxaCjndEM4cn4W8TEYbLSpP2MxcFihDWxm4N1nNuMbx5902uQ8BiRelHeI2wrWF1vehaQFPpTozEZS6sqRdlKgdERUP3s505OZ+NpG1Gntjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXX3Uu1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXX3Uu1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCA6C4CEE3;
	Tue, 17 Jun 2025 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177799;
	bh=SnnX3vxW698vUKv/eG/rNmbKytbNKx8Z1WXbpVom5nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXX3Uu1Ecm2Zt7AyKt4+C2yzF8+MSK9R/uzD7RjApfUoZ1D0oCNPdeo81/vgv0slB
	 dyB8RXOtDKipmrqE5ixjQ4clb0T3e2p33eC6ckB8URovuq9K2bwbxQrpV0QdkwtLDi
	 TFBVvPmnopu8xyvI7QDXQrpuwrOIJpiAKoKSaDoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <wuxilin123@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 356/780] arm64: dts: qcom: sm8250: Fix CPU7 opp table
Date: Tue, 17 Jun 2025 17:21:04 +0200
Message-ID: <20250617152505.957142091@linuxfoundation.org>
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

From: Xilin Wu <wuxilin123@gmail.com>

[ Upstream commit 28f997b89967afdc0855d8aa7538b251fb44f654 ]

There is a typo in cpu7_opp9. Fix it to get rid of the following
errors.

[    0.198043] cpu cpu7: Voltage update failed freq=1747200
[    0.198052] cpu cpu7: failed to update OPP for freq=1747200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Xilin Wu <wuxilin123@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250308-fix-sm8250-cpufreq-v1-1-8a0226721399@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index c2937b4d9f180..68613ea7146c8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -606,7 +606,7 @@
 		};
 
 		cpu7_opp9: opp-1747200000 {
-			opp-hz = /bits/ 64 <1708800000>;
+			opp-hz = /bits/ 64 <1747200000>;
 			opp-peak-kBps = <5412000 42393600>;
 		};
 
-- 
2.39.5



