Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6F732AABE;
	Sat, 28 Feb 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301275; cv=none; b=VULxxCsNg6TfwzI9aKy+gl6rB2CABdxUgi0zQevVtwQVnETbSf17zS9J8meOtk+FGwbotxmBaduNaIRZgwTDn4Zwu/opKAsAtehRHgiWkDfyZggpy3/fYEEGAiTAgdLoQUWTFijpBHr92ZTQhbhFmfoVbjeuBuIZqJ9PCF1Hi/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301275; c=relaxed/simple;
	bh=sOZafZMaT3kqNgOBlTSDIK2K+h1oEj84NBZvSxfy35E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+pD3OqQUPaUCg50sTHm+UFsJpDwxLmEXb9DUr4l8z1wsBHpDcDLGxaUjMXubUI5H4loz62mnsWkZBQUzYrybFn8r8MfugF3oJ7zjH6BP2kw+wn5vC7m200t1RAgPZwKpewGqLZK4fiC1lfy5u7cApw6UJQMcrytqfHCbO7xWDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cY1Ifs8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cY1Ifs8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36421C19423;
	Sat, 28 Feb 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301274;
	bh=sOZafZMaT3kqNgOBlTSDIK2K+h1oEj84NBZvSxfy35E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cY1Ifs8UTz4Bk7CZ8WwX48FFtfuTgEFZbFOjFg3LTE+VwEYlfm+12n69tdM85qkGN
	 2zFWTGUCtSF7+6xl9R12Ev8xjJMFKQOs4Gba7/FSIXP/nq059aZ/Jp7gdQVtDYHgZc
	 IOMlsgNWZwGIbKO8/5kJVYHUbDZPXkZ8nOcnkHSPAjW7fQXVczFMYSj7aKX0ZoE2Ts
	 dWuZj3t0c0o7ZCeiKRFWUU1fcyp6XLiOn2Mk6MZ6aFd33H+VLeCZDQ4LwqXCOLQxDb
	 WeJDIBMOdzKik/ZRHdl6SwCEBoBUu248Gx5oXSHbhPZSfTvb8aIroXHv/7FQUm+3sf
	 0rNtNq6b01mJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Dolcini <francesco.dolcini@toradex.com>,
	stable@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/752] arm64: dts: ti: am62p-verdin: Fix SD regulator startup delay
Date: Sat, 28 Feb 2026 12:42:50 -0500
Message-ID: <20260228174750.1542406-459-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit de86dbc0fb00bd3773db4b05d9f5926f0faa2244 ]

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 87f95ea316ac ("arm64: dts: ti: Add Toradex Verdin AM62P")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20251209084126.33282-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
index 99810047614e3..b7d559c61f3f8 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
@@ -112,7 +112,7 @@ reg_sd1_vmmc: regulator-sdhci1-vmmc {
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reg_sd1_vqmmc: regulator-sdhci1-vqmmc {
-- 
2.51.0

