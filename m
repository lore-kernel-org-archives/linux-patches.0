Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA893253358;
	Mon, 23 Jun 2025 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685377; cv=none; b=aNCQ1HNy4oJAgc0VI0QOHZstMplHUWgLSn+ANEMm0fT3s1Tzsm6MnzBBcEGjkTdX0qN2oixaObrAK7M5ls6r4pxIphP4PrgWpF81esC01lVvZOEvL7GhX/pAYIhTKVklrWR3UKiUht/psb0BjEzi79UpG5SYfwjOL//q/nQAOZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685377; c=relaxed/simple;
	bh=7xGhy/HMEWyHqpCGKbthK9+eUuyoFD4yVnwle8Zwis8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko7szTWQ3j+uQkiaAAwiQ1jQ/pqstGCilxjTV1aYkdhTW+fZ4DzguN4jpmIOB4cwbTEi1j1QrDeZT6T8l92qmxSq6DjCeGOfg6TSjWhmVWvRGS6mqCXOlD1/TlPqLmt0cLquqPkwziNytvpypVSzu6UMJoTz/O1Ck2TVcek6BTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAEMDQXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAEMDQXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B554C4CEEA;
	Mon, 23 Jun 2025 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685376;
	bh=7xGhy/HMEWyHqpCGKbthK9+eUuyoFD4yVnwle8Zwis8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAEMDQXOX0JW3ktSiKS4Mml7vzJTFZ/EovQPdVAYz7PjSTUnEE5KOm+ugcOJ5YPIE
	 E+yGmnAVElGF3B0cjIBYqsTZ4cAFsRzysavwmlDhyTGlkMgXdSKoSj6s0hYtOrwi7m
	 fOaspMcyihhpVKIsTbX+Ob3y6T//woTOPgOzKPuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/508] spi: tegra210-quad: remove redundant error handling code
Date: Mon, 23 Jun 2025 15:01:13 +0200
Message-ID: <20250623130645.941409591@linuxfoundation.org>
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

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit 400d9f1a27cc2fceabdb1ed93eaf0b89b6d32ba5 ]

Remove unnecessary error handling code that terminated transfers and
executed delay on errors. This code was redundant as error handling is
already done at a higher level in the SPI core.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20250416110606.2737315-3-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index b84dc830c4333..d09e0b9ac18c4 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1168,10 +1168,6 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 
 exit:
 	msg->status = ret;
-	if (ret < 0) {
-		tegra_qspi_transfer_end(spi);
-		spi_transfer_delay_exec(xfer);
-	}
 
 	return ret;
 }
-- 
2.39.5



