Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D610828DC4;
	Wed, 20 May 2026 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298429; cv=none; b=isPtJrx2vba142Z0l6UfmRg04NGiRlPmnOeMojV0Q8YZlqQFiQGpPtRh/TV4E7gzBqldNFI4OXhfRYwJW4L3y3T490mtquHt7Uh2kKnJnIUlkfVaPP5qYcphLWNby8HP1eW1/B31aS9oXOE+QLvbX8PdSA9hI8Rk+jjZFGQpyfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298429; c=relaxed/simple;
	bh=E2a07I6341wbAapEqyeSKH9NCf9rB3tQ4Xem2ca+DnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=covriG/LNOdVoDkZ53ofVJHDnFYF74xwSkbfml8fSs+iMzqhfHfp73L+H/7/e8LJVSHNXfMLCYMu3I/Xbt4B22riWS+kaJPgycZSzh8qfE4jm6cvf0ZCATCLwPfFS5V5Q5rAK/XDvZ3gQFdK7osnkb23dr/hp8Kqe/7JCz6ojb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9xQ+OJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9xQ+OJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4718A1F000E9;
	Wed, 20 May 2026 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298428;
	bh=nNkgFm/FVgXZwjt3vdgpXMlep0P55Xq63gd/LTLK/TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9xQ+OJ35KXw2ocsZLPGJ9oBontHeMOcpoMMOcV3DQyX1gM16Zns+M9jiovgsIoxJ
	 0G4Tehtit/GDn5kgwtVLlh3jGUmwAUvBPoet0d1JFjhS+vYCKhFGPuErxncAzhO6pG
	 ViA2rtnsuRyKyQb6OaOKxrw1wUOta/BtnQ9ogNxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/957] arm64: dts: qcom: sm8550: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Wed, 20 May 2026 18:14:51 +0200
Message-ID: <20260520162143.371607334@linuxfoundation.org>
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
index 002ed12f942c0..118a626dfcff5 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3191,9 +3191,6 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			bus-width = <4>;
 			dma-coherent;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0>;
-
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.53.0



