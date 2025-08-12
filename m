Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD826FA77;
	Tue, 12 Aug 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025578; cv=none; b=gMApq7R4886WkMI6B5Ev6MAjoWLVOnV/pNxhQ+0nrP/djZ3MAPJnS3E05umEuAF500X2NBH9oY23fdCNLnf8elGDEaBXns/d2H2mFn4ndMcO9BsQz8/wrEzYA+C/W44k2Y1saLAKkzKmzvc4E/iboUfKyA5mtc/2hCBj8hWOkdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025578; c=relaxed/simple;
	bh=+/8B0vS+hyGVzL941cdnjVUGDclMPNY/azhU+XwP6YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2RKnCGdWwMsHyWTeCMGPs1Y7Uef3CsKHefv4kYIlG8mrQzTPUxu8qP3vtgkyi1n/sRTk6STFZNe5dmglaXvCA4nG1FSE6WFj6Dzdbe00/9WzR4+VwoqTcK3EQo2VmKM5TxxwY3794b9Yp9nITB8IfMWFW83i+qvoAgHpLXp/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrgf2xkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrgf2xkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BAC4CEF0;
	Tue, 12 Aug 2025 19:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025578;
	bh=+/8B0vS+hyGVzL941cdnjVUGDclMPNY/azhU+XwP6YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrgf2xkCxjeHl6xKQYt6WS2FCUtc2RG1OUmerjRaafIL4Y7Jcoby2xGhd92hVOQ2J
	 BvVHk632l9tgbUueb2l6p0Q/O6oB8EqK2gOCFPXaat4ulHmQqZTL9dvin1YtNi1R8u
	 9n84q8obcqtVZ4v6esTDNDPr+Re61LaW0kQCPUog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 049/480] ARM: dts: microchip: sama7d65: Add clock name property
Date: Tue, 12 Aug 2025 19:44:17 +0200
Message-ID: <20250812174359.423488227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b6710ccd4c36..7b1dd28a2cfa 100644
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



