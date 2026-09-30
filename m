Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E151993B;
	Wed, 30 Sep 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791081; cv=none; b=Sv8xDLCbJyjx9uTKUNfezMCzQiM92xPmScNlDUeCiHYI1RshSN7f/3FFrjsDGQjMwn0rwqmG6Tf4PcazVbKVIMG3At8qyPMJUzyKS5gZLKV5OgmIBeljtKmGLNLUeDAQ68bobp+HbTL00HD89RAS7NPdFA0ZPkmohKkaR88jdEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791081; c=relaxed/simple;
	bh=c9T7mopZROU457FroXwXzvVAItQksRymBJMoVC3Elhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szZMMacAUJDSug9xlPZ5vQ9kGWePo1LhNa6J0Nl8ONG8ayCLGWi3yUDJ0ZXAo4eWH0QrdeP5tJffT0n3Rq17P8/AfZOhcXJoO8Pq9B6kefMzt/AW8Zi/3w7uRWo69lp+iQse319H/1LBak4d0sscg4kloc+k6jP3UkGeklEqHRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlfk18hO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlfk18hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478931F000FF;
	Wed, 30 Sep 2026 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791079;
	bh=/y+TkALo1J+vsZPuFsQ3xsCfOpYZDUh9QcdeUzyFmoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlfk18hOIF9vtz5B3hGY5bk94vc8dEicKE2w5sKMzCTcORMzCfbu6HD3ogKH23wW6
	 o+4X2VKvlv16Wclx/nM0UxRBxIcRIh3eBkcqynz1iZJN+Qkx92AkS/SQpo0390Kf/p
	 8+of9cF+D5fm+muHF0D2bFHaaEtgz8Tc5TtG826M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/752] hwmon: (adt7462) Add of_match_table to support devicetree
Date: Wed, 30 Sep 2026 17:20:05 +0200
Message-ID: <20260930152401.100765558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e75bbd87ad093..5436c73e8d536 100644
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



