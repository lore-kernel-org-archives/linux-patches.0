Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438861F09AC;
	Fri, 21 Nov 2025 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731253; cv=none; b=tLqlWUnru963rXOfI+hdmO7Mcs+65sY8whHhZib/EXf+FMCJ1BaRBkPEE72X9IEQdiSdJBScNhs/i403UpvtEZfXmMIOBOUwmoRq47bmIdlxn52LQjGDZglZphZrKZpWwSTJLgIwKLSc1iWsUIBuaYfPcYKmRnPmsu5fAXOtDTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731253; c=relaxed/simple;
	bh=9OK1+JIJWDgUtqsaqDoFm9OS3Cb8bV+Cl4w6jZpIp80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvqs/MXqkMa+xu8+7bT3PtAmB65nLRZY9hpzRfkHI7ZW0PonASiwMIbiTjGIZVi5rslpxfPYog0WOO30Mnp2OEKtuheKzMa937TZLMzJ9813pHh7/TevITa0GmbGrYaQz5TDLslc53lop5b6AH8are5MXavK6E9Mri1V0qdij44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neDEMXvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neDEMXvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB0DC4CEF1;
	Fri, 21 Nov 2025 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731253;
	bh=9OK1+JIJWDgUtqsaqDoFm9OS3Cb8bV+Cl4w6jZpIp80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neDEMXvy1gKUtVFUr2y5bhR4MSdmlzALGSggCMnd3S/vfgBK9xH1yko7tuKFSYQB4
	 f6NOTD/FfWXumsHjQjAY1/wG7vSfYD86H2a4P2Nljpda9LIwGXIZ2HVCB1gSq+Vaui
	 ocLpqbutC8sTzyLwRT3XBzm6G+ZIleJkNdo5Inig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 143/247] ARM: dts: BCM53573: Fix address of Luxul XAP-1440s Ethernet PHY
Date: Fri, 21 Nov 2025 14:11:30 +0100
Message-ID: <20251121130159.856847079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3d1c795bdef43363ed1ff71e3f476d86c22e059b ]

Luxul XAP-1440 has BCM54210E PHY at address 25.

Fixes: 44ad82078069 ("ARM: dts: BCM53573: Fix Ethernet info for Luxul devices")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20251002194852.13929-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
index ac44c745bdf8e..a39a021a39107 100644
--- a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
@@ -55,8 +55,8 @@
 	mdio {
 		/delete-node/ switch@1e;
 
-		bcm54210e: ethernet-phy@0 {
-			reg = <0>;
+		bcm54210e: ethernet-phy@25 {
+			reg = <25>;
 		};
 	};
 };
-- 
2.51.0



