Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCAC50EBE2;
	Wed, 30 Sep 2026 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784592; cv=none; b=Q1vHHIrkVUZX3R5jULCSCtAlo004TDlFXQiyfC7iW3am8RB/xzb0nXMSHIdyFVVlsXHOyRbsYOndCRVlJm6sKvgYdV4VaLnJWDOUdan4edx4XPe4+MCpINU/vbCzB5sdlBBBztxEDcL/RMcaeLOopiXhc+xJj67igJZ5sNYyqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784592; c=relaxed/simple;
	bh=3xQl1UZeKu9fXVZ5kDLzmS5XPonrC9VGmi3OOc2zdr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUDF0wLffSXg2CL7Kh/Q3FdM9XJrVqCsi7On4sOoz28SlBHPfPJhilpsGZGpIKcWgzxw2l712sklrcjKCfgTVJbqi8efnseicGDki/zc65lLK9bo8tjg7HjCXGPaA7wMv2fTZHbrkNvgXIYHARJu0u0cmUCdOaOR0041c3Us9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJg8HNTC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJg8HNTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2E31F00898;
	Wed, 30 Sep 2026 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784586;
	bh=sK3mchccD7EM5pV+byuHBYqjWfV23Ei1MuoqEHF30N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJg8HNTCgrmiDuN3pYxuqIyUglZZ/WnnZkZoZxiDyQrxIxF3cVjZwmlJlYweUNI0+
	 wU9Kp0wWNLEAk/dAT2hxCObROrzn/cAA6Y1gZsqgwMHaNS0rWxl2n1IeLthmuBHfsW
	 AHf7Ih/qAtKxr9Z7S9Q3qFRPkyu/rviin4cGrWlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/982] hwmon: (adt7462) Add of_match_table to support devicetree
Date: Wed, 30 Sep 2026 17:15:08 +0200
Message-ID: <20260930152420.509807668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit cd1b42617aafe01810ab7d3b9948d2f5fa9fb8af ]

Add of_match_table to add support of devicetree probing.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
[rgantois: Removed of_match_ptr().]
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/r/20260608-adt7462-bindings-v2-1-272982c40325@bootlin.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7462.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 9c0235849d4b6..f6ec0c1e51b19 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -12,6 +12,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
+#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
@@ -1814,10 +1815,17 @@ static const struct i2c_device_id adt7462_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adt7462_id);
 
+static const struct of_device_id adt7462_of_match[] = {
+	{ .compatible = "onnn,adt7462" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, adt7462_of_match);
+
 static struct i2c_driver adt7462_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "adt7462",
+		.of_match_table = adt7462_of_match,
 	},
 	.probe_new	= adt7462_probe,
 	.id_table	= adt7462_id,
-- 
2.53.0



