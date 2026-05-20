Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AFE3546C8;
	Wed, 20 May 2026 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299120; cv=none; b=c+Ks2itV0IbAfs5YNLrsPfYFoKLcqFmzD8NzEzw7uCaGQRneezDQX/xP0r2Z6pBjzZlnumiM0MGA/mHZNPL9yg3yj4KLjqqNEEB8JKPKICIPDxjbOZFLOlk5xiQ3Nqi+EGiXEv0bcFzP33kWj0Hlxbh4rJz0HaBLMOt3sFjGnc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299120; c=relaxed/simple;
	bh=+hNB/xM016X17cYR0quPmDItlwJ9ZCsX/HUNcPa14A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyUfNOnxb6JQ+635iCVn9V8frY7eGNbyqWBEk5x210sSnuPo5QzYaoYaDp/ald/YWCHDSf4PIF3nzryL3XHji8r11ReJAcS40Y/iulqTkqUvdf+LAvWrPFNIcMngytxk5VlB7zjV2EfUKTC0XlDMVkW9O7Ta7dv2K0qpEnr1FiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJxD/czu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJxD/czu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273261F000E9;
	Wed, 20 May 2026 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299119;
	bh=jyuvZEKo21vEAgYebhHYvWRF5vEGxj8CuBdXB40zRnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJxD/czuCnrLbdGf2iB0vC5KOXiDaR66+8Ocs8F1cgUI9tBBevb06nNwNYZ9yddPd
	 EbPLrUTg21S0rRsPAuQBsgW8sl/A/2v8abDeJtBmfS1xkbMNDckF0Q0s/8LvYgV4K3
	 6o+8Fjog2FWDCn3EJlzL2sq2Bcxc2rB4fpWSoCpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Moon <linux.amoon@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 671/957] arm64: dts: amlogic: meson-axg: Add missing cache information to cpu0
Date: Wed, 20 May 2026 18:19:14 +0200
Message-ID: <20260520162149.088807439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 918273be0885362a9a00615b46e03f15f8b55667 ]

Add missing L1 data and instruction cache parameters to the CPU node 0
for the Cortex-A53 caches on the Meson AXG SoC.

Fixes: 3b6ad2a43367 ("arm64: dts: amlogic: Add cache information to the Amlogic AXG SoCS")
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Link: https://patch.msgid.link/20260219103548.18392-1-linux.amoon@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index bbf94a1f92a10..3058b60338dbf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -72,6 +72,12 @@ cpu0: cpu@0 {
 			compatible = "arm,cortex-a53";
 			reg = <0x0 0x0>;
 			enable-method = "psci";
+			d-cache-line-size = <32>;
+			d-cache-size = <0x8000>;
+			d-cache-sets = <32>;
+			i-cache-line-size = <32>;
+			i-cache-size = <0x8000>;
+			i-cache-sets = <32>;
 			next-level-cache = <&l2>;
 			clocks = <&scpi_dvfs 0>;
 			dynamic-power-coefficient = <140>;
-- 
2.53.0



