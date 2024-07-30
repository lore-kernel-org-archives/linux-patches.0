Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AFE29A2;
	Tue, 30 Jul 2024 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354921; cv=none; b=rORITGV6MhVeGaATpPyANABVW6qBF7pzuly6MtJ3GxgIckzja1/ekmJw7C7BeHLEhpof4rr6uRocZsiX/EduAYJ5nJKtNjS0uWfkqN0LTFkR3qZVFfdMmjv1j9V+LIZSU2HooG+c/E6Vom81lai1LW4vP4lROE2RPNcyPAqMKDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354921; c=relaxed/simple;
	bh=lQW5lSEmAh9sTzYNoN9pGipw0cG6f2a05/kzhcQLOP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX3WvWr2VOXiUoar7URlw+J20dJuuLNYX6V/dorB5FVNW/IwpKeFcVH61/AGQOcWwPuMg4TVfoC0Ze3B/0h15CHTBjfU3GW78YL8WH2rwBZBBLjj7ILWCG5ZszDR+i4m9cBe0OJyZeB+z7cqV8PHaDv59dCKvBhFjJdJd4eohHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ1eRvwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ1eRvwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3437BC32782;
	Tue, 30 Jul 2024 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354920;
	bh=lQW5lSEmAh9sTzYNoN9pGipw0cG6f2a05/kzhcQLOP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ1eRvwB8netNXi6GZbPz97JNqKyCeFIJ4uPNLInBGNO32YNK8vwodeGyc2Q+eomp
	 XHaTWmYICWmuEKk6Vo1ghiZgob0FVwBUMBm5bwEPStdIPneEyau4th2P0e5d4Asjmp
	 tcC+61TRZGPIKf1OmRTxR7WGiKG9jOeCFQQrR21E=
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
Subject: [PATCH 6.1 037/440] arm64: dts: qcom: msm8998: enable adreno_smmu by default
Date: Tue, 30 Jul 2024 17:44:30 +0200
Message-ID: <20240730151617.212449077@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a41250539ff5..3d4941dc31d74 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1457,7 +1457,6 @@ adreno_smmu: iommu@5040000 {
 			 * SoC VDDMX RPM Power Domain in the Adreno driver.
 			 */
 			power-domains = <&gpucc GPU_GX_GDSC>;
-			status = "disabled";
 		};
 
 		gpucc: clock-controller@5065000 {
-- 
2.43.0



