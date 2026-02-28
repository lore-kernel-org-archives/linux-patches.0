Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404634A3AB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302683; cv=none; b=dB4EcpI8EmvWsq6c/9bho03hmRgpUF4soey9sBOBym+26iCa3gTPWPHp4xpuVFuEK0bv4Qpabf/luTp+p+JX56ydzouMJxpwaj4DVaVFdq9qCRMRm6ECtxQHxp97LUEFDT/QTXlbgDGvyylWEY9ykw457CKut47M2fz2mUxTK+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302683; c=relaxed/simple;
	bh=VaXaGLpqvndurlpsNcuhHuSJ+lph+hB7UlowBvH3dvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbxoCW5U2J66hWf8Pl8XlFWgWDKrMVu4+fxYqMnqN67RtZJ213mtIHXGSkf/M3XybcTika2+Jxnubd7eQfn1xwlbvyPNHYsGuG1W5vmdT8QEa0b6nOfqOTfKeGQVPAsLPrfuuauGBOEUkgBWxhCsHvqDxpX4ZBAr38GasZpQNmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I26QpDoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I26QpDoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83031C2BCAF;
	Sat, 28 Feb 2026 18:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302683;
	bh=VaXaGLpqvndurlpsNcuhHuSJ+lph+hB7UlowBvH3dvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I26QpDoqN/3NBz3nxwoQYbQ/iKmMMTCSmZRR/hftLbJTK3DSVlQksGkTEgvkManDm
	 UO4p4FX42idlalrMBX1NdvHkT4tLUJ03ujcVeeoF1tM+j9+OhfdFJ95Y5Q2v9iAg27
	 vxuegeyMsQ9dgzpsww+yCwvYestuAfaWO3T7iEKPII3T/VaywZJtPymuob92LOP7tp
	 zVd0KgXfSmGDzMEAOV16O5mP5JKMIIh0AVgOW4bOiSBHW37ssA0E4O1qqhXlDCT2wr
	 tlcsfXMy1RJMd/xjw59VvzJwZo0v0YhhHsY0QwjHC1Wmhwv15f21Sp0fUfZ1ev0eOP
	 xH4Q+/sh8nIHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/147] arm64: dts: qcom: sdm630: Add qfprom subnodes
Date: Sat, 28 Feb 2026 13:15:42 -0500
Message-ID: <20260228181736.1605592-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 142662f8f43c1725418ff13a2c83fb218d2b0911 ]

These will be required for USB and Adreno support.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210728222542.54269-7-konrad.dybcio@somainline.org
[bjorn: y/_/-/ in gpu_speed_bin]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: e814796dfcae ("arm64: dts: qcom: sdm630: fix gpu_speed_bin size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 79d260c2b3c32..d810ab74204c5 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -460,6 +460,16 @@ qfprom: qfprom@780000 {
 			reg = <0x00780000 0x621c>;
 			#address-cells = <1>;
 			#size-cells = <1>;
+
+			qusb2_hstx_trim: hstx-trim@240 {
+				reg = <0x240 0x1>;
+				bits = <25 3>;
+			};
+
+			gpu_speed_bin: gpu-speed-bin@41a0 {
+				reg = <0x41a0 0x1>;
+				bits = <21 7>;
+			};
 		};
 
 		rng: rng@793000 {
-- 
2.51.0

