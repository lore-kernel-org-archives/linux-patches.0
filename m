Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C5B148315;
	Tue, 25 Jun 2024 09:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308519; cv=none; b=mWXxqiSofNFdTZaVGM/H60zVN1x9ncY3JhGGLRRKuQXGzsSQjuyhfPwwuCf4HIsE5nn8PNR9FpEprTHMt3/a+rvS2oJLDQicBD/WOo7DIBqinOAn/35/Q+1YMD7FPneejtzPJDCNlcr6vMb4YbnMgtY1WJ0JYoCEJv9pLxn0PZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308519; c=relaxed/simple;
	bh=kky5IXcSE4nb6GUTKGUJoCNuBFTxUHUQVJEnawDQb6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r60AbW9cB48UDEyrvYHvlreVnlod7LEshIv/LBtNbf/F8k9ufk1wwlC8xEFJauC3bGIYoLM5QeYf4RZn96n46eqBDHv8k8Afm09IAu+di66t62+QdmnL101HgxjIibg8ubnXAhcURCfkEWlsf4GclQD+IWOAgsMAQy7nQujhh+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1yfyCnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1yfyCnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F549C32781;
	Tue, 25 Jun 2024 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308518;
	bh=kky5IXcSE4nb6GUTKGUJoCNuBFTxUHUQVJEnawDQb6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1yfyCnwYpSKbQzZcPj4/wpQg7VLmmavri/SXXiWnDKStT14dunaCGYwNU4v867X2
	 MaTo2+cI7GdNO5/xKTFW5iQSRhOB/zrjWaQGlnyLzCInj/HAfX0Qaquo5Xe3oxNkk1
	 7tOKyZI+AzxhnDmiZW11bbsDwM7i194w3MC71kpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 148/250] spi: cs42l43: Correct SPI root clock speed
Date: Tue, 25 Jun 2024 11:31:46 +0200
Message-ID: <20240625085553.739284193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4eecb644b8b82f5279a348f6ebe77e3d6e5b1b05 ]

The root clock is actually 49.152MHz not 40MHz, as it is derived from
the primary audio clock, update the driver to match. This error can
cause the actual clock rate to be higher than the requested clock rate
on the SPI bus.

Fixes: ef75e767167a ("spi: cs42l43: Add SPI controller support")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240604131704.3227500-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index aabef9fc84bdf..0d9c948e119af 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -21,7 +21,7 @@
 #include <linux/units.h>
 
 #define CS42L43_FIFO_SIZE		16
-#define CS42L43_SPI_ROOT_HZ		(40 * HZ_PER_MHZ)
+#define CS42L43_SPI_ROOT_HZ		49152000
 #define CS42L43_SPI_MAX_LENGTH		65532
 
 enum cs42l43_spi_cmd {
-- 
2.43.0



