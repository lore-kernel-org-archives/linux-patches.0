Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214771;
	b=oVmoR5SNd7yDBup6TROb9U2cE6982L2DUol568shMbxWpeB1/bhs8SSHNnpjIEBAMZaY
	 TlWXqVywHBAdcttgKbpCB6bJH3RLlJW+x3502VeKcfpjGaYL5YmKy1sAPR78pjbNX93BL
	 TErhukDbLXCQvbkG8KCXPt29o2ixCeG34yXOlv4j5X81SHEWeZXx7C5ZGYs8ghAxoniRc
	 D2fHgbHutRTLjoEJwxyt1Lfo54+sWprssPQN+BRR0o3GspC1API4NzglCKbmIYw+4tCbV
	 EAFM2GohC9TRVNDwMRzjknjwZ3hE9B8aZf6rhiytCqkrTg8AaP4HjLBSIYz3QufJbvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+RsDvJJ68t9qscwj9TK477nMtoAAz+R0I+ZGFBIAkE=;
	b=QGCxwLKCOd+irylbYnmGysqqMxRRrh2kON/0yltsmO5RWkOnAdCFxzwKNJYhNvh+z7Qf
	 2mIvMt7rvDaXJtD9W6G4ET4+6hzq6xXBHLtSQD0LjCfLDtOmjJnr9LdUfSfIETd1Fjthx
	 P38NjP5INXFREjzXXz84udatZr8UifbBW2eN5baf+TCeCgVTnOUzhXlmNLR7uQNcMQjJG
	 38idMvITF3hFSz6CeoWJj8McUXBQRURRiBfJHr/Kn7QMqQHVR5he62StOQD+i+AWjjgei
	 H6foyZLCjJDDHmS2hjDJQUCqxKrDJTWK63LrQMVGjfB2kzQLdWkSSVdjAEiTPGAyiYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvzl+ymR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BAC606A338;
	Wed, 28 Oct 2026 19:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvzl+ymR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345CC1F01825;
	Wed, 28 Oct 2026 19:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214770;
	bh=8+RsDvJJ68t9qscwj9TK477nMtoAAz+R0I+ZGFBIAkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvzl+ymRVUk/pGX7piyUiV6HjPTEN4o9obgxckkagEsy6xHalRq5N5MyUukcsBEtX
	 LhUGnbaRx+i5xfqpNkF5KANakMBoJTdmvmtaTg7ICLV+yA2MCLdKAyZb9+E+IQD6l6
	 4ZpkCMUDZQ9O46m0nWNIUwt/yz/LN+tpShQ1a2l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0949/1887] hwmon: (pmbus/core) Protect regulator operations with mutex
Date: Wed, 28 Oct 2026 17:50:45 +0100
Message-ID: <20261028170521.002452789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 754bd2b4a084b90b5e7b630e1f423061a9b9b761 ]

The regulator operations pmbus_regulator_get_voltage(),
pmbus_regulator_set_voltage(), and pmbus_regulator_list_voltage()
access PMBus registers and shared data but were not protected by
the update_lock mutex. This could lead to race conditions.

However, adding mutex protection directly to these functions causes
a deadlock because pmbus_regulator_notify() (which calls
regulator_notifier_call_chain()) is often called with the mutex
already held (e.g., from pmbus_fault_handler()). If a regulator
callback then calls one of the now-protected voltage functions,
it will attempt to acquire the same mutex.

Rework pmbus_regulator_notify() to utilize a worker function to
send notifications outside of the mutex protection. Events are
stored as atomics in a per-page bitmask and processed by the worker.

Initialize the worker and its associated data during regulator
registration, and ensure it is cancelled on device removal using
devm_add_action_or_reset().

While at it, remove the unnecessary include of linux/of.h.

Cc: Sanman Pradhan <psanman@juniper.net>
Fixes: ddbb4db4ced1b ("hwmon: (pmbus) Add regulator support")
Reviewed-by: Sanman Pradhan <psanman@juniper.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 60 +++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 11c95fc3305a1..44e4d47372a6f 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -19,7 +19,6 @@
 #include <linux/pmbus.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/of.h>
 #include <linux/thermal.h>
 #include "pmbus.h"
 
