Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802C11B29CF;
	Thu,  6 Jun 2024 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683414; cv=none; b=joj/BMS8hSTJamo4oYo2rlvkLcZIVoRi/5B/N9+Iq7+VFKzZW2ZxPf/7vALhAWp1w3XrpwFaFrxdVjwGZHGN0foRb8BaKLAw/BrumKC/Sw+H9GAZuroMf5hFqmqtQ9aUwoRDWG2eFfsm5/S1/5L57ajDmU9lnyWGAv2kIiCdluk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683414; c=relaxed/simple;
	bh=KTK4qN/8k3Eg8etAYmPqdlcXR0TBwTNuGNkS+yrcvJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knY96q+lxaPOAv1LxIjKDJ+rhZ7Zc0XXul/3D0wtXZdTFq2YM4AdIDRESqs+07MO+BhMVF/TFX8DfHwQXCojN9ODQXT1dayjdKd9XmOPuPl3XJbr661QEzz3YYxm4XPPWJkOho09f/rLoZFfpPjrKdP3R6EEq2k20THIkDu3BjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9qWa+wo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9qWa+wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BF0C32781;
	Thu,  6 Jun 2024 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683414;
	bh=KTK4qN/8k3Eg8etAYmPqdlcXR0TBwTNuGNkS+yrcvJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9qWa+woGGhpn3dr2cyrg5ZvdY0GLo6TQfYKG93SpXKv1nAJioS33t8ZbHzG1tYd7
	 OulpE/6oItYzEllNZq4ZNZpv76a1fXWk1KRutYRiIs/nsxqfAZ/5v7DDZrn7s/drWG
	 /7JnhLExGezwe/JeQuTThXVXVsnIS0F6KQHw4UGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/473] arm64: dts: meson: fix S4 power-controller node
Date: Thu,  6 Jun 2024 16:03:46 +0200
Message-ID: <20240606131709.721260833@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit 72907de9051dc2aa7b55c2a020e2872184ac17cd ]

The power-controller module works well by adding its parent
node secure-monitor.

Fixes: 085f7a298a14 ("arm64: dts: add support for S4 power domain controller")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240412-fix-secpwr-s4-v2-1-3802fd936d77@amlogic.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 372a03762d69b..a1c55b047708c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -61,10 +61,15 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
-	pwrc: power-controller {
-		compatible = "amlogic,meson-s4-pwrc";
-		#power-domain-cells = <1>;
-		status = "okay";
+	firmware {
+		sm: secure-monitor {
+			compatible = "amlogic,meson-gxbb-sm";
+
+			pwrc: power-controller {
+				compatible = "amlogic,meson-s4-pwrc";
+				#power-domain-cells = <1>;
+			};
+		};
 	};
 
 	soc {
-- 
2.43.0



