Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7B92EA173;
	Tue, 17 Jun 2025 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175290; cv=none; b=pbkoDg1i7IwA+IECP8Tury9nTmh+k+2iT92lYx8FsUQTWmwGia7Sb5okevAw8uRVVU4RyHlB59cUil54VdMw9xYNSywv8XXWSJuVG0auT1fnzQ60GmEj8Jecks6RKXmxw3YRVJeMjuefyBP2uUQ6tTk8lyTLcQ6V8nIVK6/JLlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175290; c=relaxed/simple;
	bh=tm8y/fJBuYicXPwKwrlCulH3eVqGku2Jrz2lbRh5njU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNtMVs0o2jyVwag/zBrR2Twb/mITJpXYhj0Bfw3q3bH/sf4vPMFxfkhwGWMSjyoItWYk9Um61vpyNsU8f+Az5RodCRyOJ2hOji0gTDiVWs4jPliy8tycDZNzUaOkpESRRhuIe8hcQBe6UzEn0SmpLLmJh9JkLchZU+yRR+fAMiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoaWYSU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoaWYSU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F431C4CEE3;
	Tue, 17 Jun 2025 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175290;
	bh=tm8y/fJBuYicXPwKwrlCulH3eVqGku2Jrz2lbRh5njU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoaWYSU3kRwi/QzAzZuAxr1esx7qgLE4buF55bHXb1YMB9Cl7vIrv5a+vDOtPKFWx
	 fJ4OhYGJm50d5Wp8Fl4dgFdIoAOrrh7utNdTjL8Hvwsa3Hcc0vHKlCSWRXEBvVEyFB
	 H3T2Er0PvfjxCJBfyKj+9n9tVChgH+K13blkiz2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/356] arm64: dts: qcom: sm8350: Reenable crypto & cryptobam
Date: Tue, 17 Jun 2025 17:24:36 +0200
Message-ID: <20250617152344.704074744@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 75eefd474469abf95aa9ef6da8161d69f86b98b4 ]

When num-channels and qcom,num-ees is not provided in devicetree, the
driver will try to read these values from the registers during probe but
this fails if the interconnect is not on and then crashes the system.

So we can provide these properties in devicetree (queried after patching
BAM driver to enable the necessary interconnect) so we can probe
cryptobam without reading registers and then also use the QCE as
expected.

Fixes: 4d29db204361 ("arm64: dts: qcom: sm8350: fix BAM DMA crash and reboot")
Fixes: f1040a7fe8f0 ("arm64: dts: qcom: sm8350: Add Crypto Engine support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-1-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 5376c0a00fab6..215782b1970df 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1754,11 +1754,11 @@
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
 			#dma-cells = <1>;
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <16>;
 			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x594 0x0011>,
 				 <&apps_smmu 0x596 0x0011>;
-			/* FIXME: Probing BAM DMA causes some abort and system hang */
-			status = "fail";
 		};
 
 		crypto: crypto@1dfa000 {
@@ -1770,8 +1770,6 @@
 				 <&apps_smmu 0x596 0x0011>;
 			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
 			interconnect-names = "memory";
-			/* FIXME: dependency BAM DMA is disabled */
-			status = "disabled";
 		};
 
 		ipa: ipa@1e40000 {
-- 
2.39.5



