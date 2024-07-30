Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED41C68BF;
	Tue, 30 Jul 2024 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355242; cv=none; b=c97L6QOHGAKZoLs+5kbes2LqwNEvfjU8cE+7OAWHaLeiujR/x43EPMb2hDRjp0PJ6yg70K7UTJGCoLxUdkEQAeIoDovNql9TU9VsZg/7up0fUG0I3W4RBpYeNyCM4tew8Na7VjotuudN7pn3dibcdiYmWQe05C1Fdc5lpBg511c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355242; c=relaxed/simple;
	bh=DiOW71fzR4UvRwPhekKxIdCWrbVktcgE61R91f+9Uu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eO2vaRGxvbJlkvFxUmi+WhOQCO0tPVMMdfGvIUpETmlU4OQS8u20FQYqqXkczYUmD2WKLMJW5vvck3ZvSts5JTa7iV+IAQJfXbgGVhDUaBYrLuSrqAP49iJg3+DoipHnWD/YSlrlfvsGkCbP+Qt+9hbnehsGaD569yGMuik5GyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUg6Xqwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUg6Xqwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D77C32782;
	Tue, 30 Jul 2024 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355242;
	bh=DiOW71fzR4UvRwPhekKxIdCWrbVktcgE61R91f+9Uu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUg6Xqwe0iGZ/+Al+uWJcOazKl9YTk6g9T1R2xfZL3TpQ26PsNml+3aHTXEQ8zsej
	 e+OsseReaRmQv2GBOlItWZ0d2UEXnIJXWAX2cVv1OXwB4UlGySeJcdxD+RTKgOAa79
	 M5zkJGtbqXbaByL/4cK2z21ZMcNMObzERX6mgrgg=
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
Subject: [PATCH 6.6 040/568] arm64: dts: qcom: msm8998: enable adreno_smmu by default
Date: Tue, 30 Jul 2024 17:42:27 +0200
Message-ID: <20240730151641.405256541@linuxfoundation.org>
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
index f91c58c844afd..9c072ce197358 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1588,7 +1588,6 @@ adreno_smmu: iommu@5040000 {
 			 * SoC VDDMX RPM Power Domain in the Adreno driver.
 			 */
 			power-domains = <&gpucc GPU_GX_GDSC>;
-			status = "disabled";
 		};
 
 		gpucc: clock-controller@5065000 {
-- 
2.43.0



