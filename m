Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017127;
	b=L17/1M+UoJJA0veA/+nah8xwDf14ZH5nfsjRR/wMY9G3q4tvKO2/W6g/6KSSP3ULFBi4
	 83UXciX1QiRv8NynhgI4/8ZXAiFrv+7eqRFBbYkWXeaRfFzFNKSnVfr4LR5GAbKDuAgPP
	 fXD/EtLVSBkKret9y1d51EJNncPXdgdnT5l+0A6Y4yysebSBydst4KNqX+OZMxdTU8P6I
	 SRW+dEiucQ8pR/tzvrykSn4RTixhf1G2nt5AxZTTx1jj1GO8M8/gdtyQkxLZFpgorKpDL
	 fVWVskDZ+f9SWNJG5cbnZVg6LIEKEDpIKA/GQuCxAGcA5N1VYW3M9xJ1DiLprBDdLgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGnsvHhHtkh5srTKFsr95lvBRG+uyxk4eLwGKBVaiYg=;
	b=bWYg/kcYvAF85FNF/Q0tNKdyZ++J4jnm1xxIYcOKtzo9Dh4ptfQx6LTjEcwwgL2tkWd3
	 REvmonpUUnlgBz4pBMPtDZjdVbTViKlZpE8XT17gLOefMLUZ9hhJh2MUS4UCYBrFxnsfN
	 r+M6smcCDnmfEbCdEczZJSydwSR7ufUxR+BCOu66ya8vnAVU+rgWS2k7Ggzga+vEuNmqw
	 Z9V3aV6zbxfE//E4Crr/2xQD8D0BpRUwArws3K5f4ibtH3PVTn70uUhTIueKnXd2c0Wm/
	 QQXcA6dSA29Jh1YnI8NmzAzWwwRhdi//AuRMFDgrLf4oCuAxlWhyhV8CPQqUCbMns8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEfGXqUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A68606A331;
	Wed, 18 Nov 2026 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEfGXqUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465AA1F000C4;
	Wed, 18 Nov 2026 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017126;
	bh=tGnsvHhHtkh5srTKFsr95lvBRG+uyxk4eLwGKBVaiYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEfGXqUKVAiJNGbm8lWc3AjuFJ+Md6+mJwJJZnEx0d6cJ8DXaHrFK9SlsdZtxQ5a7
	 yJR6ZVg8IwwQskj/hv9wvz9dp4rcNjSxlkN+6irSBaxHgHc2/4NezeUCaIBH+Vb0Xm
	 E5gibpozzlN12iiOCXWO/MmYuB/go8zqy/iJlVV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0772/2651] mfd: cs42l43: Move cancel_work_sync() into remove
Date: Wed, 18 Nov 2026 15:33:32 +0100
Message-ID: <20261118150315.681614173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 86bcfdc6f1e1f8943fbe12256b3c89a66ebbad03 ]

The cs42l43 driver kicks off a work item waiting for the device
to appear on the SoundWire bus, once the device appears the
MFD children are added and the clean up is then done through
devres. As the work is synchronised in from the devres clean
up this could lead to new devres items being added after the
clean up has started, if the driver is removed before the work
has fully completed. The work should be synchronised before any
devres clean up is started.

Fixes: 0f35dc4bd50d ("mfd: cs42l43: Use devres for remove as well")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260904131243.755201-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43-i2c.c |  8 ++++++++
 drivers/mfd/cs42l43-sdw.c |  8 ++++++++
 drivers/mfd/cs42l43.c     | 12 ++++++++----
 drivers/mfd/cs42l43.h     |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cs42l43-i2c.c b/drivers/mfd/cs42l43-i2c.c
index cbe05c3ea9100..36c5b03bae693 100644
--- a/drivers/mfd/cs42l43-i2c.c
+++ b/drivers/mfd/cs42l43-i2c.c
@@ -54,6 +54,13 @@ static int cs42l43_i2c_probe(struct i2c_client *i2c)
 	return cs42l43_dev_probe(cs42l43);
 }
 
