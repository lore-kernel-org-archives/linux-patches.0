Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD66A199920;
	Mon, 13 Oct 2025 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369424; cv=none; b=P0LaixI40/i6qZdCM3EdmYIHBa4ayYnpBFBXqIgeBxyi+m3GtZHdO738dFwT+6aKMtoS+5nDkS/AvcMr5I0eetUU1HkHStC2ziZGeR5solsn4czjh9pD8y76G+Re2Ac2mmxiSeK2D1xuvW4vleub/PgkNNSs5iDy6R8rigNXvCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369424; c=relaxed/simple;
	bh=zFbZM8GIrd10A8XaQLMcJNW302pFauLkqzeNFZVKhP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2PkQa+lN0aMW/7pty5sg5ETt9JKBdJRaq3mAUxaqTDkFQ+R/bZD0Kekyt640PF8gVircZzPfK4RpTsynFRNDmgcm1FHFw1GYEc2N0lVtGHc41T2fztDkv1jRSPahRL0oFOJOKXlWMKwVxpM6NaYs6Yxpg+t4VTsLwvW+GHyGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5B9CpTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5B9CpTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBA6C4CEFE;
	Mon, 13 Oct 2025 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369424;
	bh=zFbZM8GIrd10A8XaQLMcJNW302pFauLkqzeNFZVKhP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5B9CpTTzlCLYC1n/mDtMlp+fOdGVcAxy1Tfk9XpRJMIQ0qY+ut+2ZktKKcio2znI
	 kNV02lzvgYwzyW81ccOvbJ0tKjczZtscNW/aAVCHC4xeJbz9FrvhmSAZ3ILYb+8wIB
	 iNNjBHF6zxWOMUzcNw4gMXAbuJHGBmuITuv5+Vrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 242/563] hwrng: nomadik - add ARM_AMBA dependency
Date: Mon, 13 Oct 2025 16:41:43 +0200
Message-ID: <20251013144420.052878507@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c858278434475..7826fd7c4603f 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -312,6 +312,7 @@ config HW_RANDOM_INGENIC_TRNG
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK || COMPILE_TEST
+	depends on ARM_AMBA
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.51.0



