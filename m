Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C8C22A4E1;
	Mon, 23 Jun 2025 22:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716593; cv=none; b=hqmt0Gir6fMnBgctEe1PbkAxQufxc0n+nIJS8uf8MgdmeOvwsKcfk4P7NWJkMEXsc5yRkgy7Vikb9axSruxf3XGPPU3IcL3zmnWwGGS0p9iQ3rn+lEWkRwCr99SKR3+KdxjU4vHxmZMvwuyXE2EKvyqylup8uHUV9ts59ylUoRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716593; c=relaxed/simple;
	bh=i1pYAlS3K6SOmBeIqkYRxO36QI/QFK5AIK8gr1DDQrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca90M1yp8OKasW7swc/Vrx40YW72qsrChwsNGqiSkJzhkIFZKU/r1ht7MwrXK7+vx+9jqZ8K6Ub5U2kFd3m39zNG7Cmqlhb623O0at5xeG0tglbNtorhe9iyW2lSrsE1KcQvwsmEJSNhifVY2G3f5UiFaHoPH3Dla1jLp3PXAFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrdY2av5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrdY2av5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB5C4CEF6;
	Mon, 23 Jun 2025 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716593;
	bh=i1pYAlS3K6SOmBeIqkYRxO36QI/QFK5AIK8gr1DDQrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrdY2av52DfyTBMSYv4dZyVLuIgC85iCuDGYyi28t330kBH2MRkgeY/TZF3Asr4rI
	 FZQF2oB3GweOPuj0ebcLG2eWCPGdcogxWRbAzmtrTkkQ+qwAqVeOZqNUp6UR2OoNB+
	 MsQFJtAo6BOWiKjQv+F1yIsuP88pBpfT+ufnkBrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 6.6 275/290] ARM: dts: am335x-bone-common: Increase MDIO reset deassert time
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130635.195494801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Foster <colin.foster@in-advantage.com>

commit b9bf5612610aa7e38d58fee16f489814db251c01 upstream.

Prior to commit df16c1c51d81 ("net: phy: mdio_device: Reset device only
when necessary") MDIO reset deasserts were performed twice during boot.
Now that the second deassert is no longer performed, device probe
failures happen due to the change in timing with the following error
message:

SMSC LAN8710/LAN8720: probe of 4a101000.mdio:00 failed with error -5

Restore the original effective timing, which resolves the probe
failures.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/20240531183817.2698445-1-colin.foster@in-advantage.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi
@@ -385,7 +385,7 @@
 		/* Support GPIO reset on revision C3 boards */
 		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <300>;
-		reset-deassert-us = <6500>;
+		reset-deassert-us = <13000>;
 	};
 };
 


