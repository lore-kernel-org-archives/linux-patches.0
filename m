Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A6156225;
	Wed,  5 Feb 2025 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765411; cv=none; b=KWmy9Kyl2Dc+3pl9Uog6lxkEbRvlwxz8FW23xF9zNzqzHpgiIjh1pBFdCPEVesZiKbVYSpojf3O7XIGcW2dgjCvN2K9b7JvK7zNsbs/H3atleHEY9SGWd106N+kqbkkFQQybb5cIFn14G5Mug0tuHE4rYdZIAXnw87/Q272B5Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765411; c=relaxed/simple;
	bh=ZbthPkR9aLcM2Ahs7oDANN32V4KRQOoG7T5Ub2ephO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tysgPfnXEpTLZzAX160sLtbSTBJnuyDQQrJWHaRVt09TdafrrquwfWcACMI+/I+el+wyg6a6NQe/yYiTek0reS7l9gtbMqnn8kyMmT9tR7J/sIZDvUwtJpOvJd0z0ovUdbut03V4Ti1Fo/TnQX1W6nsEi4w3XcWeFfzJvZy8Ctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBwBLejE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBwBLejE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA1AC4CED1;
	Wed,  5 Feb 2025 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765411;
	bh=ZbthPkR9aLcM2Ahs7oDANN32V4KRQOoG7T5Ub2ephO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBwBLejELojK4n56uCbLkEY9aDGR9HrAFBMPQOQWVPuVar945SnoI6we34Eie4XLy
	 nXauNk9FvMe5JeGCXwn5Y+piJ4PJy89LHrTK9GKBO2FJ+8eBW7A6Y1VeRFRX7TtB35
	 hEbIYtNpp3mvAZxt/zzzOvceWDRax3PYsLQzfFP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/393] arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes
Date: Wed,  5 Feb 2025 14:43:04 +0100
Message-ID: <20250205134430.450846590@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 7ec7e327286182c65d0b5b81dff498d620fe9e8c ]

Make sure the remoteproc reg ranges reflect the entire register space
they refer to.

Since they're unused by the driver, there's no functional change.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20241212-topic-8280_rproc_reg-v1-1-bd1c696e91b0@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 6425c74edd60c..3e70e79ce24b0 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -2642,7 +2642,7 @@
 
 		remoteproc_adsp: remoteproc@3000000 {
 			compatible = "qcom,sc8280xp-adsp-pas";
-			reg = <0 0x03000000 0 0x100>;
+			reg = <0 0x03000000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -4399,7 +4399,7 @@
 
 		remoteproc_nsp0: remoteproc@1b300000 {
 			compatible = "qcom,sc8280xp-nsp0-pas";
-			reg = <0 0x1b300000 0 0x100>;
+			reg = <0 0x1b300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_nsp0_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -4530,7 +4530,7 @@
 
 		remoteproc_nsp1: remoteproc@21300000 {
 			compatible = "qcom,sc8280xp-nsp1-pas";
-			reg = <0 0x21300000 0 0x100>;
+			reg = <0 0x21300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 887 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_nsp1_in 0 IRQ_TYPE_EDGE_RISING>,
-- 
2.39.5



