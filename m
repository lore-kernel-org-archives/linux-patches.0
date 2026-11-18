Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016790;
	b=ULOnOtDz1VFa1VGF8scrOMDLVnUj0PmHSbHAuy5h5HOnCYhjrrT1B34cQD77pQyTCOCl
	 57ndxkYFt9EKjH2F6Oz4izeroVqkpRd0SZM9KIiplxej8gxnslq1DG8GqdAaQC3qtHZog
	 WNqNLleiOrywhgNkI5ELqNSmpexapDWaOsz5xsHr3oAESkU4sT5PUg3SUwowuIFwMFTJn
	 EKu1ITuU5iUSFHhgrjTrXmEuFkUIWqN9YdY8tOXOVmqRUVk0jJy2P6U9QOQTiQtEo1gMA
	 yHO4dsB9E+78TiN1ORSRHTMjDAWlNpnQGNisCWipP4/ql/N4kSUk3pLoxixDX9GrDRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKlmA0TV9A/Fp2uVQct8MU2esIXQX02fK16eEEGbBlE=;
	b=3LdDnSqc1FOeoncb6tDk6sPOzBMXeGDqpjrV1gkdfM8uL1/NZk/moUZHOvuOqxz4xQqV
	 hPTgWzPg3SV/M/TUCwUdUvIE//acvgu8yTbsDAf2IO8eJcHRamKySMvLZqY//rcNMx9Tw
	 k8dJPgrdpm2vN7Cf+yq03Gv+7PJ8jsa8JT0PsiFEvn4HXaaNEQjWBA15L/pjYn42qnTun
	 FBSlM8i27t5taNW2+EUuDEMzdOUPB6AizGK25NCnxUb2gAyFZvSdmzrjF50lG03oNWeku
	 FBGGVnKCHYeYqtOYCZqk1D40T/xYxqd10BvMLzg5/bGwqXtaXhzCUngg6E5+S3SgNBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuqXohpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE4A606A331;
	Wed, 18 Nov 2026 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuqXohpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46711F000C4;
	Wed, 18 Nov 2026 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016790;
	bh=zKlmA0TV9A/Fp2uVQct8MU2esIXQX02fK16eEEGbBlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuqXohpyLqtEcA8FyZ8RuLelpW15lEh8GvvFeSfftplauFveopOX/HbsRbtf532hw
	 ylHX9+kzTIwLXn3LEH32c2CgRxHZUOfNmN7OGRrBahkqFAQD7BKWnuXGvRs+mg4Ke8
	 KvHPv6zvgLTRB757QeKOK9i/TtrffYVzCBOj6eic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Gaylard <ag@ffroot.co.za>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0603/2651] pinctrl: fix PINCTRL_SPPCTL=m
Date: Wed, 18 Nov 2026 15:30:43 +0100
Message-ID: <20261118150309.431480659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Gaylard <ag@ffroot.co.za>

[ Upstream commit 7dcf87d2dbbe8c9c1efb69fe9be728a3dfd51d3d ]

The PINCTRL_SPPCTL option is defined as a tristate in Kconfig, and the
help text suggests that the user can build it as a module by setting to
'm'.

However, it cannot currently be set to 'm', because SOC_SP7021, the only
platform that supports it, is a bool option that uses 'select' on it.
Also, the SP7021 requires this driver to be built in, in order to boot.

Change the tristate to bool and fix the help text.

Tested on linux-next-2026-09-14 on a LTPP3G2 board.

This impossible tristate was detected by kconfirm, a static analysis tool
for Kconfig, by Julian Braha <julianbraha@gmail.com>.

Fixes: aa74c44be19c ("pinctrl: Add driver for Sunplus SP7021")
Signed-off-by: Andrew Gaylard <ag@ffroot.co.za>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/Kconfig | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/sunplus/Kconfig b/drivers/pinctrl/sunplus/Kconfig
index 69f82590f6d24..aa9435d023d84 100644
--- a/drivers/pinctrl/sunplus/Kconfig
+++ b/drivers/pinctrl/sunplus/Kconfig
@@ -4,8 +4,8 @@
 #
 
 config PINCTRL_SPPCTL
-	tristate "Sunplus SP7021 PinMux and GPIO driver"
-	depends on SOC_SP7021
+	bool "Sunplus SP7021 PinMux and GPIO driver"
+	depends on SOC_SP7021 || COMPILE_TEST
 	depends on OF && HAS_IOMEM
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
@@ -16,6 +16,4 @@ config PINCTRL_SPPCTL
 	help
 	  Say Y here to support Sunplus SP7021 pinmux controller.
 	  This driver requires the pinctrl framework.
-	  GPIO is provided by the same driver.
-	  To compile this driver as a module, choose M here.
-	  The module will be called sppinctrl.
+	  This driver also provides GPIO.
-- 
2.53.0



