Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DB1A23A6;
	Wed,  5 Mar 2025 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198354; cv=none; b=k1VUD7FSdMQ5aPGOIA4oM/FFDrY02loqgNU/9Yt7kWxP6VpgZXxzoAgKjn3+Ne/A7IkcVm6Mch2iVCQu9M0T3ncpX90dUSGNR6LjGuJ0IyT/vL5R8ufXDNmjpmD7dCC8vS8MrgSAj4YMrd+opPYTrUYEOtcrGiK24r4a6JFmwRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198354; c=relaxed/simple;
	bh=PM8+hTvfkTOburk8VThWBZUPqCK50im6M6fyzQLleK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yq3FRMiW6ABuzwUWbeuBkvZyN9DFzOtKHQh1uUUdIvj3pLR5wxTOrbQ9f6czs7fBYuhs+G4WZTtoR2GKwfyMEFRt2Vc4nikOEkeuRWomHHSzUrGhiOz+tg7Co2BxyNSVVQZTXsQ76L6rsOPIhEtklitlRZ/j810gSR9QcTirCI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT260gq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT260gq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E29C4CED1;
	Wed,  5 Mar 2025 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198354;
	bh=PM8+hTvfkTOburk8VThWBZUPqCK50im6M6fyzQLleK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gT260gq4t8lJFNLdEDDqwf/JFJzGCnYAiXA7aDBnUBkWrTiFpli8XuhNOxyezhaG4
	 WZ9n9ka5wh58VSZY+6pImsHBch02u6yw7cklEB9/3xkFcKrzwn3VpxQQDKZym0y0+6
	 TrC7As2I/tNvDOoQoDb4ZLhY2Velq+U+J2jhhEXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 119/150] phy: exynos5-usbdrd: gs101: ensure power is gated to SS phy in phy_exit()
Date: Wed,  5 Mar 2025 18:49:08 +0100
Message-ID: <20250305174508.596679045@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 8789b4296aa796f658a19cac7d27365012893de1 upstream.

We currently don't gate the power to the SS phy in phy_exit().

Shuffle the code slightly to ensure the power is gated to the SS phy as
well.

Fixes: 32267c29bc7d ("phy: exynos5-usbdrd: support Exynos USBDRD 3.1 combo phy (HS & SS)")
CC: stable@vger.kernel.org # 6.11+
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20241205-gs101-usb-phy-fix-v4-1-0278809fb810@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -1296,14 +1296,17 @@ static int exynos5_usbdrd_gs101_phy_exit
 	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
 	int ret;
 
+	if (inst->phy_cfg->id == EXYNOS5_DRDPHY_UTMI) {
+		ret = exynos850_usbdrd_phy_exit(phy);
+		if (ret)
+			return ret;
+	}
+
+	exynos5_usbdrd_phy_isol(inst, true);
+
 	if (inst->phy_cfg->id != EXYNOS5_DRDPHY_UTMI)
 		return 0;
 
-	ret = exynos850_usbdrd_phy_exit(phy);
-	if (ret)
-		return ret;
-
-	exynos5_usbdrd_phy_isol(inst, true);
 	return regulator_bulk_disable(phy_drd->drv_data->n_regulators,
 				      phy_drd->regulators);
 }


