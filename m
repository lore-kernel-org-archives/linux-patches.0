Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0861EA65;
	Mon,  2 Jun 2025 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876066; cv=none; b=avovQjHOQt81UXzT9mzP4QUNfTnOWiPCp0uKteMpJdxNi2gn9cbavk8CfCS7SwIVyZn350ZTgQtcTQo/HUQmD9zsO0wFni2Cr3uUCcfGxoli6NFrUOcQXtNKu0j/V7YPJ4Z3AjcDXmacZ2sRk+fXBzwPvfwPSV7EYO3sbAIJ+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876066; c=relaxed/simple;
	bh=9qTg1moThmFtldyO8UMqbH9VcTMsDOYFSU6VrAgTEBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdDdYp0dzDziUjAdDz3zxxZd1CmbhctlY5xr71jV05q9IaWU1vU97G4Cpl9EJAZh7D8dBzTM5FKZKS396rdvNoGtcoqEOuwm5/oY6fViGg/FAkED0TaZomvi5Q0KexMwq0Vw14hnuNQCjktRzQ3+Ghhtoml5rgtKAtTCNw0Ojmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPw7YrbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPw7YrbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955F4C4CEEB;
	Mon,  2 Jun 2025 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876066;
	bh=9qTg1moThmFtldyO8UMqbH9VcTMsDOYFSU6VrAgTEBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPw7YrbAdFve3c1wM/Zh/Q/ZxBjuAxQy31S5haNZxokqmtfDaO4ti7SPL5GfrJiDw
	 r9ukvPc1P/dqsc4N/A8lencFtSs/EuSpziffE9bZHJpcxT223qpL+MQ+tswXc1HG+0
	 Ks96UxMBQzvc6FmPEQ11jKdJx+m+dws+KXkDbk5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/207] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134301.138669790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit f34621f31e3be81456c903287f7e4c0609829e29 ]

According to the board schematics the enable pin of this regulator is
connected to gpio line #9 of the first instance of the TCA9539
GPIO expander, so adjust it.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Link: https://lore.kernel.org/r/20250224-diogo-gpio_exp-v1-1-80fb84ac48c6@tecnico.ulisboa.pt
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index d8409c1b43800..4abd8b14b8a5c 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1638,7 +1638,7 @@ vdd_1v8_dis: regulator@7 {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		regulator-always-on;
-		gpio = <&exp1 14 GPIO_ACTIVE_HIGH>;
+		gpio = <&exp1 9 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		vin-supply = <&vdd_1v8>;
 	};
-- 
2.39.5



