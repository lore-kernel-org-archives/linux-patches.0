Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE081FBEA8;
	Tue, 17 Jun 2025 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177724; cv=none; b=DuW4X7MVEnLgCuKaGHl4RxINU9hGg+H9z0ebnCvJx02i3pAD8mPDk/t0E4VqhMJ/hAtGoF9Z6Qr6A5jFMuYGQlewGwy+3nQQAVQirQPXn/QmIraMjGnyE6HI2fTmPmOnpq5pRb8twolZQUjl8uH5kCBOW4fKozIKZTaRpXsh4Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177724; c=relaxed/simple;
	bh=fE+FMsHTYt3gDDcWUJG9PVWU4P6GmhdlOkxDd/l5bLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyple/B57f6J/HHnU9SzA1ke7zsxu3u3wz+OJ4eAMwZUJxfMCu7HZeU1ydSL2Njl9fZdiY/bv3VMjVMe//UVCtwdDpLe/JSLLT//jBwniEFUTucuRMoekm6wISr5/iTQpWac+pm6zPD/m1pxkVv0rYBgW1BUD30mh7zKsKyOR18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV+SkXG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV+SkXG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7188BC4CEE3;
	Tue, 17 Jun 2025 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177723;
	bh=fE+FMsHTYt3gDDcWUJG9PVWU4P6GmhdlOkxDd/l5bLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV+SkXG69rrdkEvM4XKyr5J3QBX/00Pg6IgVyVKBbn28dzi7XZCEy7kjnstiNbv3V
	 kMptG41BX7+24gYFPwAPjSs/RPmgvE3WZN14QRU5anb+s1mnSdawsrRzyMFZ0Zbb0N
	 8trZU3BnsKAh2AGaWXq51ZX0s1EORtPZkur7Ukj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 351/780] arm64: dts: qcom: sdm845-starqltechn: refactor node order
Date: Tue, 17 Jun 2025 17:20:59 +0200
Message-ID: <20250617152505.754754078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit cba1dd3d851ebc1b6c5ae4000208a9753320694b ]

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-4-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index f3f2b25883d81..8a0d63bd594b3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -382,8 +382,8 @@
 };
 
 &sdhc_2 {
-	pinctrl-names = "default";
 	pinctrl-0 = <&sdc2_clk_state &sdc2_cmd_state &sdc2_data_state &sd_card_det_n_state>;
+	pinctrl-names = "default";
 	cd-gpios = <&tlmm 126 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&vreg_l21a_2p95>;
 	vqmmc-supply = <&vddpx_2>;
-- 
2.39.5



