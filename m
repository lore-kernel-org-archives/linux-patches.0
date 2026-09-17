Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38414E01F8;
	Thu, 17 Sep 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664435; cv=none; b=ftum6s0ZdOo+JSaSI2Odr98diIlRmK93Y2X2cg3YD35sUxiPrUxjivrf8Pf5FB72zWrnCQBeBcccRc8hPI4ICDudC/loxqq0yELAE7vErqDbVtBU2n8sFjHfoB9FLQBE1fLbncyr3wtuJxfA62rYJmzqnKUK8NBsTXFxWSrDcOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664435; c=relaxed/simple;
	bh=ep1LQ1VymIdFKtW67dVLZ6hb3KoDY+EPSfoSdpesBww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAF1iYy3v8ndKMu5zHAx11GTNvDi7tsUmOTp7iYiYsovMYAXd/htPt6HslcwiqzR3BVgsbFGDpTcOliRL56w8m+hELWdR4m3+cKKhRVx26yB18k2aNBe/jP16gcY43tNHNer+oehowOhBhuVWCsaFlppOqL//OB/l0d9XRZvzcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSdNFCwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSdNFCwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AB91F000FF;
	Thu, 17 Sep 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664434;
	bh=ixTrJGXhYJrRfZL/52RrhoQb6DJ/A94wZFd+D08CGWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSdNFCwZqhxgV7Z0Kqqy+SnHLh4w+jzp/PIkObyoDS19t+N3NSXXIMWvfIFxLbUPy
	 2Qs+6IVs8FDdjGEUbMO2GKGIYEPf2XNf8EgA9tf3FfkAMsuFXii9/szM3ayBU7MZQy
	 HEXvh+cgrI+9j+jnh3GCGLWq+oW9aGwcK7ZKTgqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0372/1250] hwmon: (adt7462) Add of_match_table to support devicetree
Date: Thu, 17 Sep 2026 16:02:47 +0100
Message-ID: <20260917151602.139077866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 174dfee47f7a7..f935c3477b364 100644
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
 	.probe		= adt7462_probe,
 	.id_table	= adt7462_id,
-- 
2.53.0



