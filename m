Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12833223DC1;
	Mon, 23 Jun 2025 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713972; cv=none; b=MZNi9xrHK3NARW/BEYrMkAAs76D3TYhMwhOrwILNo6QlqQUEnSuz5RjLnwKSSfJY1ZA0APUs6J76olsOMT36ce61DhzUlOtRoytYckb0FMtAEtSKjt69dLE+SGTpBaAG5aoHenG8xQRpcR52xJzW5PUJ/ropBBeIk6TKr1nP5mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713972; c=relaxed/simple;
	bh=aSzwHFfroyYQ8G0rpvJjQiF6NwcW1RGVQvC9qu6NPVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTmWWs9owBzoagSEWVaEY/yDr46o+BY9TJL3aIuAQPC5bBfTsBAroJBBPrx2e6QNloBztGp4YmM5uF/3nYMHc/Vq+2R68ZscqGNiAMNkcmHfQb7gm2QCQLedGrep+MZOHvbYrBJ5czLoTO7VebaL4RwsyQdZezE3lO+laPfTkoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOYHm9cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOYHm9cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D1C4CEEA;
	Mon, 23 Jun 2025 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713971;
	bh=aSzwHFfroyYQ8G0rpvJjQiF6NwcW1RGVQvC9qu6NPVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOYHm9cRHpC60WtjO7Sq0M5rjCqaE2mEDKUTbobnILkpj8mbpQJemXl3l/7QpdVZm
	 YEAAj86AGam9GSEGjzWwKqWp1YSwKJeY4/gbvxhUiEbGJ6fIqZAF0V4lvjfgKFhGab
	 c3sM409pl+0MOZpO7VeFid2eCbYgFqOKHo/M+jog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Kevin Hilman <khilman@baylibre.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.4 211/222] ARM: dts: am335x-bone-common: Increase MDIO reset deassert time
Date: Mon, 23 Jun 2025 15:09:06 +0200
Message-ID: <20250623130618.647164396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,7 +403,7 @@
 		/* Support GPIO reset on revision C3 boards */
 		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <300>;
-		reset-deassert-us = <6500>;
+		reset-deassert-us = <13000>;
 	};
 };
 


