Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FF359A6F;
	Wed, 20 May 2026 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298524; cv=none; b=HHosBYL34WIHXGtJDSmpNxfI414VU1rUpVO+SbxQuiRXIoH2T9tElFk0L9mmYv1kdda7kb6+pGKp2FpLIDIEltRkrQQhZjXN6gpepK9+APdwvUZj/GS0I2Le6FfsvQexzSbfLNaUX0gJ5Vq/h8c82AHJ8/PaKO9MMejEASzJ7mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298524; c=relaxed/simple;
	bh=R0iZ5pIFbNf0Rx76WimCKu64K0tRKmmkKE2dlIfB7lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgNLwWpzusF6jf5AGciV6vA4UcRzAuljHoDr2JzebR1wSITqh6VH1nUKYvsvMqF78Jlfas0ImpTKzTT11DUyPMYdnLjtCXAFyMI8RKcY5dBhGN/VWz8VlRC3jT356z2KzhU3lVf0+gaWrr7h/Cgn6372lRic+s0m9hKdRd5HtSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2qI+Y+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2qI+Y+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93AA1F000E9;
	Wed, 20 May 2026 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298523;
	bh=8QMVXWyIGvNKuPig1ERjh/2r7EFgNuvPYD+kz55SUe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2qI+Y+coMUHn6Z1k1DmLLdOn7yp1915G7QmbroQuDtr32UvrHFW3eUrX3CO4xQeU
	 kDq0G1hAyYCgrVxMFCYyqp5+OXAMix4IBGzP/iBNwrOAHww9/yMmViIwN6EYmKLCEE
	 cOrHtOSauOExj0vDCUQMH0TfebQa1vkxn5Ze+JSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/957] arm64: dts: qcom: sm8650: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:14:45 +0200
Message-ID: <20260520162143.241641853@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 6c8e2ca1263d0da5976418ed285eaec430e8d87f ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-5-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 4e34c686265d6..0faaf54e597ea 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -6885,7 +6885,7 @@ ppi_cluster2: interrupt-partition-2 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 
 				msi-controller;
 				#msi-cells = <1>;
-- 
2.53.0