+static void cs42l43_i2c_remove(struct i2c_client *i2c)
+{
+	struct cs42l43 *cs42l43 = dev_get_drvdata(&i2c->dev);
+
+	cs42l43_dev_remove(cs42l43);
+}
+
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id cs42l43_of_match[] = {
 	{ .compatible = "cirrus,cs42l43", .data = (void *)CS42L43_DEVID_VAL },
@@ -81,6 +88,7 @@ static struct i2c_driver cs42l43_i2c_driver = {
 	},
 
 	.probe		= cs42l43_i2c_probe,
+	.remove		= cs42l43_i2c_remove,
 };
 module_i2c_driver(cs42l43_i2c_driver);
 
diff --git a/drivers/mfd/cs42l43-sdw.c b/drivers/mfd/cs42l43-sdw.c
index 0a6999453f325..afed34d23af80 100644
--- a/drivers/mfd/cs42l43-sdw.c
+++ b/drivers/mfd/cs42l43-sdw.c
@@ -180,6 +180,13 @@ static int cs42l43_sdw_probe(struct sdw_slave *sdw, const struct sdw_device_id *
 	return cs42l43_dev_probe(cs42l43);
 }
 
+static void cs42l43_sdw_remove(struct sdw_slave *sdw)
+{
+	struct cs42l43 *cs42l43 = dev_get_drvdata(&sdw->dev);
+
+	cs42l43_dev_remove(cs42l43);
+}
+
 static const struct sdw_device_id cs42l43_sdw_id[] = {
 	SDW_SLAVE_ENTRY(0x01FA, 0x4243, (void *)CS42L43_DEVID_VAL),
 	SDW_SLAVE_ENTRY(0x01FA, 0x2A3B, (void *)CS42L43B_DEVID_VAL),
@@ -194,6 +201,7 @@ static struct sdw_driver cs42l43_sdw_driver = {
 	},
 
 	.probe		= cs42l43_sdw_probe,
+	.remove		= cs42l43_sdw_remove,
 	.id_table	= cs42l43_sdw_id,
 	.ops		= &cs42l43_sdw_ops,
 };
diff --git a/drivers/mfd/cs42l43.c b/drivers/mfd/cs42l43.c
index 4212ebcca60b5..3d26c33fee1d3 100644
--- a/drivers/mfd/cs42l43.c
+++ b/drivers/mfd/cs42l43.c
@@ -1099,15 +1099,19 @@ static int cs42l43_power_down(struct cs42l43 *cs42l43)
 	return 0;
 }
 
-static void cs42l43_dev_remove(void *data)
+static void cs42l43_dev_power_down(void *data)
 {
 	struct cs42l43 *cs42l43 = data;
 
-	cancel_work_sync(&cs42l43->boot_work);
-
 	cs42l43_power_down(cs42l43);
 }
 
+void cs42l43_dev_remove(struct cs42l43 *cs42l43)
+{
+	flush_work(&cs42l43->boot_work);
+}
+EXPORT_SYMBOL_NS_GPL(cs42l43_dev_remove, "MFD_CS42L43");
+
 int cs42l43_dev_probe(struct cs42l43 *cs42l43)
 {
 	int i, ret;
@@ -1153,7 +1157,7 @@ int cs42l43_dev_probe(struct cs42l43 *cs42l43)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(cs42l43->dev, cs42l43_dev_remove, cs42l43);
+	ret = devm_add_action_or_reset(cs42l43->dev, cs42l43_dev_power_down, cs42l43);
 	if (ret)
 		return ret;
 
diff --git a/drivers/mfd/cs42l43.h b/drivers/mfd/cs42l43.h
index a0068f6572e2c..862bc6fb68cb7 100644
--- a/drivers/mfd/cs42l43.h
+++ b/drivers/mfd/cs42l43.h
@@ -25,5 +25,6 @@ bool cs42l43_precious_register(struct device *dev, unsigned int reg);
 bool cs42l43_volatile_register(struct device *dev, unsigned int reg);
 
 int cs42l43_dev_probe(struct cs42l43 *cs42l43);
+void cs42l43_dev_remove(struct cs42l43 *cs42l43);
 
 #endif /* CS42L43_CORE_INT_H */
-- 
2.53.0



