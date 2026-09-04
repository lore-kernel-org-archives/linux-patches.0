Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE541DE19;
	Fri,  4 Sep 2026 05:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499464; cv=none; b=cyHLXe2D32spw2ZMJklZlW0Ui/aH9FZmBvYPAeYNUp9i3GLo96xTJzM3Mh5viXmy1xid6bHQX497WX4EBBCeeLFh3mwVMBjXevd690mwq/U1VlOczav3ygjCQSl9Ep2NtB4k4xFFNvgusLdNnsdKKelKxO5F4UNTwYbFYa4TIP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499464; c=relaxed/simple;
	bh=5ofCVgnP2nTT5WLRpxT+lMIxaeo8pVmb079pkrbjhao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqLjDbIT0nOPof9gpzdaxRZNtj9PTDHCqSPizHoG1iUowIm9d5frB4A0BI9rDmtlQfoy+dbcaPiiZnvQ/j3kXZ/5KMzYBIrJyl7QDFZoAUeE8OFWx8fYPK6IKVi/1WI8fPpL5xgGGM+mT9Ug4pHgiBsQd+Leu8uQST/6OfAuOhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+Kdu2dQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+Kdu2dQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C79F1F00A3F;
	Fri,  4 Sep 2026 05:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499462;
	bh=rrWup6CEZhIo6p1ZTrvXbeROytHUSYIrWgBKb22oHEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+Kdu2dQQ4oxv6cWJUUdT/E54xiIRQbXML1eKklJrr7Nud0Feg1QiwSSqnULACg05
	 K4jUhGRrf21ViGHDj6YeBGZkvHnLuo2/AeVPcIe3QLHrzSZNP+sTr9lAK1xh4CSGT4
	 c8/mPGiQD5u9zT9Nux2ANSNWM1LEtX3o41wZ4/+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 7.2 426/713] arm64: dts: rockchip: fix eMMC reset polarity on PP-1516
Date: Fri,  4 Sep 2026 06:56:34 +0200
Message-ID: <20260904045813.376099240@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 2a08921edcab6a462fa6ddb02c91b90b5ac92429 upstream.

According to the Jedec 5.1 specification, the device is held in reset
when RST_n is low, therefore the polarity of the line must be that, as
specified in the Device Tree binding (mmc/mmc-pwrseq-emmc.yaml).

Due to the wrong polarity, eMMC devices with RST_n_FUNCTION[162]
bitfield [1:0] set to 0x1 (the default is 0x0) will be held in reset
forever.

Cc: stable@vger.kernel.org
Fixes: 56198acdbf0d ("arm64: dts: rockchip: add px30-pp1516 base dtsi and board variants")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260612-pp1516-emmc-polarity-v1-1-4816c1c909f7@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
@@ -33,7 +33,7 @@
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	gpio-leds {


