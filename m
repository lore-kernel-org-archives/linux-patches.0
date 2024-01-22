Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1803FE1;
	Tue, 23 Jan 2024 01:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974632; cv=none; b=qussrBcKLPXOxh79/8ki2IiAAep5qx7IjkQJWZHvYVrN4c8c8SlHmJdCgice/n8ODQu/a3yx3UCKn+N764/Apxso37DOYmEfTVQdT3HFnud1Y4Bt8sXAWj3+ZL+0q3APMkX/NWc1g/bvdUlCrFM0ggeFDtIahWLbY/9F1e9OI/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974632; c=relaxed/simple;
	bh=JCAnIo/GoQDMKtzHxIUcebM+e4IpBVOKACOIIn/ChPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIr7qI2QQ0hDxCfyrMaW511lMy1uMsLlw5UlCSfsLbOckJ8MpcYGUL1bmvCb6rJYd6+EgARzClloaOHe58A58Ccqz8qKNWyjzf/9KFFUTEeHvyIVLoIBf6BK9v5c5RUb5ao+6XehNT0nGaORhD4b1y+wEXAjzvPEpfWzgutyIiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkWYs7YU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkWYs7YU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B381FC433F1;
	Tue, 23 Jan 2024 01:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974632;
	bh=JCAnIo/GoQDMKtzHxIUcebM+e4IpBVOKACOIIn/ChPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkWYs7YUlLYD2uGsTcVtXwKiOrQQP0e0K5wdeqn+F9P2/7v7qeu3A2o+SoSfMzyId
	 X1rakbYBPGp+CDGnGRDzwTrPSWHGvJESsiCcoNKc5TFXfhuscFtNNhBTFF89FKIu1c
	 n+sbalrog1KWNw/XogjNshHpD64N+EdC7wDTntQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Yadav <n-yadav@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/583] arm64: dts: ti: k3-am62a-main: Fix GPIO pin count in DT nodes
Date: Mon, 22 Jan 2024 15:52:28 -0800
Message-ID: <20240122235815.155335786@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nitin Yadav <n-yadav@ti.com>

[ Upstream commit 7dc4af358cc382c5d20bd5b726e53ef0f526eb6d ]

Fix number of gpio pins in main_gpio0 & main_gpio1 DT nodes according
to AM62A7 datasheet[0].

[0] https://www.ti.com/lit/gpn/am62a3 Section: 6.3.10 GPIO (Page No. 52-55)
Fixes: 5fc6b1b62639 ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Signed-off-by: Nitin Yadav <n-yadav@ti.com>
Link: https://lore.kernel.org/r/20231027065930.1187405-1-n-yadav@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
index 3198af08fb9f..de36abb243f1 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -462,7 +462,7 @@ main_gpio0: gpio@600000 {
 			     <193>, <194>, <195>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <87>;
+		ti,ngpio = <92>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 77 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 77 0>;
@@ -480,7 +480,7 @@ main_gpio1: gpio@601000 {
 			     <183>, <184>, <185>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		ti,ngpio = <88>;
+		ti,ngpio = <52>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 78 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 78 0>;
-- 
2.43.0



