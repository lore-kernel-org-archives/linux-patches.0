Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876615CD74;
	Wed,  5 Feb 2025 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766973; cv=none; b=czuD+DKgKL1FN81j/6bA3H4EXQLzVtAYQlJq7GDt0og1nxX2cwj+gwXcc836cbT//XSRoIAw1VUHg6H9658+gnsgY0iac6rBdV8YCmCdwUGwikgDWA7OprgB3pQxTVDp6AFkKsuljjtlsDZ0Ec0v703b3++nZziwSVHPrJjQD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766973; c=relaxed/simple;
	bh=g1VnNn/qaYjRa69Q533HQW2vxegevvVWQJowxex/8Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp0XpMpROAA8dnzPdt9xbVPwBB55W+eGM8D4rkH/QsSanHdtV1VGL+UnSUyL1Q6IMBYTl4fOnIJAy7roXCayFunUmXMs8Mt5nrdYm3k8iTM8HLKVjtEJSrxvOIF2QBiLbh4EUqXRxU5MEpLLSRAz1q7L6CN273nlnPpRXRCtCC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuXBoCGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuXBoCGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C1C4CED1;
	Wed,  5 Feb 2025 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766973;
	bh=g1VnNn/qaYjRa69Q533HQW2vxegevvVWQJowxex/8Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuXBoCGJ6A5J1R9KYy5IzWjz5X8XL4on9Jmjn+WfSY0Y58nyMiRjKI6ix3hpBojpF
	 W8TI9ogzOxS0lO5A0g+F3U1qT6JUJJ1JeansvkhE/RsgbLymbogJc+j084L6mRryXI
	 h/NO81bWQJtc1LiOTM0sDlJaJUVD/BUEOhRDxoEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/590] arm64: dts: marvell: cn9131-cf-solidwan: fix cp1 comphy links
Date: Wed,  5 Feb 2025 14:42:22 +0100
Message-ID: <20250205134510.074268297@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 09cdb973afa7a18ce8e66807daff94609cc4b8a4 ]

Marvell CN913x platforms use common phy framework for configuring and
linking serdes lanes according to their usage.
Each CP (X) features 5 serdes lanes (Y) represented by cpX_comphyY
nodes.

CN9131 SolidWAN uses CP1 serdes lanes 3 and 5 for eth1 and eth2 of CP1
respectively. Devicetree however wrongly links from these ports to the
comphy of CP0.

Replace the wrong links to cp0_comphy with cp1_comphy inside cp1_eth1,
cp1_eth2.

Fixes: 1280840d2030 ("arm64: dts: add description for solidrun cn9131 solidwan board")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
index b1ea7dcaed17d..47234d0858dd2 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
+++ b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
@@ -435,7 +435,7 @@
 	managed = "in-band-status";
 	phy-mode = "sgmii";
 	phy = <&cp1_phy0>;
-	phys = <&cp0_comphy3 1>;
+	phys = <&cp1_comphy3 1>;
 	status = "okay";
 };
 
@@ -444,7 +444,7 @@
 	managed = "in-band-status";
 	phy-mode = "sgmii";
 	phy = <&cp1_phy1>;
-	phys = <&cp0_comphy5 2>;
+	phys = <&cp1_comphy5 2>;
 	status = "okay";
 };
 
-- 
2.39.5



