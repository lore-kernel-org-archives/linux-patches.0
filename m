Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD01865ED;
	Fri, 27 Sep 2024 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440095; cv=none; b=CADBWPRdu3ejxaWyY0Z1gTNLaaqCpGD39PECXSV6nlAdQ2Q3hFhk+AKL6+OU0I3hcZkwESBFfIEGQBt9XEfyNEsUAiOTVq5WibCOw9jP1vqFkVYZHt30l4xcYYwLxqa0sHpqo+LrOHsOo9ky95m7QiYvI9NrKakll/jHgtj9s5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440095; c=relaxed/simple;
	bh=ztYn2/xQuJtdOgwRk8IfcifkFQpNgGAm8SE1m3xjru8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSNYdt/9j83cHsLs/DlNXtlmnFhWx8OSM1LUn+GZouGdGXOFgF6D4pTWWkwt1AV2pL2jz/S+NIveXV3tTpBG6KvCzx0FGFm4u2O4eAuD3tOQE62jHNHOdTjLHysH0xQJZkf3RVafbJbBor8RamGs70U/F1FfbjE0OsXUYWy9Knw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQfkRumW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQfkRumW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE462C4CECD;
	Fri, 27 Sep 2024 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440095;
	bh=ztYn2/xQuJtdOgwRk8IfcifkFQpNgGAm8SE1m3xjru8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQfkRumWvAbgKSC2CfcDdPd4AeZs8hqcf1I13OmuIyR5zjb7mUzCZZX7Mev+2nlTV
	 lRqbDkmS+1hUgvzMERrAVcj7e+sRFWrvsY8OvoyqzE5BJM43jBPtrXBUyc8B+irKF0
	 vfs9+tVX38T2ZKH0a9ubdXizgoZXNOQW5xJVfeRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 31/58] spi: spidev: Add an entry for elgin,jg10309-01
Date: Fri, 27 Sep 2024 14:23:33 +0200
Message-ID: <20240927121720.055317252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 5f3eee1eef5d0edd23d8ac0974f56283649a1512 ]

The rv1108-elgin-r1 board has an LCD controlled via SPI in userspace.
The marking on the LCD is JG10309-01.

Add the "elgin,jg10309-01" compatible string.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20240828180057.3167190-2-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5304728c68c20..14bf0fa65befe 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -731,6 +731,7 @@ static int spidev_of_check(struct device *dev)
 static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
+	{ .compatible = "elgin,jg10309-01", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-- 
2.43.0



