Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31E3659E4;
	Tue, 16 Dec 2025 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887100; cv=none; b=aslUELpgPKFoI794sW/BBCyGpVkiMYUMvFHIiWQSGApBHWgAD2ulIxKMgGDJB/QdL3eFiwr9p7ubA4gDFXOot2eDIYiewVYtLaFanmrfvsHlO7c5JWMy34fYokjLdkO4xI+c1Er94DD1ysx+Jem3f2JTQp/bJcPtxkSnsZRq3/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887100; c=relaxed/simple;
	bh=QbMkeZOnv0N0KCQ+eRyHnzp9QBCr2EYyglhSu2ne6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BplI5mhCLEEnU+gAB7U268niefKIhdKa8LlB0rG/Prggl5xjal7X9B1hkRiqsEl+nSyWUz9ccMTI22oWIaRZ6dNRapG/FH2Vd1wa901ChJDQyYTCK3cMNufR4D0kyOujp/Nudi+lZvx6I9XvLFr0ajqvNv5wM7XEOxs+lAnyeY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYuB0ePt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYuB0ePt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529BC4CEF1;
	Tue, 16 Dec 2025 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887099;
	bh=QbMkeZOnv0N0KCQ+eRyHnzp9QBCr2EYyglhSu2ne6x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYuB0ePtB0ljkkZFM3y3ORNdQw+2BVYUjo8c0t+1VPByRrKbYaduqw5TUmkZBkgrJ
	 NlaYaZ2Wh8bc7NoUXp0Cd57UpmgD0yM23h0n/3UOf2/3IRX1KBExwZ5comV1HqdhSa
	 tGh2y2WFeL85EG9/EAgI5Jkc1/eLNiJV9uidmpFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eric=20Gon=C3=A7alves?= <ghatto404@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/614] arm64: dts: qcom: sm8250-samsung-common: correct reserved pins
Date: Tue, 16 Dec 2025 12:08:12 +0100
Message-ID: <20251216111405.866121759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Gonçalves <ghatto404@gmail.com>

[ Upstream commit 42e56b53a1919dbbd78e140a9f8223f8136ac360 ]

The S20 series has additional reserved pins for the fingerprint sensor,
GPIO 20-23. Correct it by adding them into gpio-reserved-ranges.

Fixes: 6657fe9e9f23 ("arm64: dts: qcom: add initial support for Samsung Galaxy S20 FE")
Signed-off-by: Eric Gonçalves <ghatto404@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251016202129.226449-1-ghatto404@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-samsung-common.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-samsung-common.dtsi b/arch/arm64/boot/dts/qcom/sm8250-samsung-common.dtsi
index cf3d917addd82..ef7ea4f72bf99 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-samsung-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-samsung-common.dtsi
@@ -159,7 +159,8 @@ &pon_resin {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <40 4>; /* I2C (Unused) */
+	gpio-reserved-ranges = <20 4>, /* SPI (fingerprint scanner) */
+			       <40 4>; /* Unused */
 };
 
 &usb_1 {
-- 
2.51.0



