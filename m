Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016732;
	b=wNq3MLmG2IskKOogIwiJM7lwIb8HwP+ZG6nyvEJ3dSMPXXNfJaUge9sTXS+a3O/AR3bn
	 4Bhie9p9x8JHztb/0yJdVJ+33vhInPbSVLbk4kwwgfK0rn/hPejFzGTmA5jmUqs3nfTri
	 PdMSeX4HuIgV0CBXr9RDKSj5kBQdABQCNoIqPtMm8Oc05XpFV83tAgxZhmvoSZCS6zL5X
	 ANYv0LBuxficwicqQ6ZBpyLQRq5TvTUXBaRfOBihobyLLdeEetunUyn9/xYv1fgYklFfp
	 Om9YSPh1iy0OMU0L/7fvtYRst2c1UVM7i4a3CIXFPGoLbCyMaI6Q+/sRxaGZuv+g/DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dpknQKq6WdUIaB9OAUlH/ax7nWQbOVMVub6m6xFEqQ=;
	b=ixPNk+Mw7lrC+JKaqrVmwpBKLuHlUU+NqcFS2+K4W0t52VUPSaZlO2uqtKXpGH0vCrk6
	 Chbi2AE4Sfl6/W/j/1+uPS0vmyJQqSQr9ylYUHWGHQg79FOj/0kz/IQHWYSXJryKdfQfg
	 0yqKoA54wgNEQyeaALL0L2pm71QV4XtgD2bK2toJ3YG4uxcBFzqgCU+4bqIw+RiADL1C2
	 OzosaCopgab9oB56h/BwsQ4w65QbTek/Mymq4b9NeTNhVD9FY2gW7tH1UFIx6lCq+4BuQ
	 Kl+YGlrgZvW73bfegE05wjc1W/9ubt46ztA9MlOj7bBhoMAs+rMx5l8xOpW6VdKi+SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjEwznFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649A5606A32A;
	Wed, 18 Nov 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjEwznFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFF11F000C5;
	Wed, 18 Nov 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016732;
	bh=8dpknQKq6WdUIaB9OAUlH/ax7nWQbOVMVub6m6xFEqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjEwznFmCU3Oe/80OhBqK9mAozrQRZYiJ7lvRfBQLHcBjyfbpHSUQQU7ibPdjD/Nh
	 fde3LofoJAgzUvEjBWtV5nvNbBLTlyunN/27ECpFyHpYoByDDpBHZzPt3Bou1pVpnf
	 TdIdn6lRHwRLJnF1XWGOkMdGw3bslZeLIUgAMuq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0606/2651] arm64: dts: mediatek: mt7988a-bpi-r4pro: label gpio-hogs
Date: Wed, 18 Nov 2026 15:30:46 +0100
Message-ID: <20261118150309.535603414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit bf89276b2db391cbb25d1a0e898280fe85b16fb5 ]

GPIO hogs were tagged with name "?" in recent kernel versions (7.1+) due to
commit d1d564ec4992 ("gpio: move hogs into GPIO core").

7.0 showed the unit-name which behaviour is restored by patch [1], but
labeling the hog directly makes things easier.

gpiochip0: 84 GPIOs, parent: platform/1001f000.pinctrl, pinctrl_moore:
 gpio-0   (                    |tx-disable          ) in  lo
 gpio-1   (                    |mod-def0            ) in  hi IRQ ACTIVE LOW
 gpio-2   (                    |los                 ) in  hi IRQ
 gpio-12  (                    |cd                  ) in  lo IRQ ACTIVE LOW
 gpio-13  (                    |reset               ) in  hi IRQ ACTIVE LOW
 gpio-14  (                    |WPS                 ) in  hi IRQ ACTIVE LOW
 gpio-21  (                    |tx-disable          ) in  lo
 gpio-63  (                    |?                   ) out hi
 gpio-69  (                    |mod-def0            ) in  hi IRQ ACTIVE LOW
 gpio-70  (                    |los                 ) in  hi IRQ
 gpio-79  (                    |?                   ) out lo
 gpio-82  (                    |PHY reset           ) out hi ACTIVE LOW
 gpio-83  (                    |PHY reset           ) out hi ACTIVE LOW

after the change:

root@bpi-r4:~# cat /sys/kernel/debug/gpio
gpiochip0: 84 GPIOs, parent: platform/1001f000.pinctrl, pinctrl_moore:
 gpio-0   (                    |tx-disable          ) in  lo
 gpio-1   (                    |mod-def0            ) in  hi IRQ ACTIVE LOW
 gpio-2   (                    |los                 ) in  hi IRQ
 gpio-12  (                    |cd                  ) in  lo IRQ ACTIVE LOW
 gpio-13  (                    |reset               ) in  hi IRQ ACTIVE LOW
 gpio-14  (                    |WPS                 ) in  hi IRQ ACTIVE LOW
 gpio-21  (                    |tx-disable          ) in  lo
 gpio-63  (                    |pcie3-cn14-hog      ) out hi
 gpio-69  (                    |mod-def0            ) in  hi IRQ ACTIVE LOW
 gpio-70  (                    |los                 ) in  hi IRQ
 gpio-79  (                    |pcie2-cn15-hog      ) out lo
 gpio-82  (                    |PHY reset           ) out hi ACTIVE LOW
 gpio-83  (                    |PHY reset           ) out hi ACTIVE LOW

[1] https://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux.git/commit/?id=d54a489c8c4b627775445d54a6cbd32f209bda8f
"gpiolib: use of_node_name if line-name is missing"

Fixes: d1d564ec4992 ("gpio: move hogs into GPIO core")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso      | 1 +
 .../boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso      | 1 +
 .../boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso      | 1 +
 .../boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso      | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
index 973b76ba0cbfb..e9c322df15fc8 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
@@ -16,5 +16,6 @@ / {
 };
 
 &{/soc/pinctrl@1001f000/pcie-2-hog} {
+	line-name = "pcie2-cn13-hog";
 	output-high;
 };
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso
index 90b2a64459c31..9d8de737ca400 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso
@@ -16,5 +16,6 @@ / {
 };
 
 &{/soc/pinctrl@1001f000/pcie-3-hog} {
+	line-name = "pcie3-cn14-hog";
 	output-high;
 };
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso
index 9750916042deb..57ee7dacdd780 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso
@@ -16,5 +16,6 @@ / {
 };
 
 &{/soc/pinctrl@1001f000/pcie-2-hog} {
+	line-name = "pcie2-cn15-hog";
 	output-low;
 };
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso
index 9830fb0fd97a2..7830980ac95af 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso
@@ -16,5 +16,6 @@ / {
 };
 
 &{/soc/pinctrl@1001f000/pcie-3-hog} {
+	line-name = "pcie3-cn18-hog";
 	output-low;
 };
-- 
2.53.0



