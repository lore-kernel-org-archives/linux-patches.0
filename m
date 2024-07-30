Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCA48BE8;
	Tue, 30 Jul 2024 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355640; cv=none; b=XoBvVm1CVN6JStpNVA5yVQxSs+sBFrnDMtE5sr/X9vdDNmTRjcw3DnyB769EVF9ABGDpOGwXz/IgyIkmZP8R7MxqWdDxBOROMqAgrBNhn0mzDb/UKpvEMkJQ3b9UfBtwGAPWJg1vL6RKueOhAeBfJwVSECpiv2nuo/pveHhbXE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355640; c=relaxed/simple;
	bh=SyQhWZetFOFSRiRIfn3cOsnXpH0DvMmu3fWir6yH4IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld4T2shrv/82K8Oto4l+37SNPMRqn9igwq+YKTR5kgxlQRQ4RSpvXj9C38syoNcMThhquPaLYEZ7lKGhJILn1GKQYDK5vrNIIDEnzXKgyPJWlQg0ej4VX6senr/SC47dWSiZUXP2IaGjKbYr5DMI2GogNjX1yF5Flprg9oOhhz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcyXttrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcyXttrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE6DC32782;
	Tue, 30 Jul 2024 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355640;
	bh=SyQhWZetFOFSRiRIfn3cOsnXpH0DvMmu3fWir6yH4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcyXttrRnweYmPdvZHvEdRFCuQ4DKAdjrYwLoUZpZR8M1zYsao69ghaRXgqiCx1rh
	 MUwYmOKi41/JrPjJl2gvD6bOZ1ROMSrE9You954LAn/wXit9du6B8/FSnnpiPJR+4b
	 qIAxbYflBttehgdgJYc31qo/c2sInKWe67ApWFZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 055/809] arm64: dts: qcom: msm8998: enable adreno_smmu by default
Date: Tue, 30 Jul 2024 17:38:51 +0200
Message-ID: <20240730151726.819143471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit 98a0c4f2278b4d6c1c7722735c20b2247de6293f ]

15 qcom platform DTSI files define an adreno_smmu node.
msm8998 is the only one with adreno_smmu disabled by default.

There's no reason why this SMMU should be disabled by default,
it doesn't need any further configuration.

Bring msm8998 in line with the 14 other platforms.

This fixes GPU init failing with ENODEV:
msm_dpu c901000.display-controller: failed to load adreno gpu
msm_dpu c901000.display-controller: failed to bind 5000000.gpu (ops a3xx_ops): -19

Fixes: 87cd46d68aeac8 ("Configure Adreno GPU and related IOMMU")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/be51d1a4-e8fc-48d1-9afb-a42b1d6ca478@freebox.fr
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 2dbef4b526ab7..a88bff737d173 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1590,7 +1590,6 @@ adreno_smmu: iommu@5040000 {
 			 * SoC VDDMX RPM Power Domain in the Adreno driver.
 			 */
 			power-domains = <&gpucc GPU_GX_GDSC>;
-			status = "disabled";
 		};
 
 		gpucc: clock-controller@5065000 {
-- 
2.43.0



