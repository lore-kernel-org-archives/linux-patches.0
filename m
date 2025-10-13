Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8330C624;
	Mon, 13 Oct 2025 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368269; cv=none; b=u31Ihv944iDB/kDHaNN94XI4+tQ4HzllfJeDqaha5EUwRI5CKGJnCHDRwfZ5n0vpxCT89wy8k6mwNDtrUc8egT0GdKlQAcIPB82HtTteimsMB9qw3bY9eFv9STVqnb4MeHwAN8XKPvDur5dZWVeS0VaEilOw9+dtvG2/x//qv1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368269; c=relaxed/simple;
	bh=B9vZz4EGRXpWvoZSBhaWWynSD/w3yOBx4PymB4UT8rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llk24mSNLXAy1Uwdw2NISnQOiVhDV8UHxZLfeAw5UJD31TZgRdCa6LK09kvhszEbZ6WBrG2AMoQ7mY6d7GfcZeCSiqkEFPXnQGr7efERUzxyBxH/BXKSZftElNrlCIGZTYN26VyWqAYoYeoJy6j7xTUrAktZyfjO1eJvZo9JEx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NP/nZ0CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NP/nZ0CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737DFC4CEE7;
	Mon, 13 Oct 2025 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368268;
	bh=B9vZz4EGRXpWvoZSBhaWWynSD/w3yOBx4PymB4UT8rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NP/nZ0CBTyywDqOSJUkJIEFLMDD7KzhX3UZUlm/F1KpLbgPMEIKxkmE2DY2lv0n82
	 p18zXx11YGB6uIrazQopg2+txtPTOukltzQVq3cbxg/pG6AgST3ZricySG/XpiC/pi
	 bFgdO6s+Z0/hYZ4nF5vmbc/fcjFnpUbXeBilyfLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/262] hwrng: nomadik - add ARM_AMBA dependency
Date: Mon, 13 Oct 2025 16:44:03 +0200
Message-ID: <20251013144329.767915670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit efaa2d815a0e4d1c06750e587100f6f7f4ee5497 ]

Compile-testing this driver is only possible when the AMBA bus driver is
available in the kernel:

x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_remove':
nomadik-rng.c:(.text+0x67): undefined reference to `amba_release_regions'
x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_probe':
nomadik-rng.c:(.text+0xee): undefined reference to `amba_request_regions'
x86_64-linux-ld: nomadik-rng.c:(.text+0x18d): undefined reference to `amba_release_regions'

The was previously implied by the 'depends on ARCH_NOMADIK', but needs to be
specified for the COMPILE_TEST case.

Fixes: d5e93b3374e4 ("hwrng: Kconfig - Add helper dependency on COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index b51d9e243f351..f0dde77f50b42 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -286,6 +286,7 @@ config HW_RANDOM_INGENIC_TRNG
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK || COMPILE_TEST
+	depends on ARM_AMBA
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.51.0



