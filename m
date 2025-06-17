Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE5C2ECEB2;
	Tue, 17 Jun 2025 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175211; cv=none; b=JeQebZAcQzRgxbBSDswzBeRfXPsj4JqjRnR+ryioLKbKESuFWrdL3hZWpqhX1mu8Y9/3h7f8x4ht6HLk3RICT2FraddCyoA7TtktZe7jO/NljF/grYZCte1143EW7dpJqodVdmfSG4Js9081b2CByRG37QSPW9wwkWoDG3eB6BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175211; c=relaxed/simple;
	bh=qY7BWNjMcvFzo4w+26uwpN8f6Rb/0x9RvQN65XKF+1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqcbbZ0Z/poyavN0BtU7TXyfbclnLp6Fp4WJHyVNDv45OUh/p22dWb37o0wBT8bTrj/6jOO1sjb6EKDxUlzp64SKLOVe2e7TAywrDygDsTy9a8p7EoHW2IPJp/I8qKXQDDE5MAtDDykJ7CPoBjF1qdqfABVU8jFSdNyGPuht0jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukFVk1bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukFVk1bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EB4C4CEE3;
	Tue, 17 Jun 2025 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175210;
	bh=qY7BWNjMcvFzo4w+26uwpN8f6Rb/0x9RvQN65XKF+1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukFVk1bRv1f5VxElnedVNv75Ts3eP0ys2+R/vZO47RWICs6v9Pwwc2izz9CLbLl1w
	 pKtIGyJSeX9BLzxlrzGB6dVZoBWari2i3Xcj9ywNcZY0JwvCrWBzbtCHk8O0JSONOK
	 OfUqvyWLhLI4eSw5m0U85IHoTOvglNR62ltHWhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 063/780] spi: tegra210-quad: remove redundant error handling code
Date: Tue, 17 Jun 2025 17:16:11 +0200
Message-ID: <20250617152454.067349250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3d9c5fb237825..b2872853d6ed8 100644
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



