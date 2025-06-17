Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86B2DFF00;
	Tue, 17 Jun 2025 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176402; cv=none; b=icH/mo3RfVbOr+x0ksN8AD8073o13wz358f7uDrqv0qR0lcqCtrY0iWJpXH9bfUBQw68k1cpyfeb2l45IOrjmIoIKG8zTesBh38GKScUqXFXkQ3JWFPEPOgYO26we6yMGElmlkmcw0gM4q7XobKj0PwNj0lS2uBWuKi8M5zO7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176402; c=relaxed/simple;
	bh=y2MrZHMVzJG389A7qQ1DCM1HT+PkkIKuLGsl9qaghfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l49bHRfe2hfakZ2mKVP4DBJDioU6zoud6o+lCYUVznLYBsiXAOixGCS4G1pzzyPzJWeldZbtyNmuHLKGoz0S+8uJwZs0LNpKyNW3+fHjlDUIb9sVGLnzhJnTrqZks/bcpuHWeHydAwl0/LjqpW0r2BTcfis7gdCaXGwE0UvdyYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsw9uaAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsw9uaAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73539C4CEE3;
	Tue, 17 Jun 2025 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176401;
	bh=y2MrZHMVzJG389A7qQ1DCM1HT+PkkIKuLGsl9qaghfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsw9uaAhX39rBZjJUPgUFdslVxkk+Ql6Y72iba0Fd80Xjcw07S2AbY/NqJ/KdDZrF
	 G3OCX/Oda3d11u4p8vzuOjadDuK7bzm2pcI/LWxLjSKqydGPWIlLRxHiSawVNDO0Qf
	 nzLO2JJBZlAuThlqXyaWUERTjssIlTdRh+Pm2lQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/512] arm64: dts: qcom: sm8350: Reenable crypto & cryptobam
Date: Tue, 17 Jun 2025 17:23:12 +0200
Message-ID: <20250617152428.778167093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 404473fa491ae..0be8f2befec7c 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1806,11 +1806,11 @@
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
@@ -1822,8 +1822,6 @@
 				 <&apps_smmu 0x596 0x0011>;
 			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
 			interconnect-names = "memory";
-			/* FIXME: dependency BAM DMA is disabled */
-			status = "disabled";
 		};
 
 		ipa: ipa@1e40000 {
-- 
2.39.5



