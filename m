Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062E81A83E8;
	Mon,  2 Jun 2025 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876856; cv=none; b=pambKJCD2JVpowsFSTaDWbAcut0vrSDoufI3YhFba4voM+b3GIp1aBB4MrNdDFTtk9VTxB9Vdsm1cjpm+PeSHeJ/kI23297xEHjXhWZceVM48OCsGZDFHGxGiBRjTJek0Qo3ph4dxYHYBqzqxLD1thLf17MBv4QZBWy92MtlJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876856; c=relaxed/simple;
	bh=uU5LZquH70og2H93a0vTf/cRVWF1evZ3HHQJ1DeTTVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcSWaApgXmkJiRVCyxUaD/xLpDWgqdQDVxVDe0VBA3oGyW8PtIzUqumFUZtNCXWcqtcwgVTT5aicD3qPpbh0xVeIBxCYULo8LSoUzjVnUdS04kUJjwcMV1EjDlyd3sCxNmP98E1gG5BzRjOBRSfqIGot3ewgchSUQWTPfUh5Ts4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuTI4oU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuTI4oU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADEAC4CEEB;
	Mon,  2 Jun 2025 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876855;
	bh=uU5LZquH70og2H93a0vTf/cRVWF1evZ3HHQJ1DeTTVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuTI4oU6MBW3lww94ZbQjw+3WEZJy+++1dld2DTCGQreRbfHyF62KS/N9xtZW2CNT
	 +dGIpvHv346eXvOcZ83Ozlwki6zZuNfVXkDr+V/vWuOwVs+sRdrztNUYAUBvXRsOXC
	 a7+0nJJMYw1nfAu2lclDpCxuEYbxOE8KB08tavTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/325] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Mon,  2 Jun 2025 15:46:11 +0200
Message-ID: <20250602134323.647628924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 634373a423ef6..481a88d83a650 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1631,7 +1631,7 @@ vdd_1v8_dis: regulator-vdd-1v8-dis {
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



