Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213320;
	b=elj2xYNv099/stKSnnE0Gyz0MS8/g8lGLaZgqsYAJ3Yxj/yZnspes3bnSlkHn0fB/y3f
	 flr12lLquXIwoGjgkHvw+l1nnozee0JXZNUFbe92U5NuWOebh6tMYLTpnQukgRbEYeK56
	 CRv+DRwbs03lE6KBZruZQ/slot53/CGcFGJblSTlqSLTzqeMKrppFmFjusBptJ7zv4U5j
	 LdCh9fQufvsBuptuMND5SKcNeflSAbOMK8LV2+SUKpo4INHxAsZVi3R1VJ1Xs1nXBYZg1
	 BlGVHAzkKkhZawOpkZIrzP4PmkUBtetfg3+4HdjerKXLYkNv0D4sSq/1PD2O5LYLJ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LiKUp+b0IDgFVPdkYjqLZtNPmK0KJfSnl5Rje7s+tA=;
	b=pquW15r4na3/oHR4wxIhkUMe/aZVAbCe6PwO8Kkme8u/0LhgM2H4JlBk1M8Vmlsgif9l
	 Jtc25cwZujVysaCAlGWkVst5rVBlxgEE1cKUhycNRNLURwHBqKuT1TD4B88Xs4Y1X1reE
	 eOLCNKX3RsPmZG/PANSWvFlBRd1nyp49sYStrzN/ovwHUwyJg7v6pmAAaUnR5Hkd6gbw+
	 sgEIUQ1MnSvalnYfuzpU7BLmB50Gt/eA+ywcqS32CWfTBatmRRZ+Jm9jwn1a2NkblNFQr
	 qLV8fcunN2YfBXQjTsya6CRGKdZe6aQVXZbnAa1KkAeCPUts9TdlJ0VMwUHxBgqRRsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAN8gqra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572A7606A31C;
	Wed, 28 Oct 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAN8gqra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1DC1F01825;
	Wed, 28 Oct 2026 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213320;
	bh=1LiKUp+b0IDgFVPdkYjqLZtNPmK0KJfSnl5Rje7s+tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAN8gqraMzmnHvU91A8w5rxbIiLegYTM2W0Jk3unbzyAahVaTSiF3cSV2LgAxLinC
	 gnVLfSNFubDWnMfQRqA/cYEYUI730/Isvr47mX8VpsZ3HH5o6Tuvzsa+4fMvc1k/bX
	 duou152uBYYrp/+WQ4iYj8YA1Z6226FwXqkHyft4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sebastien Royen <sebastien.royen@armadeus.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0464/1887] net: dsa: microchip: fix KSZ8765 fiber detection
Date: Wed, 28 Oct 2026 17:42:40 +0100
Message-ID: <20261028170509.792796884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastien Royen <sebastien.royen@armadeus.com>

commit fc13ba44da197a186f2f4d77c5b7d73d0f99f053 upstream.

The KSZ8765 is similar to the KSZ8795 but has two fiber ports.

KSZ8_PORT_STATUS_0 is used to detect fiber mode. It is currently
defined as 0x08, which is the Global Control 6 MIB Control register
and has bit 7 defined as Flush Counter.

Set KSZ8_PORT_STATUS_0 to 0x18, which is the Port 1 Status 0 register
where bit 7 is the Fiber Mode bit.

This issue was discovered when upgrading an embedded device from kernel
5.10 to 6.16. The device was using a KSZ8765 device tree configuration
and the corresponding hardware, but during boot the kernel incorrectly
detected it as a KSZ8795. The relevant boot messages were:

  ksz-switch spi0.0: found switch: KSZ8795, rev 0
  ksz-switch spi0.0: Device tree specifies chip KSZ8765 but found KSZ8795, please fix it!

Cc: stable@vger.kernel.org
Fixes: 91a98917a883 ("net: dsa: microchip: move switch chip_id detection to ksz_common")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Sebastien Royen <sebastien.royen@armadeus.com>
Link: https://patch.msgid.link/20261007080557.15719-1-sebastien.royen@armadeus.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -552,7 +552,7 @@ static inline int is_lan937x(struct ksz_
 #define KSZ87_FAMILY_ID			0x87
 #define KSZ88_FAMILY_ID			0x88
 
-#define KSZ8_PORT_STATUS_0		0x08
+#define KSZ8_PORT_STATUS_0		0x18
 #define KSZ8_PORT_FIBER_MODE		BIT(7)
 
 #define SW_CHIP_ID_M			GENMASK(7, 4)


