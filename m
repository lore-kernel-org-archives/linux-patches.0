Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B92EE5E8;
	Tue, 12 Aug 2025 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023365; cv=none; b=bXNgdbq6C27dBO8wWpwiQ0e9FnwFL6HhvGcNGfQqZ/XRQQlqJabwW8TJlnFdWW7qPLHm9pRCND1oz6eacecVNHhvys7T3EddeiWG643u7yVNSXpkjmnP1I2hVR14EkGj7JwBDQD2XZHSiry0zbBgnn1d2NCZT4YD7887J1zfBw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023365; c=relaxed/simple;
	bh=aKbYBOqJ0u4Ep0RaHFVOj8w7Prkh/WKqhcoHSkfidSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZUsYtyFlQeKIiwUJZk2qUXv+L99Vv0JZVtAnX42sO8on3HEnn2GmLkuk2X3h8tjqQOuMmYik0tkio8j7wjVYTT8dABJYAMvASDhupYxbRJQFcACAeWYu4yipyhgf3SIaDYQdZo/VOnqfTvhHqdXM9NK5jMbR/RxGyJwSoVLuSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJz4wwtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJz4wwtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31156C4CEF0;
	Tue, 12 Aug 2025 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023365;
	bh=aKbYBOqJ0u4Ep0RaHFVOj8w7Prkh/WKqhcoHSkfidSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJz4wwtvkJws+aeuIK7mB3gP+hsiXVJoYwhCazwNmLwmmoEL71gcP06AQOlUOa79Q
	 nTqDKXjfWIhP9oaOwwlEA8xxis9lyGZJhaJTL+XIZy/mOx1C6q7DxLx0Rr9pCuqncW
	 AU5UMZvFyYiBJqwPZnI/4Tb758TZ2WFXgWzk498s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 057/627] ARM: dts: microchip: sama7d65: Add clock name property
Date: Tue, 12 Aug 2025 19:25:52 +0200
Message-ID: <20250812173421.499205805@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit 0029468132ba2e00a3010865038783d9b2e6cc07 ]

Add clock-output-names to the xtal nodes, so the driver can correctly
register the main and slow xtal.

This fixes the issue of the SoC clock driver not being able to find
the main xtal and slow xtal correctly causing a bad clock tree.

Fixes: 261dcfad1b59 ("ARM: dts: microchip: add sama7d65 SoC DT")
Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Link: https://lore.kernel.org/r/3878ae6d0016d46f0c91bd379146d575d5d336aa.1750175453.git.Ryan.Wanner@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sama7d65.dtsi b/arch/arm/boot/dts/microchip/sama7d65.dtsi
index d08d773b1cc5..f96b073a7db5 100644
--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -38,11 +38,13 @@ cpu0: cpu@0 {
 	clocks {
 		main_xtal: clock-mainxtal {
 			compatible = "fixed-clock";
+			clock-output-names = "main_xtal";
 			#clock-cells = <0>;
 		};
 
 		slow_xtal: clock-slowxtal {
 			compatible = "fixed-clock";
+			clock-output-names = "slow_xtal";
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



