Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14342C237E;
	Wed, 28 Jan 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614572; cv=none; b=ZHxBCzIQMRGgz6QvT0MASpGURJZxZqhQ899D7W+Sd2Gy5nmynp6QFWABjE5dl1qXq6uPVWmnnfWpDLwjJExQdZa7shNfuKzUMIjO8SoSMwJ8M0j/KOXTzzpRJwSEA2NkDaMG2l+Fv21COmF1CQ/W4AR00jzRDjHQi79M5gyQgN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614572; c=relaxed/simple;
	bh=g7alKTAAVmtcHuTWucVdiiE3u0o+52yxfuHnRZETOmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8taYiDa0dR205AGVofGVsfTn2/sWJ90CfkSO425siUfShZfYLOeJ3rsGkyhWZDkqyf/bmcT+Cbil62JfvMMNNiR56N/+Y3sRykDYsuLt1G7XFh832t4I3ilH/2QnLbUhEsuLOMgnKyeK2mZO+SSldHcXrSDQdX6dtu1NF6Usvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfkXIFUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfkXIFUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40188C4CEF1;
	Wed, 28 Jan 2026 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614571;
	bh=g7alKTAAVmtcHuTWucVdiiE3u0o+52yxfuHnRZETOmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfkXIFUL+d2E2JAg1LZpP/zh1oovIJr2TgQRLYRW3Pz16S5BtDq0DNcujRyDgh5m4
	 rosNR4Tvgg11bOiRc5zp4CpgwMZDTSDyVAyl3BzwCMGAP0+nlQMAP9GwflecZzTTo8
	 45/DnTt6hwBjbmh+zTjV7dxFyLhqJDjCNRp18B8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Rudraksha Gupta <guptarud@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 145/254] arm64: dts: rockchip: Fix voltage threshold for volume keys for Pinephone Pro
Date: Wed, 28 Jan 2026 16:22:01 +0100
Message-ID: <20260128145350.032329157@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

commit 5497ffe305b2ea31ae62d4a311d7cabfb671f54a upstream.

Previously sometimes pressing the volume-down button would register as
a volume-up button. Match the thresholds as shown in the Pinephone Pro
schematic.

Tests:

~ $ evtest
    // Mashed the volume down ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 0
    // Mashed the volume up ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 0

Fixes: d3150ed53580 ("arm64: dts: rockchip: Add support for volume keys to rk3399-pinephone-pro")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Rudraksha Gupta <guptarud@gmail.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Link: https://patch.msgid.link/20251124-ppp_light_accel_mag_vol-down-v5-4-f9a10a0a50eb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -40,13 +40,13 @@
 		button-up {
 			label = "Volume Up";
 			linux,code = <KEY_VOLUMEUP>;
-			press-threshold-microvolt = <100000>;
+			press-threshold-microvolt = <2000>;
 		};
 
 		button-down {
 			label = "Volume Down";
 			linux,code = <KEY_VOLUMEDOWN>;
-			press-threshold-microvolt = <600000>;
+			press-threshold-microvolt = <300000>;
 		};
 	};
 


