Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EBC58AC4;
	Tue, 14 May 2024 11:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686287; cv=none; b=L7xBoE1mCPZw2H9V+VnXTgw5Nu28tDqcNRgvHjopmTbGb2VmLpSfm38H22V0gFI51gOvmdNLsFqN4I0dH1I6H38wAxFKeAP+qSrnzVW5SHzVkA/ISDqRa16gTb6xZEwF4Hh6IJl1WDYUyKXI2tdlJFOTL2iEWr+l3JwejyWUlMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686287; c=relaxed/simple;
	bh=TPtO9X3FaYYFKXqnsXGx67TuGQluJ3Le2CBd5xh/RwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=se6MDAnTNU4iWFd6XbahWL3KzGZMQZ6jno+kGgE/VW9r21SdZ9UKWw4g154eszd41dYHqT4NTGFSc43ob1PvTN+DE5Sy0f8IY83z1tWRAI0YBdPgnxKQWnTrvuFMVW63nwrwtrA2vV/IuBqMw00yJPCC0QzjiMZ8LndgvaL2Yhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H14a9s3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H14a9s3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D12C2BD10;
	Tue, 14 May 2024 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686286;
	bh=TPtO9X3FaYYFKXqnsXGx67TuGQluJ3Le2CBd5xh/RwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H14a9s3p21esqJqnHgvz3bxqjZbFx5VlkKDph29ZJqEM8Cf0s4qBiiZhq6lWalewk
	 ahKXX3OkaCFaPz0oYQaeSobqtCqHBDE4z4gomGmUUJcMtyWQRmAS4+f/VY3hKBMxOG
	 J1jc2eZydwBXkDYcLgWrl037Imd69zakAFURGroQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Jay Fang <f.fangjian@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/236] spi: hisi-kunpeng: Delete the dump interface of data registers in debugfs
Date: Tue, 14 May 2024 12:16:55 +0200
Message-ID: <20240514101022.360101384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit 7430764f5a85d30314aeef2d5438dff1fb0b1d68 ]

Due to the reading of FIFO during the dump of data registers in
debugfs, if SPI transmission is in progress, it will be affected
and may result in transmission failure. Therefore, the dump
interface of data registers in debugfs is removed.

Fixes: 2b2142f247eb ("spi: hisi-kunpeng: Add debugfs support")
Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Reviewed-by: Jay Fang <f.fangjian@huawei.com>
Link: https://lore.kernel.org/r/20240416015839.3323398-1-liudingyuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 525cc0143a305..54730e93fba45 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -151,8 +151,6 @@ static const struct debugfs_reg32 hisi_spi_regs[] = {
 	HISI_SPI_DBGFS_REG("ENR", HISI_SPI_ENR),
 	HISI_SPI_DBGFS_REG("FIFOC", HISI_SPI_FIFOC),
 	HISI_SPI_DBGFS_REG("IMR", HISI_SPI_IMR),
-	HISI_SPI_DBGFS_REG("DIN", HISI_SPI_DIN),
-	HISI_SPI_DBGFS_REG("DOUT", HISI_SPI_DOUT),
 	HISI_SPI_DBGFS_REG("SR", HISI_SPI_SR),
 	HISI_SPI_DBGFS_REG("RISR", HISI_SPI_RISR),
 	HISI_SPI_DBGFS_REG("ISR", HISI_SPI_ISR),
-- 
2.43.0



