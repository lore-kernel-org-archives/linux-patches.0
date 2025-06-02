Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43052376FF;
	Mon,  2 Jun 2025 14:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873415; cv=none; b=Tag/fP1tsOYMRoYFiQU3nSvE80b2SCrPCC61eahEeYFCAsVD1yqc+5ap1igeg1R/2l/MEZNJKxD50bXgVcylLkupmuA+Oz9W36pqN2OAwbDFZ1zdG8Y3yJ4Hn6XiBh8OPEGLX2+FQ8O3c+CuZAPOU61tJMQqjt9RiEtC8tdxqPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873415; c=relaxed/simple;
	bh=8aOGPDjkPLPzXbn4Mx6blF143J8I5lpfkGkn6cxM66s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=np3v3LbqA+fJzduHUDFkq+U+NLrVy5vydnw5RYRJEZsURg9gspcMTHOKHlkxwNmtjAxZSYwyl5G19sR/B1u/uXS12A5nRe5hlhScQ2gwWy649YMik5OtzXTQ7K4keYVmxn9JsqO6RF481MewiP/AIOg6gixBMDYIC0bcrFCEFeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxA15OCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxA15OCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07511C4CEEB;
	Mon,  2 Jun 2025 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873414;
	bh=8aOGPDjkPLPzXbn4Mx6blF143J8I5lpfkGkn6cxM66s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxA15OCJNQb5Bn09aoUceJDcYEkzn57T22gidyXCIp8ggsGWsz8+qqX60etwoe2+U
	 bwcAcIGPRebP7bRuvdfbTA1Fbv08a3PD92qjwmyrnbQ8E2eHyMZXxZrsym0YCDailX
	 6oDTxDCOYfENbY+rfhN1VK9tuYFsimbvTndMRyrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/444] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Mon,  2 Jun 2025 15:43:17 +0200
Message-ID: <20250602134346.299060235@linuxfoundation.org>
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
index b4a1108c2dd74..0639f5ce1bd9e 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1635,7 +1635,7 @@ vdd_1v8_dis: regulator-vdd-1v8-dis {
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



