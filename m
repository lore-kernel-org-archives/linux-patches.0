Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EC9418A44;
	Fri,  4 Sep 2026 05:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499469; cv=none; b=pAjSyf4miQ5eue/ckbYz+U7ESeHWkUTD25LCYR5Z5ubFLN/oiHANaVYmPQsR/4UVqGZjIegKoQEUkiR1KhB//rIX08ZMV1OmadtYiC98XiiMH+6qMZIg8Jt5MWXdNR5JkzKAcA4iy91K2Zs2bngrv9KUJZ/fyuyvbO9/dDNbS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499469; c=relaxed/simple;
	bh=pc7JI/E0qOxV2SGrKWrnvIpe0XUhnXHEPqiZ5gBN208=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixtvMboy0S3wfklyxJb8oXRa0tIYyCzKMuODXU0rDGaHeIpx7tAP8xIDey4kzPnKk8oK6+OB+5Dl1O7TaysVtlKWP4CxYDMN+wdibe6Ghpyb5sh+AzDnqzSfcMydPhDafVGcCp+jqy+3BQEtUCtum4VWNV+/ozZ7UAUPDqO9LdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ydkuwh+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydkuwh+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D974A1F00A3D;
	Fri,  4 Sep 2026 05:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499468;
	bh=bkY1f2UQI8kcvnXUteAl9MA7sO36KlJqquFtRHyJcxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ydkuwh+TonkxybpBGohCzEDeN94aWyfjnzCLXARNCVyLXj+lZVlehEedl7FrcHxKW
	 XY0JNHeyijJMP1/x5ThrpG22OgvPK3PdCGO+9Jz9yvJ26Su+OpQIxBDGqJV2+/HCc7
	 qTHsj+4dkG0uLyK1HdjEiTSmpu26ct9i5ARnjiHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 428/713] arm64: dts: rockchip: fix emmc reset polarity on px30-cobra
Date: Fri,  4 Sep 2026 06:56:36 +0200
Message-ID: <20260904045813.420744682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>

commit 85babf47515e2adf266dcc3be9804e31f752083e upstream.

Technically, the reset signal is active low - it's called RST_n after all.

But it is ignored completely unless RST_n_FUNCTION=1 (byte 162 in extcsd)
is set in the emmc. It is 0 per default.

For emmcs that have RST_n_FUNCTION=1 we failed like this:

	[    3.074480] mmc1: Failed to initialize a non-removable card

With this change they work normally.

Cc: stable@vger.kernel.org
Fixes: bb510ddc9d3e ("arm64: dts: rockchip: add px30-cobra base dtsi and board variants")
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
Tested-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260609081728.30616-2-jakobunt@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-cobra.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
@@ -35,7 +35,7 @@
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	gpio-leds {


