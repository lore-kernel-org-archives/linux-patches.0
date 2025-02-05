Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B41519BE;
	Wed,  5 Feb 2025 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765275; cv=none; b=nUYxCiO6wHP/vVl3r3nEdX51uSquq8KYZ+CUWs0+QjWMLuGzvjjQydZ/X8ywk6WvzR7NwZwRFsk0XxWOK9JrliSCyjKP1PT2A7HsaktRcOuJkffnes42aHIfjPJUSDTsRuLfpzVKjj/O+VbMdML9PZr0oDLlhT3z+wL4ay90lvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765275; c=relaxed/simple;
	bh=a/pXn9UsVwUjdjfjX4TSk0G77Wm3Z5Pjuvn42nhodLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TggP31E9t4Wr0Mjf3PRLIZeCPxBVYUbnNgHcMAzNfzA2Aiop78diuKXATlmVEP2PkT9V1Z7xrjTwi9s0t6rlYRTLh77TGCIt4J/QvAuaPA8ohlqt8OmfYZin9wBvuPmf7OJ3AsogYi+kbNf9IgzxADT0i9yWXSdHwt4pDocj/ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQt1ZVKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQt1ZVKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C699C4CED1;
	Wed,  5 Feb 2025 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765275;
	bh=a/pXn9UsVwUjdjfjX4TSk0G77Wm3Z5Pjuvn42nhodLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQt1ZVKYB0ZI8ghYnK5bRl7uGu627TDYcMnxmT9Y6NzJk2qnHKaDakjN0kbpuQYU9
	 a0T5HJPNvKR/2WXzJvoW4/8yRzhLIdwzq3mH6YUd6DQZECPLjFOCpNqCRKLoTbC2C9
	 qOkPSmTTAx3jgX5hjJDD2Mk2sTiMwQwXQcrW0W/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/393] ARM: dts: microchip: sama5d27_wlsom1_ek: Remove mmc-ddr-3_3v property from sdmmc0 node
Date: Wed,  5 Feb 2025 14:42:48 +0100
Message-ID: <20250205134429.834582579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 2a7f1848d9d65a4deb366726ff8f33c9c64ac43b ]

On board the sdmmc0 interface is wired to a SD Card socket.
According with mmc-controller bindings, the mmc-ddr-3_3v property
is used for eMMC devices to enable high-speed DDR mode (3.3V I/O).
Remove the mmc-ddr-3_3v property from sdmmc0 node.

Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Link: https://lore.kernel.org/r/20231204072537.2991-1-mihai.sain@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Stable-dep-of: 4d9e5965df04 ("ARM: dts: microchip: sama5d27_wlsom1_ek: Add no-1-8-v property to sdmmc0 node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts b/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
index e055b9e2fe344..15239834d886e 100644
--- a/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
@@ -197,7 +197,6 @@
 
 &sdmmc0 {
 	bus-width = <4>;
-	mmc-ddr-3_3v;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sdmmc0_default>;
 	status = "okay";
-- 
2.39.5



