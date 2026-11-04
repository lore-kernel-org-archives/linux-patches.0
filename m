Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831065;
	b=YZTqSDyXakDSrSsPuDBHPi/chGo4/KgZsolcTxtv526WbIacWcjeM95MaRTPfPu6LGrf
	 JAw8jWhz2F2RW6ooV0/8arx7emya6zn3EMDAcWd5uu2zDw/2/QkG9EynW4jim98o6evm1
	 7tgwE0kpqSTaf5skwOT8uoZyBZLtQo79m1dYMqVw5OHeyAq8QMgyVmDGFvSgwPEQkay68
	 xEw1nK3GHhDJ0hbtbZDUEXAmgPz3p9wvMkuw23vSYbUziROZZRgna4XwCcLhhVt5gAvB4
	 gP7GL8mI8wMwDDdCmKBmgoSPFm8mzdjFaDgJWre92M5nUJvekiVyaDmOo4zO9AVlfnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZcxYB7UidKHX/nsqHwupi38Atc5Yk+q2s4fvo88tFI=;
	b=ZIBhF3BVQrHvaYCLeN88tVzk+0GvP+3fFh/J85917JVTO373z3O5ABnKWni5tAVa76vt
	 I797jzeHjxKsKOLNM9VUbgicreZPwp2+NKrCYAPSwlLow/fv5IA5qrxdYPQK5uY/9He3g
	 Hdi/y4HI3ZV8YjND2ucD+74PSf+5r1dX4UfAkMn1zbu93xkIQrqPwduqDdvBASJopytTT
	 nGpWvNdm1BELRtSsZ/w0n0L7rJhRIeNz+6+UdDpKUzDPWvEe77JNspWZEk1c1ZPalG6L9
	 qP8fKNPL0skLBGjLnEaGPhHL3KkRZJZklzczkCAH8Xt16rrrXG3Mpt43YwMfa9JJ2XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXxLKIee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC0A606A338;
	Wed,  4 Nov 2026 22:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXxLKIee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D8C1F000C1;
	Wed,  4 Nov 2026 22:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831065;
	bh=2ZcxYB7UidKHX/nsqHwupi38Atc5Yk+q2s4fvo88tFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXxLKIeeV32DoqwwumuOAEZ7IQQqMEEu/HU40NQUetmc75vHy2WkqIxCGvtuqA/pS
	 SQcobfUYKo5vFvBG1DaqxH94cFvJ2DIUv2meclOAOSb+4b9zkHGofOuDuNzmsougtR
	 1Dvb1QMn2+kLLACG+6uFMy8wbUjEQ24GUKYpde5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Moreton <andy.moreton@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0484/1005] sfc: add X4D PF support
Date: Wed,  4 Nov 2026 16:03:37 -0500
Message-ID: <20261104211057.540527913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Moreton <andy.moreton@amd.com>

[ Upstream commit 24fedc7a569bce181728f0dd616504bef9f1513b ]

X4D is an X4 controller instance as an IP block in an SoC.
It has the same feature set as X4.

Signed-off-by: Andy Moreton <andy.moreton@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260916125641.12238-1-alucerop@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 112e55b98ed3b..62df7b6a26fa5 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -903,6 +903,10 @@ static const struct pci_device_id efx_pci_table[] = {
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x2c03),  /* X4 PF (FF only) */
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x8c03),  /* X4D PF (FF/LL) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0xac03),  /* X4D PF (FF only) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{0}			/* end of list */
 };
 
-- 
2.53.0