@@ -2926,12 +2925,19 @@ static int pmbus_regulator_get_voltage(struct regulator_dev *rdev)
 		.class = PSC_VOLTAGE_OUT,
 		.convert = true,
 	};
+	int ret;
 
+	mutex_lock(&data->update_lock);
 	s.data = _pmbus_read_word_data(client, s.page, 0xff, PMBUS_READ_VOUT);
-	if (s.data < 0)
-		return s.data;
+	if (s.data < 0) {
+		ret = s.data;
+		goto unlock;
+	}
 
-	return (int)pmbus_reg2data(data, &s) * 1000; /* unit is uV */
+	ret = (int)pmbus_reg2data(data, &s) * 1000; /* unit is uV */
+unlock:
+	mutex_unlock(&data->update_lock);
+	return ret;
 }
 
 static int pmbus_regulator_set_voltage(struct regulator_dev *rdev, int min_uv,
@@ -2948,16 +2954,22 @@ static int pmbus_regulator_set_voltage(struct regulator_dev *rdev, int min_uv,
 	};
 	int val = DIV_ROUND_CLOSEST(min_uv, 1000); /* convert to mV */
 	int low, high;
+	int ret;
 
 	*selector = 0;
 
+	mutex_lock(&data->update_lock);
 	low = pmbus_regulator_get_low_margin(client, s.page);
-	if (low < 0)
-		return low;
+	if (low < 0) {
+		ret = low;
+		goto unlock;
+	}
 
 	high = pmbus_regulator_get_high_margin(client, s.page);
-	if (high < 0)
-		return high;
+	if (high < 0) {
+		ret = high;
+		goto unlock;
+	}
 
 	/* Make sure we are within margins */
 	if (low > val)
@@ -2967,7 +2979,10 @@ static int pmbus_regulator_set_voltage(struct regulator_dev *rdev, int min_uv,
 
 	val = pmbus_data2reg(data, &s, val);
 
-	return _pmbus_write_word_data(client, s.page, PMBUS_VOUT_COMMAND, (u16)val);
+	ret = _pmbus_write_word_data(client, s.page, PMBUS_VOUT_COMMAND, (u16)val);
+unlock:
+	mutex_unlock(&data->update_lock);
+	return ret;
 }
 
 static int pmbus_regulator_list_voltage(struct regulator_dev *rdev,
@@ -2975,7 +2990,9 @@ static int pmbus_regulator_list_voltage(struct regulator_dev *rdev,
 {
 	struct device *dev = rdev_get_dev(rdev);
 	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
 	int val, low, high;
+	int ret;
 
 	if (selector >= rdev->desc->n_voltages ||
 	    selector < rdev->desc->linear_min_sel)
@@ -2985,18 +3002,29 @@ static int pmbus_regulator_list_voltage(struct regulator_dev *rdev,
 	val = DIV_ROUND_CLOSEST(rdev->desc->min_uV +
 				(rdev->desc->uV_step * selector), 1000); /* convert to mV */
 
+	mutex_lock(&data->update_lock);
+
 	low = pmbus_regulator_get_low_margin(client, rdev_get_id(rdev));
-	if (low < 0)
-		return low;
+	if (low < 0) {
+		ret = low;
+		goto unlock;
+	}
 
 	high = pmbus_regulator_get_high_margin(client, rdev_get_id(rdev));
-	if (high < 0)
-		return high;
+	if (high < 0) {
+		ret = high;
+		goto unlock;
+	}
 
-	if (val >= low && val <= high)
-		return val * 1000; /* unit is uV */
+	if (val >= low && val <= high) {
+		ret = val * 1000; /* unit is uV */
+		goto unlock;
+	}
 
-	return 0;
+	ret = 0;
+unlock:
+	mutex_unlock(&data->update_lock);
+	return ret;
 }
 
 const struct regulator_ops pmbus_regulator_ops = {
-- 
2.53.0



