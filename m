Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCCF1ADC97;
	Tue, 17 Jun 2025 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177941; cv=none; b=l1s1QWV2cbw3xvR49eNkiUgN6el/ySoy/3+R2a3KCqRDmgKwvCnRd7vuS2z6WIMhIBfYomS8v3QbOGX5SKlTLsuctrLRt6VaRcP4liiyRXcnP6h7AZBxX5ysE7FNx2z7kqAa9rOJGehyG1TmJhb7hzVSv4zjnPY3a8v2+ieJO/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177941; c=relaxed/simple;
	bh=Fv7XeuZPUQjdnW6PsBvTXU5z7CztmHrhaGyV1FHg71U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbfWAnzZE0kY4yD1i1yukum6uA+zgkTRVpsQ8uBjYbRGh+8gaGX3Izmq4VvS4xFFEK9SKoZgESccYUELP0MXLNvPSn4vMwuMm9HLbKOs5M9NQh3flNnOjIwryB7TnP90MDeqzoUi2qVV+gaCLzzFPxMvtia7ZCd0bAvBxAE3UPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6yIAjhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6yIAjhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34BAC4CEE3;
	Tue, 17 Jun 2025 16:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177941;
	bh=Fv7XeuZPUQjdnW6PsBvTXU5z7CztmHrhaGyV1FHg71U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6yIAjhTn8JiHvxv3/Z3Bg/ytebViJccOTfHAb1BGsgbDvjSktkWQQ41xEsF7XVAy
	 hSBZ73OqqX+J3xY43FWCnXuEXqya5ylG9goSEpOcKstGWl4I3tkx8kbn2IqGdJUgOU
	 SPum4wVPOr3ZJJzmSSs0r9ake8Nj3KyIahxZWdRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 386/780] arm64: dts: rockchip: Update eMMC for NanoPi R5 series
Date: Tue, 17 Jun 2025 17:21:34 +0200
Message-ID: <20250617152507.179783688@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 8eca9e979a1efbcc3d090f6eb3f4da621e7c87e0 ]

Add the 3.3v and 1.8v regulators that are connected to
the eMMC on the R5 series devices, as well as adding the
eMMC data strobe, and enable eMMC HS200 mode as the
Foresee FEMDNN0xxG-A3A55 modules support it.

Fixes: c8ec73b05a95d ("arm64: dts: rockchip: create common dtsi for NanoPi R5 series")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20250506222531.625157-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi
index 00c479aa18711..a28b4af10d13a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi
@@ -486,9 +486,12 @@
 &sdhci {
 	bus-width = <8>;
 	max-frequency = <200000000>;
+	mmc-hs200-1_8v;
 	non-removable;
 	pinctrl-names = "default";
-	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
+	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd &emmc_datastrobe>;
+	vmmc-supply = <&vcc_3v3>;
+	vqmmc-supply = <&vcc_1v8>;
 	status = "okay";
 };
 
-- 
2.39.5



