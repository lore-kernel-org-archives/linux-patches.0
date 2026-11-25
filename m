Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624580;
	b=VoqKU3nJYX3V1VG0n4cWvhTABdTAJ8XeXB7gCXW5wLvQRNXGuWrF+zJz3nuQytdR1+MM
	 bBqEl5PoQBL4HCLxO1ekcGmufU9gSgOKRpeWU118fuo1UWJBElZLbYB4N6NLB0V5OX6Lo
	 Zi+8eTnvuZlOFMzKeDSS4w2ETF4VcR8XzG2oU9m08gKyxiaf/GldFGWh3gNdFkRsEjrBI
	 nQnaeC7ZT5GhHswuR2EbbTEcPoWZ2D/Woj+9E61BsboeH4VSVNdAI7+PIiZWYHfx2TjOk
	 eduYFJGRj881W6g8ZF149n0d5XLGqQTqoEjsq+u4PMAutyKdpitJbCvXhI/RRhBYkmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=17r3VEYXXCn7jTmjZ07L3IoodondJdspPBzL70TZ9mc=;
	b=aQzkJIQu5DH3Rkr7cKVyXPQEsVHYJ8AHAQ84w7m0g4+W2+je/FD3+GF7fRPAtfhlj25h
	 obvyjtjjucy6L3UXAG3EK9H4QWjD1J+1hCvSCiCbE83tt92DVzCxwHb0Vb4+mgfRIzrqN
	 J3YEM6chBOJSZrHRMXJmDK4OOJGAwbyOUpLKtMmNpLWted+3+sKCLkqNl6vcJEE/ubre8
	 QUfiUY8R/JBIFImEvWyKwhSwKchuSBgFOfXAsOvIrpzL35vyxNyjtUiqJ4syzvZE9NoPA
	 Ly8bwavVWe5EDmXnV3WHKJ8KSdoQTfxmBHITYbUkrOkbmRII/F10Z3Pd44hht4ljPWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0ujlWgI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59C606A338;
	Wed, 25 Nov 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0ujlWgI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792C71F000C0;
	Wed, 25 Nov 2026 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624580;
	bh=17r3VEYXXCn7jTmjZ07L3IoodondJdspPBzL70TZ9mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0ujlWgIPEAsTEpUqVLe3w0vm77heMteKpNPIVOyiYjUdorPOf/KDwT3cco8Eh2II
	 e5m1Mvx3A7Uli3lE/1gJS6mB6Q1q0QI+Xnc/DowG5ZCjlC0nQ2XhFJq13PSjYJpb7p
	 bcu7UihNj2LoZ8dfT+MJ9W8a0UPvwVpVb0qq4dPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/816] MIPS: SGI-IP30: fix the defconfig defaults for the Bridge PROM and RTC
Date: Wed, 25 Nov 2026 15:29:48 +0100
Message-ID: <20261125143854.766633034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit c9c0d267002029a5bf97ee50e6b11b4d16808aca ]

The Bridge probe reads its part number from the 1-wire PROM and defers
until the SGI 1-wire master and DS250x slave are present, so without
them there is no PCI bus and no serial console.

The IP30 RTC is a DS1685-family part, but the defconfig, derived from
ip27_defconfig, has the M48T35 driver, so there is no RTC.

Enable the 1-wire drivers and select the DS1685 family.

Also drop four lines that savedefconfig removes, as CRYPTO_CAMELLIA,
CRYPTO_CTS and CRYPTO_HMAC are selected built-in and IPV6_SIT=m is the
default.

Fixes: bb2d63500b5c ("MIPS: config: Add ip30_defconfig")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/configs/ip30_defconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/mips/configs/ip30_defconfig b/arch/mips/configs/ip30_defconfig
index 178d61645ceaf..83f49711437cb 100644
--- a/arch/mips/configs/ip30_defconfig
+++ b/arch/mips/configs/ip30_defconfig
@@ -40,7 +40,6 @@ CONFIG_INET6_AH=m
 CONFIG_INET6_ESP=m
 CONFIG_INET6_IPCOMP=m
 CONFIG_IPV6_MIP6=m
-CONFIG_IPV6_SIT=m
 CONFIG_IPV6_SIT_6RD=y
 CONFIG_IPV6_TUNNEL=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
@@ -130,11 +129,14 @@ CONFIG_SERIAL_8250_IOC3=y
 CONFIG_NOZOMI=m
 CONFIG_HW_RANDOM_TIMERIOMEM=m
 # CONFIG_PTP_1588_CLOCK is not set
+CONFIG_W1=y
+CONFIG_W1_MASTER_SGI=y
+CONFIG_W1_SLAVE_DS250X=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
 CONFIG_SGI_MFD_IOC3=y
 CONFIG_RTC_CLASS=y
-CONFIG_RTC_DRV_M48T35=y
+CONFIG_RTC_DRV_DS1685_FAMILY=y
 CONFIG_UIO=y
 CONFIG_UIO_AEC=m
 CONFIG_UIO_SERCOS3=m
@@ -163,17 +165,14 @@ CONFIG_NFS_FS=y
 CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_BLOWFISH=m
-CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
-CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_VMAC=m
-- 
2.53.0



