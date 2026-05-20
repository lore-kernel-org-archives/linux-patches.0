Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0789A3CB2F8;
	Wed, 20 May 2026 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302263; cv=none; b=eSkGxEhQUJz0P5/wM2nQkaq+zViq3dzMsNf2dod50LTD5K2MnyBTsiKoLn0uOiR9xa1lNzr4NNm//UoKnmvaeJWgwFQ6GrinBZckbMwG/yp9yB2hh5tV2JQHfe/UbmUbTA2Xz8n9/S1fgdmCdahKIfIEk2WsC9RfgSh1GrnuJvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302263; c=relaxed/simple;
	bh=nOoioEbgA2DEY63LtTy3hjsTGpsiTMfqJNi528xOa2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbZo1Me/giZ+uXXbyschrLAeN213K6VIF9lBKrY+V3QzJ1zICcmST/nVwPmMknb+NDPhuyInmgVzhDhqeMZGUxNUP9R4jLpi5fuY1NysR1SB3KE4rSBO67EDB+gftqC0rkYyTqQdHGQH3IEndH6X/US4RoGcnul8nnnNMBSbgm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANQtVbkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANQtVbkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F481F000E9;
	Wed, 20 May 2026 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302261;
	bh=ZeccV/AVFQ92IjmC24GAwCMb04psNGvkUTKFfSkT0lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANQtVbkBLq9fGDDmei2NQl4UXPy3xUd13TKlYSRVev5mJcwVQC1jMJhNaJnVj2CGH
	 oJVMD084HmJ1uoUKspcIHzNsKrStqULRdBfsjIIS3eVQSby7jOaq5hHlxE6dOiiNiU
	 jMtcW64Ms3rxM5SupTPZl6drVk/qhMDpQA4mubos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/508] arm64: dts: qcom: sm8550: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Wed, 20 May 2026 18:20:22 +0200
Message-ID: <20260520162102.948005206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 66b0f024fba0728ddce6916dce173bb1bdd4eab0 ]

The restriction on UHS-I speed modes was added to all SM8550 platforms
by copying it from SM8450 dtsi file, and due to the overclocking of SD
cards it was an actually reproducible problem. Since the latter issue
has been fixed, UHS-I speed modes are working fine on SM8550 boards,
below is the test performed on SM8550-HDK:

SDR50 speed mode:

    mmc0: new UHS-I speed SDR50 SDHC card at address 0001
    mmcblk0: mmc0:0001 00000 14.6 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 23.5468 s, 45.6 MB/s

SDR104 speed mode:

    mmc0: new UHS-I speed SDR104 SDHC card at address 59b4
    mmcblk0: mmc0:59b4 USDU1 28.3 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 11.9819 s, 89.6 MB/s

Unset the UHS-I speed mode restrictions from the SM8550 platform dtsi
file, there is no indication that the SDHC controller is broken.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-6-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 3d14575e5aace..5a79adbe8da12 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2535,9 +2535,6 @@ sdhc_2: mmc@8804000 {
 			bus-width = <4>;
 			dma-coherent;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0>;
-
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.53.0



