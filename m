Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170EB4F68AF;
	Wed, 30 Sep 2026 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782712; cv=none; b=CH1Z4SaC0DOTu8vllATwPoBQ57LMgecdBOYBlVfjWafzYs2b9PLgyJmrvTXPZbpQImxp5cSwlOGKqFMC8SB+R20T+jqga9p6NA1FUrLIBacB118H69vPj7yZWjxP4AXjVsYG1JOVAbRyHRKom/5cHvmeDzNYR8qpwk1L/OtAqH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782712; c=relaxed/simple;
	bh=nqmA1KKz3pchGqpVqsREAXYtZBhhUXpZnPtfPLPaVBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdE5imLd078nNtQRzJ/MDDpP+FsYXmaKNqHjrtmILIhrKGr3eCMQ3iM+5ZGmbqBHxRJ7WL+UqnpULFxIIUmss6eCCe7QUBohLSUYwHVuu65+yxxqFxgqiJLLcME2yfHmpfmEkExv/t6Z11tBeMcg7Vts4EbmZvNSxynJfRdqabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mcz7DA3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mcz7DA3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB84B1F000FF;
	Wed, 30 Sep 2026 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782706;
	bh=g5PYphOt0vyAPy6xJxLcyf25E9fQ3H5SvwcNumf0d2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mcz7DA3FzgknUkmtTlRxfMHccvqXlgyYhd6KI2+5/O76dlx293u6tcjbOdToVjPri
	 VXxHL4660HjbcNNngciDsUZmMPU+nFpgq/KudofcXVlLAU/E4RVtbWHqcS1PUXtSGi
	 cBKXawkYtsgyP7bO4KqCs5xmH46KZBse4KHTPTAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/595] hwmon: (adt7462) Add of_match_table to support devicetree
Date: Wed, 30 Sep 2026 17:20:07 +0200
Message-ID: <20260930152350.190517440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



