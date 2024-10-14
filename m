Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CE81B85D0;
	Mon, 14 Oct 2024 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917751; cv=none; b=KL8OyUUCw7nDSu1V5wVhC00UOks5rQA3tMnIGS1UjVW+OIFOZgYLN+KJTsBIULdV3nYSiHi6ZRxgyg1WDBXrFHrGuwLnF7Yuv6oMdPkqme8EQeDgS1HUfMUqjBQ3hdzgsigmnJghodaXu86Nfa45vRC36iDixSDCylsPcZGzFW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917751; c=relaxed/simple;
	bh=fagB4CejQRnC0SNGFRS3DR+YUCj5ooQQbGM6Z2WZsAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utFlR9xIF+81BQJzVVOZ4VPa9k8s3LaIxnd9+d/3EEUDn1hdhSH+nTEKTETVyGTJFsaDMVVfGuaNhv1XmV5wo56VR4Ub9nwyyoXvzrooPOtb3UdmpeZYlb6ahpj3wiAjQLCHflYNNOhWQhbtSUs0xiGiGYKOM/8MUBLUYCSfEZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZOuDkjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZOuDkjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D51C4CEC3;
	Mon, 14 Oct 2024 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917751;
	bh=fagB4CejQRnC0SNGFRS3DR+YUCj5ooQQbGM6Z2WZsAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZOuDkjKufWQJD1JT3Vckag4dokmkM1KMH5ZfkLIjI8KtvSUoyt1uLq/eP9hKbX04
	 UMqgREWNbAmpYbfkhRK1Nkg40qcgmSfMSEE9klHtiDLZh5hn46eUqyoVajiaCUDnNy
	 UQ8BTlfGBeGrRLug0E5f5DJzRxN6Hs/AbRc/vOZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/798] hwmon: (ntc_thermistor) fix module autoloading
Date: Mon, 14 Oct 2024 16:10:46 +0200
Message-ID: <20241014141221.546765363@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 9c9e9f4ccb9e9..4efbacce5d0ca 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -62,6 +62,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_SSG1404001221]   = { "ssg1404_001221",  TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



