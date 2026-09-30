Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F195B51357A;
	Wed, 30 Sep 2026 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787838; cv=none; b=hWMXY7rBxObh5xmGy4yX4vhObT2Mmcw/DLbK0DoqAUMUyhxrXMWUxHuImsXUJaBqee6eoKhpwJHI7baYZJs7LFPtl6/CpNNbVpC+NM1R2CbT8GleKxOf5zcfnUqIwS1/WiAvUIcigPUtcPe6eyMhX7E4JdLApJIn7NcRC8u4iHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787838; c=relaxed/simple;
	bh=ccBWHnekiFy7EHvH0pzPaXgNdq2a6m5OXDytOYrbcHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBLHgcD9t+LoI6aOPk76oMWd/7EgyWnR8CHCA6rOv54L7cEa0S/c7LTbMLq8KauOmc3Tyhqv54VOok3VhvHSMDrql4bWTcKswIqVLlGWsOES8TsvI1O0xFUoKOrijNUOq+Em7SrWFNeS97fe+llmbIFItUez64+fsumL9FTny5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfYreTHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfYreTHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584AD1F000FF;
	Wed, 30 Sep 2026 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787836;
	bh=Pbq6fFtXgya0iqdgP1y9AAM5S6dZsb+nYGR/XMyqK3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfYreTHTh02ho7DvB9PL+tAsPkHT56MPIYq1AacMbpV/zgFyPR2xtKeNlsr2yE300
	 BQ1mRyD8/6fHC/MFO0OzeC2IbsKMZO2TGGps9ocnGAyz9DnQ/N6VB/LDpg2mEZkm+A
	 ssMkPvBBsKsI6z72SxPhJ5YPazrVXeVf+alMxnUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.2 371/457] pinctrl: mpfs-mssio: fix width of unused bank voltage setting
Date: Wed, 30 Sep 2026 17:27:56 +0200
Message-ID: <20260930152354.015000970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit e6c5d6c589764a41218cbd81bd7d6c9b906e2cf0 upstream.

The bank voltages are only 4 bits wide, so when a pin was unused the
driver was not correctly interpreting it as being at zero volts, because
the driver's value for unused had two extra set bits.

CC: stable@vger.kernel.org
Fixes: 488d704ed7b7 ("pinctrl: add polarfire soc mssio pinctrl driver")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
index ea1026a0d22c..dafca82f3e54 100644
--- a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
+++ b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
@@ -86,7 +86,7 @@ static struct mpfs_pinctrl_bank_voltage mpfs_pinctrl_bank_voltages[8] = {
 	{ .uv = 1800000, .val = 4 },
 	{ .uv = 2500000, .val = 6 },
 	{ .uv = 3300000, .val = 8 },
-	{ .uv = 0, .val = 0x3f }, // pin unused
+	{ .uv = 0, .val = 0xf }, // pin unused
 };
 
 static int mpfs_pinctrl_get_drive_strength_ma(u32 drive_strength)
-- 
2.55.0



