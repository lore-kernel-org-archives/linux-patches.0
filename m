Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C822DFF16;
	Tue, 17 Jun 2025 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176604; cv=none; b=ovK73e/1mn94/Trmenbh57/+99HUSF+qSSriW6bcALgy2F2UTv0GoOtuURBQOSkhPd4lBQA2EjZWXxh/AKYCaQCn7bFYwv1pMmZlqKS5S73A80MaVYdZqtBx4t2Qbjksa8SVFseGB9Qij9uxJgv5arFN8sFWUHNXN0SnqWS4LHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176604; c=relaxed/simple;
	bh=9Es4hQ+C0AwTd6EJh3fRM5UhH811Rh2EqtEWLvnP/gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htTqSvJ3ZA8Qh0Y+eQ6WVAaWTdQuqvHKlAQD45VgL6bwMxv8gfmDY2jBYjUOIN8RJ+H3TRSR0vs08SwGLV0uvmHCDiTLb/Nm0LMcwrnk5y7slihmBbk8E21W2yIeUH8SMmr7WWeICV+Dnt/dUJzT3FpfZaZw2oSmOucGdO2hQlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3m2Jhh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3m2Jhh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7CC4CEE3;
	Tue, 17 Jun 2025 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176604;
	bh=9Es4hQ+C0AwTd6EJh3fRM5UhH811Rh2EqtEWLvnP/gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3m2Jhh/ncPu71czO8h0qSSzJD/XVgVJu2QVu4MceBhlqrI74a+X5J4ZVMrmq7FSQ
	 mT/3rY8Phpdkk4bjNoRJHIXS9jKHdcGFZINFhteh2AOLtX5iQWyRHkPL1tA/fjI/Y9
	 Pajr86waqnjs6FfdGFaItgftKAW41Bmbg2IFuoc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/512] arm64: dts: rockchip: Update eMMC for NanoPi R5 series
Date: Tue, 17 Jun 2025 17:23:32 +0200
Message-ID: <20250617152429.576849282@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93189f8306400..c30354268c8f5 100644
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



