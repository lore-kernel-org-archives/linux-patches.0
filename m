Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B14F19E7F9;
	Mon, 23 Jun 2025 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716982; cv=none; b=qUmEYj8F5cArFeOY00NOjfFgPruI6UxE1PyLas0LNY6hoOEy4f2uhkSHfEHXBsgl7omBdCWhTFZ+Fd29iptqCnlcWpJblNWZTgW4he93imfPlBXVuJBhNPmUAolIIF0NeS5NXay+57cyH49nfZJvvPwyDzrAx2Hp3zUdqwhn+bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716982; c=relaxed/simple;
	bh=KfLzE4qX8FrPPa2p8t13cfYwFP3QvCRb9pnwiOy4eH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmZOR178btMlhA+sUt9SK5ueFJXTBa22guZVIw9uFJS7wW+sTsMfunVs5MOx1dYlWmcu1IwOxaqizNamDOL8pgt6LZSUWO1JIQB4nKIIXignRnGfeB5qCBSdQUb11WZCypqyCvLGBlFCNIZbvr2BWH2Y3WTE+Ni2r3Gx8+tT+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2ue0hzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2ue0hzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5855C4CEEA;
	Mon, 23 Jun 2025 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716982;
	bh=KfLzE4qX8FrPPa2p8t13cfYwFP3QvCRb9pnwiOy4eH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2ue0hzcKlTq+51LSQnw3Rrjr8BiMkQLvY0j1H0K+7+fZ214BVHdYgDUme9gQf6CY
	 L7Pbb5+/8cZtYdtUezFzJbcGcX2Ta8PAHiQIObLmSj1/T3W0mHE5NuUQWl6UhwVgQ2
	 LUesA+saU1dxkWvz3fKdLsK/fZcv/IDpMki2QN94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.15 384/411] ARM: dts: am335x-bone-common: Increase MDIO reset deassert time
Date: Mon, 23 Jun 2025 15:08:48 +0200
Message-ID: <20250623130643.316182228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/am335x-bone-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -384,7 +384,7 @@
 		/* Support GPIO reset on revision C3 boards */
 		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <300>;
-		reset-deassert-us = <6500>;
+		reset-deassert-us = <13000>;
 	};
 };
 


