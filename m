Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F530C61E;
	Mon, 13 Oct 2025 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369139; cv=none; b=IhH/8Rqa3XDmY5FdAAYhOeT9SzF1qnwwaOtmRWfFVkA+qLvnRlj/pzkaX7leyu21njKzjuo64kaSaUP8v+barBYCR2gQNkIVeJ1xuFS74ZajgGvGOL9c/+fu44JlqDQ3Fhw99zipqqmgVQoUIhsuMTHE7pnMXlNOG2Rl50YevLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369139; c=relaxed/simple;
	bh=nxj8jhKE0I8TMrXLE/WdboSD/5z+N/w11Ef/RiWWl/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1KOKXVF/q7otTmxdTHH8y3X40P066WvPP4SSB6cnOBeTdfqxiTD92kr2iSk+XsoSOAYRm7BZnSlaHTTF3pIqAySNVu1e2hnpB17fkatZvuQ+YW//ou8aVHISi84GSe9C2rfVT3USn57m66Uy87GqUcqVjW4F+p9WIkeR4fIS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vAee5Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vAee5Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDBEC4CEFE;
	Mon, 13 Oct 2025 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369138;
	bh=nxj8jhKE0I8TMrXLE/WdboSD/5z+N/w11Ef/RiWWl/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vAee5Lz3SAp+sysZYH2zJV+0Nu6YgFRAs5Y/38U3ZHnk0AecNPAjeDZkOSILtmDT
	 cqmT9kNGeLmSL+MRusyDnfpYxAMamy0zHZpWs6/URz+X33yaJe/vPZRo8Ex9v1ZTor
	 KWP0Du2Fmpude9R/kgOZCrYCH1OZLA6CaUPKZnzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 142/563] arm64: dts: mediatek: mt8186-tentacruel: Fix touchscreen model
Date: Mon, 13 Oct 2025 16:40:03 +0200
Message-ID: <20251013144416.435875365@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 0370911565869384f19b35ea9e71ee7a57b48a33 ]

The touchscreen controller used with the original Krabby design is the
Elan eKTH6918, which is in the same family as eKTH6915, but supporting
a larger screen size with more sense lines.

OTOH, the touchscreen controller that actually shipped on the Tentacruel
devices is the Elan eKTH6A12NAY. A compatible string was added for it
specifically because it has different power sequencing timings.

Fix up the touchscreen nodes for both these. This also includes adding
a previously missing reset line. Also add "no-reset-on-power-off" since
the power is always on, and putting it in reset would consume more
power.

Fixes: 8855d01fb81f ("arm64: dts: mediatek: Add MT8186 Krabby platform based Tentacruel / Tentacool")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20250812090135.3310374-1-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186-corsola-krabby.dtsi   | 8 ++++----
 .../dts/mediatek/mt8186-corsola-tentacruel-sku262144.dts  | 4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186-corsola-krabby.dtsi b/arch/arm64/boot/dts/mediatek/mt8186-corsola-krabby.dtsi
index 7c971198fa956..72a2a2bff0a93 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola-krabby.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola-krabby.dtsi
@@ -71,14 +71,14 @@ &i2c1 {
 	i2c-scl-internal-delay-ns = <10000>;
 
 	touchscreen: touchscreen@10 {
-		compatible = "hid-over-i2c";
+		compatible = "elan,ekth6915";
 		reg = <0x10>;
 		interrupts-extended = <&pio 12 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&touchscreen_pins>;
-		post-power-on-delay-ms = <10>;
-		hid-descr-addr = <0x0001>;
-		vdd-supply = <&pp3300_s3>;
+		reset-gpios = <&pio 60 GPIO_ACTIVE_LOW>;
+		vcc33-supply = <&pp3300_s3>;
+		no-reset-on-power-off;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/mediatek/mt8186-corsola-tentacruel-sku262144.dts b/arch/arm64/boot/dts/mediatek/mt8186-corsola-tentacruel-sku262144.dts
index 26d3451a5e47c..24d9ede63eaa2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola-tentacruel-sku262144.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola-tentacruel-sku262144.dts
@@ -42,3 +42,7 @@ MATRIX_KEY(0x00, 0x04, KEY_VOLUMEUP)
 		CROS_STD_MAIN_KEYMAP
 	>;
 };
+
+&touchscreen {
+	compatible = "elan,ekth6a12nay";
+};
-- 
2.51.0



