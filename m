Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0532EA176;
	Tue, 17 Jun 2025 15:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175300; cv=none; b=lTpnRMTOcPR4BDvHocjJvdVrC0wt8EVEa+FNy5BZDzhi7p7fw1EQZHkYcZPDxV84RgUiDnUvZEhVb3k/ClvHTsWXek+RhiicIAdRWsJtftSGXSLW9lt8p6QjeWjFxzx81Uct0crLOSrcf/w/hXyfG+2EO0pibSRdRPoo0ns3RYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175300; c=relaxed/simple;
	bh=dNO4GGfd7fqFGNZ2KJPI9Zbm7SCi2ykHPsEvWTtmcb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR7cLxPkKzTSv72zsyzt8mWRNDccWfZTW25Um51CKzN/T8YNSs3/T5uZwu6MmyXySNS1Oon/uEDSIHGwK45x4R5D5qguecHrg8g5WR5gCpH/LfylJfoY2cp+r78ydYqKoj2Ky/2vtIIS/QuG86yR7G1P1nO4B+wjQM0gSMpsE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1HtHMO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1HtHMO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC6AC4CEE7;
	Tue, 17 Jun 2025 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175299;
	bh=dNO4GGfd7fqFGNZ2KJPI9Zbm7SCi2ykHPsEvWTtmcb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1HtHMO8eooBxzm+hhNJ6KztSrw/ZgvV9SrZMzFgh+AXQVWsetzptoz6lYU57gs8K
	 PWO/WuExJJrsuOQMtFqfeYbs4/4p4Xp7vKsMKGpHZa9mG9QdAtnxKOJBp7mA34xGcY
	 dB/MPaNvBE0IJ8kiX7lshM8YBVvDdnNZL/quXYr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <wuxilin123@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/356] arm64: dts: qcom: sm8250: Fix CPU7 opp table
Date: Tue, 17 Jun 2025 17:24:37 +0200
Message-ID: <20250617152344.741479180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21bbffc4e5a28..c9a7d1b75c658 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -601,7 +601,7 @@
 		};
 
 		cpu7_opp9: opp-1747200000 {
-			opp-hz = /bits/ 64 <1708800000>;
+			opp-hz = /bits/ 64 <1747200000>;
 			opp-peak-kBps = <5412000 42393600>;
 		};
 
-- 
2.39.5



