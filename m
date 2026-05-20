Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8E93F787E;
	Wed, 20 May 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300744; cv=none; b=qvob5y2zaO6oXG+Hw6Zl0/U57BZ3QXtkC8952OCacdr4C25VTwXmVmlyW6bT+f+lKRS0TT3p+a41O8NzpvK3Kx1XG9s7WMwRQrZqO7NU6Z7iib4sQobVRgBf3WjDI72I7lJtGg1m8qMx/ad+VFYFt0HkDhBozqIm0iRhkKuWwB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300744; c=relaxed/simple;
	bh=T+P+szrvytwq4+NEKGsK7zGP5e2vUJrr5w5rrTs8ObA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji2vYcfa3fxC1n1EOll5SREQ+PQp4tCajubE+eSCtV4XmWlyJSerAwbmhHgGg1gfZYGLgbT4O8noCWODCci3l6/MyE8QybCqH+JG0Dxr5JBkGd/WzYZ5ElWcf4a6oWcPfQhPwRKekxujg3wuMZBseXBrO9zuN8gbT4LYoL0rBNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZfrBDWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZfrBDWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5851F000E9;
	Wed, 20 May 2026 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300743;
	bh=m9p0AfIJPbJoVuDRXPFTEVWPo9dSilw7SYDouFUU7/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZfrBDWGIfJ/txzIAi1irohwM9d0D7Im1E5uOT7/lPHw89e/Qbuero6GSWRD75zpZ
	 OXFziuMRLcYXNDfLSJ3kN40fLjHqcyWNCPAVjJdwr8rqhZl4bh8P3ll1RLYHiMYCp1
	 BbEY01iZ6E9wTRVBrSUzArCAfj03B5ur3D9mmuP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/666] arm64: dts: qcom: sm8650: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Wed, 20 May 2026 18:18:21 +0200
Message-ID: <20260520162117.501424710@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 93f823e7d48232e62fb8fb74481696609c90244a ]

The restriction on UHS-I speed modes was added to all SM8650 platforms
by copying it from SM8450 and SM8550 dtsi files, and it was an actually
reproducible problem due to the overclocking of SD cards. Since the latter
issue has been fixed in the SM8650 GCC driver, UHS-I speed modes are
working fine on SM8650 boards, below is the test performed on SM8650-HDK:

SDR50 speed mode:

    mmc0: new UHS-I speed SDR50 SDHC card at address 0001
    mmcblk0: mmc0:0001 00000 14.6 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.8086 s, 43.3 MB/s

SDR104 speed mode:

    mmc0: new UHS-I speed SDR104 SDHC card at address 59b4
    mmcblk0: mmc0:59b4 USDU1 28.3 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.9448 s, 82.9 MB/s

Unset the UHS-I speed mode restrictions from the SM8550 platform dtsi
file, there is no indication that the SDHC controller is broken.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-7-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 72a75dec13c73..6098206350f90 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3442,9 +3442,6 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			bus-width = <4>;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0>;
-
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
 
-- 
2.53.0



