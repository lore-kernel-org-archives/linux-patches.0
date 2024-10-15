Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AEA1C07C2;
	Tue, 15 Oct 2024 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997173; cv=none; b=bCeAYTtNBx1k2+4AAjM9u4OeY97un7Y2lsW+QXiXx1sYBIVvLYXpE5P7gAKD2COWfBACr8CvzHq2SBhm7T9f8GDJ1VO9xxOG/o3k+gSX+9nMjefTb2L0arSsNIObPciXIFpCcV2K/w+TZfuLuZPUnDY1DTAApDzZvwsJw1ShKoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997173; c=relaxed/simple;
	bh=BJOz66Eoi42Zp4XL1CVx5v/kSGdDRQRn/C5nJnIc134=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axIQvNINErF5uuTXVTOK2uKjNvDMvBsB7TUxr4nTDnxidYxYt6ohRhHX1tnyWFAsidWz48Ze0mItS4470EY1E8f8/w7yn75W6M+5aIe27eQ09sFMxhQPKeeZdGU6ot3tw6BAIgMSAQ9mP5sgD9lHZzryarKuJUzhZeEEZI4hjT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrN/mViR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrN/mViR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFD9C4CEC6;
	Tue, 15 Oct 2024 12:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997173;
	bh=BJOz66Eoi42Zp4XL1CVx5v/kSGdDRQRn/C5nJnIc134=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrN/mViRdOd77YjexvF36TZSnCY/W34+L0LwXyIhAYzyzok1sxpM6p7HbOkVTpa5b
	 HFRmb3IoQ2qHMzgY+meIqzFzLMTvEWCvh0KGbmNasMVyAagjtJX/konigH2vv/UdjS
	 RmN3mtgvVu+12Df84NXcsARlkQ88JpMXgv/ibwa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/518] hwmon: (ntc_thermistor) fix module autoloading
Date: Tue, 15 Oct 2024 14:40:12 +0200
Message-ID: <20241015123921.168388287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit b6964d66a07a9003868e428a956949e17ab44d7e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Fixes: 9e8269de100d ("hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Message-ID: <20240815083021.756134-1-liuyuntao12@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ntc_thermistor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 3aad62a0e6619..7e20beb8b11f3 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -58,6 +58,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_NCP21WB473]      = { "ncp21wb473",      TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



