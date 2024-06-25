Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D14A12EBEA;
	Tue, 25 Jun 2024 09:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308677; cv=none; b=K/3rK26daCdjmO3FQPeHvUNZodde4ifIbKmyq8CAdY6Pt9s7JfLmrMAOigBjCvWep0cg6A8LSfMnB++J+TJKP8RuDJa3HigABHicoEChJGO7Uzqo8kq28jv5ImZpoP3/PbiYfpK5WSu2vtFUqb4YBcDun7N55Br6qsARCqvnP+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308677; c=relaxed/simple;
	bh=lKxtRme9cS4FEzTJ3WuFMrD9ClXf1o0jv4LL2fyZO60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTGFSsVw3idLO4wQM+FC2QFKnbb8uyx6kiIEftEjUgJuC+W5xS8AX25ak5UiEf0fxUIddzHMGTEPis1YMm3Fs3bBnfFXBk9J7lUY8xKKwmyguvDIgsmw+FLXPOLCuXx41z/Lkr6Jz0YYSK4c6IRgdHnspuV2FeAivpF0SpVNQDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiTrq6y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiTrq6y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D866BC32781;
	Tue, 25 Jun 2024 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308677;
	bh=lKxtRme9cS4FEzTJ3WuFMrD9ClXf1o0jv4LL2fyZO60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiTrq6y1gEWNdPw7dsybeCBKEs2g/5aXitZJ/GjGxVtNzrvfoHD+muuonHty3P8VI
	 NElHsqCrsQienHbwVlNHXGPGbTmearV+4mNhxYDlMODFQI+TXYA3eLnZiXKClyw3SE
	 mgMMRVRk1/QmU70r3ouy72nU4mhNBFm6AglS2Ce8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 162/250] arm64: dts: freescale: imx8mp-venice-gw73xx-2x: fix BT shutdown GPIO
Date: Tue, 25 Jun 2024 11:32:00 +0200
Message-ID: <20240625085554.277899997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit e1b4622efbe7ad09c9a902365a993f68c270c453 ]

Fix the invalid BT shutdown GPIO (gpio1_io3 not gpio4_io16)

Fixes: 716ced308234 ("arm64: dts: freescale: Add imx8mp-venice-gw73xx-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
index f5491a608b2f3..3c063f8a9383e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
@@ -183,7 +183,7 @@
 
 	bluetooth {
 		compatible = "brcm,bcm4330-bt";
-		shutdown-gpios = <&gpio4 16 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
 	};
 };
 
-- 
2.43.0



