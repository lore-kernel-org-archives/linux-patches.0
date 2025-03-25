Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE7925D524;
	Tue, 25 Mar 2025 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906258; cv=none; b=nrPySkb3ftYiI3GWdTwyteqei0gG74LTYmke9pjX4JfNRApdNFXIK7UE1XYZyuop3/MfNOaAwa58z1r8gLRI25+ZjHBFVAFK1BF27TMCUPlvEqtsoRhXBrdr/OwJm4CWNcNhmmv90VUIiC9yU3B12agtbRQ3oAyI/yrJsWT0r10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906258; c=relaxed/simple;
	bh=1sI4imO+WRkV5lRje8WkTFcCeMko9hm0zrZhjZ9L+A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8UqoRPpNIOUTIUNF3aERVTsFhr+cRNzvOUuY6UttMMwfQo5za4+6linJ6Lkx7uteuXR3FKaKmOhqgllMasDdXkxwnynezeC2J32eZFlrgXI8L+WQZ1lRDuhApaz6F3UhSXIFdo5hz/W1sppA7MBbyklQ8LgTPkZ4WxeDwkD1hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMEphNu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMEphNu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E04C4CEE4;
	Tue, 25 Mar 2025 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906258;
	bh=1sI4imO+WRkV5lRje8WkTFcCeMko9hm0zrZhjZ9L+A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMEphNu4YQUrunBwXH2wXa6gP55LrvnszomvlAPAt/qR1dB0UgOcTzjt96EHAiiHA
	 QxEWjwk3EvSNQB8Qmd48/XlvJTuOorMp+VUzdlBK5OoR2FmX7d5zUBm3dFeef3x0Iz
	 nFjPF6uiX+celxntyKyYL8eRV8eUwRZ/FFWi05oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Brautaset <tbrautaset@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/116] ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC3200
Date: Tue, 25 Mar 2025 08:21:48 -0400
Message-ID: <20250325122149.760588289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Chester A. Unal <chester.a.unal@arinc9.com>

[ Upstream commit 24d4c56dd68906bf55ff8fc2e2d36760f97dce5f ]

After using the device for a while, Tom reports that he initially described
the switch port labels incorrectly. Apparently, ASUS's own firmware also
describes them incorrectly. Correct them to what is seen on the chassis.

Reported-by: Tom Brautaset <tbrautaset@gmail.com>
Fixes: b116239094d8 ("ARM: dts: BCM5301X: Add DT for ASUS RT-AC3200")
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://lore.kernel.org/r/20250304-for-broadcom-fix-rt-ac3200-switch-ports-v1-1-7e249a19a13e@arinc9.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts b/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
index 53cb0c58f6d05..3da2daee0c849 100644
--- a/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
+++ b/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
@@ -124,19 +124,19 @@ port@0 {
 		};
 
 		port@1 {
-			label = "lan1";
+			label = "lan4";
 		};
 
 		port@2 {
-			label = "lan2";
+			label = "lan3";
 		};
 
 		port@3 {
-			label = "lan3";
+			label = "lan2";
 		};
 
 		port@4 {
-			label = "lan4";
+			label = "lan1";
 		};
 	};
 };
-- 
2.39.5



