Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8891EFFA6;
	Mon, 23 Jun 2025 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713494; cv=none; b=p2ShWQLtgnZ1zRr2eeVsyAVpt/G185QDLuWCTUQu5N9cTFnw+sTqn49CRKDDzKlss/FneKh9xixLyRJmMRsiAX4wXWcEthy6koyUK1uh2iizNfOWftPUBTTwOXlsAqNfkQMAdOxb6GT4EBbHXmnZ0AEcL0fRTUnpCJHbXwLw/pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713494; c=relaxed/simple;
	bh=IABz0qtnwpDF15QZfiEiZ6AyiXE0xwpBWnWKGBw/U/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8L+lqrT+puSftUUJYYfqzHkgzY3SV8ZQfvFyCEY34VBwPQYAeNsaHjRH2fYglmhcP8UwdmWYl4Aq+vaqY2lLQHILVnQbWqMbDRaMwjTKnbmnHhHb8f7ZRlZ2C78ZTCGzcNBJhD85G+VZIsl4cmVju/I7jmw1yDrpeJoqEODJuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4XLbQdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4XLbQdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B8C4CEEA;
	Mon, 23 Jun 2025 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713494;
	bh=IABz0qtnwpDF15QZfiEiZ6AyiXE0xwpBWnWKGBw/U/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4XLbQdTQmSFPsR1FTA6gkYwaYRwEF3PjKtprdPrv26vt6w96Uu7fwmHtCA76zgC7
	 OgxD2dkdRYS/nHLdLpOtgKc18EudTetHCT3s9fuL2OlpvfzmaA239Vbgn7KX/HwJYF
	 0Nmc+bo/NjoJSGARL4IndtTb/dn/9vT7PrCQgO/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/508] ARM: aspeed: Dont select SRAM
Date: Mon, 23 Jun 2025 15:02:51 +0200
Message-ID: <20250623130648.395245372@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit e4f59f873c3ffe2a0150e11115a83e2dfb671dbf ]

The ASPEED devices have SRAM, but don't require it for basic function
(or any function; there's no known users of the driver).

Fixes: 8c2ed9bcfbeb ("arm: Add Aspeed machine")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://patch.msgid.link/20250115103942.421429-1-joel@jms.id.au
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-aspeed/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-aspeed/Kconfig b/arch/arm/mach-aspeed/Kconfig
index 080019aa6fcd8..fcf287edd0e5e 100644
--- a/arch/arm/mach-aspeed/Kconfig
+++ b/arch/arm/mach-aspeed/Kconfig
@@ -2,7 +2,6 @@
 menuconfig ARCH_ASPEED
 	bool "Aspeed BMC architectures"
 	depends on (CPU_LITTLE_ENDIAN && ARCH_MULTI_V5) || ARCH_MULTI_V6 || ARCH_MULTI_V7
-	select SRAM
 	select WATCHDOG
 	select ASPEED_WATCHDOG
 	select MFD_SYSCON
-- 
2.39.5



