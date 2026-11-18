Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024445;
	b=i7kbMO7tG7jd/eVVXcWyGhLT0mengTQAGvkVzG4XYr6JlsOUQ1hAL22bdEbI3gCATiyC
	 a7EuevU01wP5cXSNvFyCwd6YYm8HGDOuUIq9iSDg4K5K/xkId9v4dXmrmBBEdNyZjNF0m
	 QxfLBoX4mI23IMl+aVczQ/QrEnMSupgY8xiaaW6SkeBmkzVfrcdsA7pW9XHI1carjTNxn
	 5I3khtWAnLIQwBeWRHBUv20pxj9xR2lkxPSsbUG8h13aoilz8tBBZsB0+L5P572x49HVi
	 xCHqLpCMIMNDb40ZBdLORClrvBjhuccRdjhLLnrvlG7DccIJKGX9cb+x5J48FJdUvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d/rYyzsmmMMRJR91oxRi9MTFAkut1VTF254ax/r2q1M=;
	b=i7UkSmR4tW8vqCb5cDW7wvH83FQO+qJ8ASDZFC//tlyWTm2cgkPCEt8QUeYxsu9F2NHS
	 CUVRTDcOe8C2Zda0xH9hmutCiUVmhdz52oFSlZBSXT7FYDE50mT3HnpXT0ybIltv6rsDH
	 cNeiRv0hFQlsll3S3OJ7wQqB/LaaWw0AzTUmRA94m9qAYwky5BKMfw0Yid/0ChAefm/GC
	 VeIUrp6LqSb3hu/0uhOjfF+rjVg2Rg11PFmtEVrEEbxnPlCirSvW9rWoxqEcTCBUELx/3
	 FzlhRZ/8ZllNwN5CQOtweZXhAwJXtavZ7p3ZTqUtZVmQwLw8XP3sIBPr12vcYiP/d7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2gq9cfO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB89606A32A;
	Wed, 18 Nov 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2gq9cfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E31D1F000C4;
	Wed, 18 Nov 2026 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024445;
	bh=d/rYyzsmmMMRJR91oxRi9MTFAkut1VTF254ax/r2q1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2gq9cfOyPGuMlMMICvYVVSfJ92jQomwiSlnmOFElPHoyNdCzh2kgV/EXzIstW0/V
	 3FmV5fC5avvjM+w+mXdUXUOd6CEHy9kLI4AiknP2Aj/IBjYyIeCVaVpVSrO6qK7TZB
	 YXxWGagxrA5zpL9GQtLbMfExgJqc7BrP9NNI4pvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0727/2151] arm64: dts: qcom: x1e80100-yoga-slim7x: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:02 +0100
Message-ID: <20261118150148.517534773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit a92ac66d35dfd8438b6e40bfb956ff69365798ac ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-6-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index 56e4d13cca111..b621322d248e1 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -1348,6 +1348,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



