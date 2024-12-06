Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207B413AA5F;
	Fri,  6 Dec 2024 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497348; cv=none; b=QLtgHVW0bjgroVc7XGIrbdPKsfiyuH3g+I/MBAnoNnNW/gH5Q/Ru1O9exz1pVEwRrtwhA+YdZDAc7SfUPi6XMuW3vijtEsqpCxfLHEXVpWxM3M6948kbatC2ar5ueY+HpKbgxFzzRzmaKHaZwUJsFdLDrCa81aNn7kF1MiNgpa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497348; c=relaxed/simple;
	bh=mLdQP5LdtkUSNQ1hlMpDhtcjZEslwEvHqx8dHZOxxCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3uaCGp/jqvXhwU1UtmyRNd0mX8V5QSh8YuAtyJCJfnd7GP/uOIQhmIwKr1utspXIqRy3l/NRaopWYRfn/ZDArpeO7/ztejYu4tlVKcbPpeSw5NmpMdePcZC+9t+D2kHNSUeTb3pB/2R6/x8wgtrzYXafolaaa5y5Riy0YUraEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg0oUBuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg0oUBuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A08C4CED1;
	Fri,  6 Dec 2024 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497348;
	bh=mLdQP5LdtkUSNQ1hlMpDhtcjZEslwEvHqx8dHZOxxCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg0oUBuYuZ+jC4OwgIFlnfvLraCtix7I6TOfb92mk0oTtZbTKDI+ZxRskhEu2NXWe
	 m08B7JUQ2QNIx338kKsIDrLRSkTBpapRslYwPqHHDLNcUVbs8uynxpn2Bgl0og+CAz
	 0K6OzKWWwJ7rWTOyMiFp+xNxp0USWUn4M78KMkVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/676] mfd: da9052-spi: Change read-mask to write-mask
Date: Fri,  6 Dec 2024 15:31:25 +0100
Message-ID: <20241206143703.725137606@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index be5f2b34e18ae..80fc5c0cac2fb 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



