Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3D4375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301724; cv=none; b=hTnvtSK8Ep2WpJQwOiyEnGDGOB2mjUbdWYsTs9Il1nd7cmpDM59r1rBmx6R3+blo6G5nQhTuc4p+6qGmxXL5VWBUWOziCj2oWJqHfOLA6aOBp5usb+Xi0crGJrQcvQ6RVOPZ8LcQMsD3cogZPPhFf2CxwdWwyaBs20puqDZbwKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301724; c=relaxed/simple;
	bh=i6uJbZQJk+9SK7zRrF7vxMsia+Lc9MgQFFl7IrtCE/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgUCIAvHqpRuzUqhhG0SlN6js+djJV7NrNawTnIiqUly+xK186zw/T4fhX7fzeOYjr0wu00P+3DVN0G6FP9zxvP2hOePwPIgOFvrEd33eC1j5AFb1lu7o6bg+G+u/ZqZUm8fbiBjyoY6S80YPeHNwWi3lpgQjlbqxCdspMXjwyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7smdXAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7smdXAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4B9C116D0;
	Sat, 28 Feb 2026 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301724;
	bh=i6uJbZQJk+9SK7zRrF7vxMsia+Lc9MgQFFl7IrtCE/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7smdXAkvfMoacdBAOwiOoOLsXOhsbW7iZPXhrqOETfJvcDWi0lvgvFBp1971hFex
	 xdMhU5lb2jj8WeVsyVWnbCQrrixaIUubfHuoKju0YOHE9TzyTOg7L/J2Xp+dEzGWF1
	 nC6Er0S5BzeZDl2tljOwvYYsl7gQJlOvT7PUMbubnDvjmFXtGvFFZFc9zMMmiH1iMG
	 wgNrn7JPdNFvrm4peEhWnmINcwfUmOER9B90HQzFLzer1BBYt7uoyDiUwGBfn9YMys
	 X5WFNDl2FHiQ0akTQr6Ec08ZUIMtAgKsvkmJJAs0lPXqLqFNs900LbSlV+aQ6aKXye
	 kvDcNSe5806ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/385] arm64: dts: qcom: qrb4210-rb2: Fix UART3 wakeup IRQ storm
Date: Sat, 28 Feb 2026 12:55:44 -0500
Message-ID: <20260228180011.1568201-122-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c5dc4812f6bf397b82290c540085e9ec98b47b30 ]

Follow commit 9c92d36b0b1e ("arm64: dts: qcom: qrb2210-rb1: Fix UART3
wakeup IRQ storm") and apply the similar fix to the RB2 platform.

Having RX / TX pins as pull up and wakup interrupt as high-level
triggered generates an interrupt storm when trying to suspend the
device. Avoid the storm by using the falling edge trigger (as all other
platforms do).

Fixes: cab60b166575 ("arm64: dts: qcom: qrb4210-rb2: Enable bluetooth")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260106-wcn3990-pwrctl-v2-6-0386204328be@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
index f99fb9159e0b6..547c6d4204601 100644
--- a/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
+++ b/arch/arm64/boot/dts/qcom/qrb4210-rb2.dts
@@ -636,7 +636,7 @@ sdc2_card_det_n: sd-card-det-n-state {
 
 &uart3 {
 	interrupts-extended = <&intc GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
-			      <&tlmm 11 IRQ_TYPE_LEVEL_HIGH>;
+			      <&tlmm 11 IRQ_TYPE_EDGE_FALLING>;
 	pinctrl-0 = <&uart3_default>;
 	pinctrl-1 = <&uart3_sleep>;
 	pinctrl-names = "default", "sleep";
-- 
2.51.0

