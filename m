Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F223A9B8;
	Mon,  2 Jun 2025 14:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873459; cv=none; b=gVP5oqPQoy2lsNruBdrqGu0pUHdB4hVhDmvJnNieXcikgHKvXZxzO5PY6PjKn2mDB7hb6OOrTwHeO/hmQ11py9618vVBYDbMBjaH3KBNvknFB/kd2tS8WXO6MlMsl5zBH3tPEDFl8bCTMt1vdlZBpVwyWT4yGzX7T5mlVnC42w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873459; c=relaxed/simple;
	bh=H2AWnRR5wLD3uR4G3R8exLBvYloSKlmUrA9qleRvJxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXK+/gTmwkfPxb+yJYS4E5F6VUyakPAS59teBbGskY3N4Fs1qIigw6VHOzbUSga7VHGsgPtbQeHoE5VQegLwVRVAmeMj883EI/Hw6wOZvHQV8W371xkaJNlHlunJ/hb0pk0AnpaqWW0oeX5AMaVabAnKx0tM4lXKi9Yj0D3Va+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6g1GLbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6g1GLbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1667FC4CEEE;
	Mon,  2 Jun 2025 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873459;
	bh=H2AWnRR5wLD3uR4G3R8exLBvYloSKlmUrA9qleRvJxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6g1GLbeN+YdadgjnS92eZGqNt65vxpY6l2XgljBju2xtLKNsRoh3cQkzhcCTNKHA
	 A+zX4Ax2lQ+xeVJRy0oKMtK/K10Bve0iV5WwezCFZtq9w4fKd3UlcoeQc7jCAO2S8d
	 0/pGjPcZLHz5dxhKTc7jHB4WcMNJ4VMiqBmghhm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/444] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Mon,  2 Jun 2025 15:43:24 +0200
Message-ID: <20250602134346.580707038@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 2b3db788f2f614b875b257cdb079adadedc060f3 ]

PLLD is usually used as parent clock for internal video devices, like
DSI for example, while PLLD2 is used as parent for HDMI.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://lore.kernel.org/r/20250226105615.61087-3-clamor95@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra114.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra114.dtsi b/arch/arm/boot/dts/nvidia/tegra114.dtsi
index 86f14e2fd29f3..6c057b5069514 100644
--- a/arch/arm/boot/dts/nvidia/tegra114.dtsi
+++ b/arch/arm/boot/dts/nvidia/tegra114.dtsi
@@ -139,7 +139,7 @@ dsib: dsi@54400000 {
 			reg = <0x54400000 0x00040000>;
 			clocks = <&tegra_car TEGRA114_CLK_DSIB>,
 				 <&tegra_car TEGRA114_CLK_DSIBLP>,
-				 <&tegra_car TEGRA114_CLK_PLL_D2_OUT0>;
+				 <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;
 			clock-names = "dsi", "lp", "parent";
 			resets = <&tegra_car 82>;
 			reset-names = "dsi";
-- 
2.39.5



