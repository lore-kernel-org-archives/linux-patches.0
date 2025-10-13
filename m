Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADA26F2B6;
	Mon, 13 Oct 2025 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367713; cv=none; b=MIV6zrgRHzxfEE4P4P/Ys8cWpXDvKU4BechOcFlJmhlATgZuZN1Pe/9+K6DvS3822za6RE19V6uetKxiWtzlasTLcBkmM2/kOuID9W3/PDphlncIRqHyItHYSrKw3yQjiFAohUZjRrPMlTOFaDAcJ0YWDnKLxprXIEiojf2nsMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367713; c=relaxed/simple;
	bh=H8rXO36gjAXKImzST7gMS5/1QR9m8aeaDY/79KdQNVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtWHLj+IS2cieptRNa6HCxinJTbM1iH8dsiKly+k99Rj55yDySSX6URLRG7HgPYi0jRiTkbTAGb3wS3WEoGrrqDmin+hfB6qYKnPUpz5ULqPn+3w5UP5brAKk+LnabCXtwSVWX/1Ya6IE5VKc9wLwDh8f2HCCUwLpBiFZ5FEz8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0he5A2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0he5A2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26FBC4CEE7;
	Mon, 13 Oct 2025 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367713;
	bh=H8rXO36gjAXKImzST7gMS5/1QR9m8aeaDY/79KdQNVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0he5A2KhohrQkzsPSgobTwTQDz9jYskJYVY00Wogmb7iCJ2KTOFYzwYdgOMG5Nqw
	 PV2Av9k/AgsgyNM/NW1bhBbkgV/h8fakuX0E/RIHBn8cDV/H+zk/oVITks42AabiTe
	 IZ2AbiouY+YFDHGiqzk501r+NjcR/mQeaJ7sEmr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/196] hwrng: nomadik - add ARM_AMBA dependency
Date: Mon, 13 Oct 2025 16:44:24 +0200
Message-ID: <20251013144317.831518127@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8de74dcfa18cf..ece2d794174d4 100644
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



