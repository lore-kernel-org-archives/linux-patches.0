Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7DD2FE588;
	Tue, 12 Aug 2025 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023369; cv=none; b=p/mkycE/9Nnd7k0CV3B5bS5SdQ7gmGsNZ0H3ZmJwXsSG3KDD17p6Rw9iDfKG4fsh5COKtp1rpYvIDvXpOn3KvzPV50BmOslZn1HMXMF2KnaYutSeG7ffx7Y8Lij85FeqwaCZBIonrXdI7pYkb86/Bt0cSut78+sh0OtSy3O9+f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023369; c=relaxed/simple;
	bh=yuVbMOpHP6N2+Dg6qBSSGNtWXk7YB7QtYu1bH/ScvIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMu5GZhNSZ8R96AVGh2qGgcNqgzuNo6NXSsWJJ4R+bvTDXgeW9lVRLkGneohEm/WIrGkpJP70QHKcTSLL/i0uRC4GKF//UdMe25PN4WppOU76Z8JuTjV3w1aHH4NOjoiIXhiAYnLxFWhk8+GxwASpbhm3So2tLlg4TBbCpC5vjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHO8fmWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHO8fmWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D261C4CEF0;
	Tue, 12 Aug 2025 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023368;
	bh=yuVbMOpHP6N2+Dg6qBSSGNtWXk7YB7QtYu1bH/ScvIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHO8fmWJQif99fQ8ZWR5eXy6Xw5xHhPNFeYU49Hf3orC4tR2T2fe6KG9cpVME25U8
	 zzmZe1Fs6zF5N3yf3H6a3vVMvSLQeq9Jh+y3VfT5pj44s6R3x/QI9AhQb/85cqDsz5
	 citzvKMU9Z6bAWs7iIp8v8G7LITTvppkhcZAY15A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Wanner <Ryan.Wanner@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 058/627] ARM: dts: microchip: sam9x7: Add clock name property
Date: Tue, 12 Aug 2025 19:25:53 +0200
Message-ID: <20250812173421.538124300@linuxfoundation.org>
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

[ Upstream commit 2e24723492b28ffdccb0e3e68725673e299e3823 ]

Add clock-output-names to the xtal nodes, so the driver can correctly
register the main and slow xtal.

This fixes the issue of the SoC clock driver not being able to find
the main xtal and slow xtal correctly causing a bad clock tree.

Fixes: 41af45af8bc3 ("ARM: dts: at91: sam9x7: add device tree for SoC")
Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Link: https://lore.kernel.org/r/036518968ac657b93e315bb550b822b59ae6f17c.1750175453.git.Ryan.Wanner@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/sam9x7.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sam9x7.dtsi b/arch/arm/boot/dts/microchip/sam9x7.dtsi
index b217a908f525..114449e90720 100644
--- a/arch/arm/boot/dts/microchip/sam9x7.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x7.dtsi
@@ -45,11 +45,13 @@ cpu@0 {
 	clocks {
 		slow_xtal: clock-slowxtal {
 			compatible = "fixed-clock";
+			clock-output-names = "slow_xtal";
 			#clock-cells = <0>;
 		};
 
 		main_xtal: clock-mainxtal {
 			compatible = "fixed-clock";
+			clock-output-names = "main_xtal";
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



