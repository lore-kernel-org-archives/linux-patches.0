Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D84911CBA;
	Tue, 17 Jun 2025 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174307; cv=none; b=GqADifk3DyeXehCiaSR9hlmijh68BskOXOimYWgBRBX5yN7yOU2BGakwmz2kf5TiItvfYENoLVH1goO7eARVjXwTKaQgnenakPj2cByWsobTDpO8wsAXtFNL6Q77pgCUSW36jHOaGMbC0lZ9Yu9xyfbc3YBBbZiBI45P1ozNcfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174307; c=relaxed/simple;
	bh=wcX2hGompf0GJMxpw8bLFptFgygv6viZgCo3t3586Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyUIi8l7WClR7b3SgO3th2Yp7KrkbwMeztq+eBUVoGP0MGck0lyiPKCLXUwd1uY3NdkZ8Y1ZSAvsstiHur9GL9paBYXpIsjrrntRtwZU+3HN+1EcAjthdEX0NkoqePv466FEYZrzyrqptr+wC7xxFviC4MHo2RL5V9mpa+P5vL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE7K5COl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE7K5COl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B636C4CEE3;
	Tue, 17 Jun 2025 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174307;
	bh=wcX2hGompf0GJMxpw8bLFptFgygv6viZgCo3t3586Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE7K5COlh2YEUYuTs194ZjsBfO+85gGuMKDddKYevYi3rS2zc+/vUiwicYvVUVkgq
	 OsPGpUxgn40oUAYBTx2zht2xGF8WJw8EbiDd/PVFJbO3OBzx4F3FDxjcSd9fftcVA0
	 HEooOHPccZHJc41eHKWughWGAIlhzAG93P7z3FAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/356] spi: tegra210-quad: remove redundant error handling code
Date: Tue, 17 Jun 2025 17:22:40 +0200
Message-ID: <20250617152340.051120703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 78b3a021e915e..7a74164cd9548 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1175,10 +1175,6 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 
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



