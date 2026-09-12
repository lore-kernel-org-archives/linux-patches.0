Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D52D346AE3;
	Sat, 12 Sep 2026 07:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199058; cv=none; b=sPsaORvsrB46WRGz85iXhR6kUA6c//9SjeikaaA2Bxo6FLePkCf+1HI/zikTSFIIszCkMmO9bg9mpHcdoZUhpwWIq239eP6tKU4YENC46ilfOiBETCXp2Chth4zwNsJvuBXGPUPyJQtWavebg/CHpyGS1jaZNuqekNxLamGCA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199058; c=relaxed/simple;
	bh=oNr7107Flt5KWKivLTjwmbe2b3fLO/rkMYzbKaOT3mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmqNOzhD0XudRbWwfF3j8HC6RQmxIQu+dpbZ2BIyWKl/TSgwr7GNEDy5vd8+PNdmW8iRTaqgL6MP/6TAojrLccwPdaI2CJrLT6AZROeiHEZP0eVGpvJFTSOXJkxDz0k4jpwdSJDR0dyEbYs9un7kZUe16Mb6KJ4lePU/BhizlrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/QMnU/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/QMnU/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C861F000FF;
	Sat, 12 Sep 2026 07:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199057;
	bh=mIguXmxUAhW2kb4Lj8DpwfT0Ofxg5t1vWlH8eX17e0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/QMnU/Q7ZkPmY3YYsi/XWKOesrw7kxUiQF8nOsohH+Zi9HpBhvaqaUo9BFri0rY0
	 6kbFJK7L704nmsmo/JC9vV8f5wQr94jJ9On8qpTR/tUzZ5FeUxdtGTipvSbsnaNCrm
	 jcZT9j/JpMzFRaQaSo8oAmFfQwxg56XbN6rTkX4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0454/1815] arm64: dts: qcom: milos: Add reset for sdhc_2
Date: Sat, 12 Sep 2026 08:36:44 +0200
Message-ID: <20260912065659.548884877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit c3eceb0627605564f102dc0f5ca4a6060ca57fd4 ]

Add the missing reset (BCR) for sdhc_2.

Fixes: d9d59d105f98 ("arm64: dts: qcom: Add initial Milos dtsi")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260710-milos-sdhc2-reset-v1-1-c7a155a517ba@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/milos.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/qcom/milos.dtsi
index 8c92329889538..262fa88012562 100644
--- a/arch/arm64/boot/dts/qcom/milos.dtsi
+++ b/arch/arm64/boot/dts/qcom/milos.dtsi
@@ -1724,6 +1724,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			iommus = <&apps_smmu 0x540 0>;
 
+			resets = <&gcc GCC_SDCC2_BCR>;
+
 			bus-width = <4>;
 
 			qcom,dll-config = <0x0007442c>;
-- 
2.53.0



