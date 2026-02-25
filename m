Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EF32E401;
	Wed, 25 Feb 2026 01:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983017; cv=none; b=eYsnTaRs0f52p7Q4AW5ptzP6+nSP3knKJDBdf0Qcgo2CPdb9BWrlFNk4cApgp294wqsGX5olHDFEGcUB+1UiAG0fmlwTL5kgxq4/gXMJ5pqIJhnxZ5f5G+CYzA04VYXfazyo8X1PhNi2eHJR27EWycXqDsnoShqPcp/YFGsKda4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983017; c=relaxed/simple;
	bh=wQsuwcriK/o9WRXigW10bDJ6Pa4IBO4CsIv3JkL8caM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh5stdg8qh/D3hF178szmr1NbBPMm1bdODybI1lkr9lk1xMOEZBaomoV5aDbYcI5edgxZbF2OIpFqirPxkR8ndn3CPUk46acBTAJ66+rzVwr5Pm5DKaiQ8K0jZ09Avpia/o80ErNXUHU2zbnnddntZew/C/JOZPHEZtLjkpUKP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vysGV7lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vysGV7lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EDCC116D0;
	Wed, 25 Feb 2026 01:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983017;
	bh=wQsuwcriK/o9WRXigW10bDJ6Pa4IBO4CsIv3JkL8caM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vysGV7lQDm80RFkhc5KVCEpdZITTJ9IPTS1Xi+n3qFicXhZbx3WLUHkhzOqRyQ9of
	 wJ5zHzoHC8B7MYEOXKteLLcZJdQ48QD/7l1DZ4UMZjyqInWdTy+NuXwdxikLN+47A1
	 fH6R7Hr5jZFF7a3nzY0PDe+euQglHO3kBW+QSV1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 185/781] arm64: dts: qcom: x1e: bus is 40-bits (fix 64GB models)
Date: Tue, 24 Feb 2026 17:14:54 -0800
Message-ID: <20260225012404.183820580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit b38dd256e11a4c8bd5a893e11fc42d493939c907 ]

Unlike the phone SoCs this was copied from, x1e has a 40-bit physical bus.
The upper address space is used to support more than 32GB of memory.

This fixes issues when DMA buffers are allocated outside the 36-bit range.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127212943.24480-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 9c9e567731556..83a0a0c3239d2 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -791,8 +791,8 @@ soc: soc@0 {
 
 		#address-cells = <2>;
 		#size-cells = <2>;
-		dma-ranges = <0 0 0 0 0x10 0>;
-		ranges = <0 0 0 0 0x10 0>;
+		dma-ranges = <0 0 0 0 0x100 0>;
+		ranges = <0 0 0 0 0x100 0>;
 
 		gcc: clock-controller@100000 {
 			compatible = "qcom,x1e80100-gcc";
-- 
2.51.0



