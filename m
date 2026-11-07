Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065007;
	b=QXjLQ1Ww23K67+tanVEYpOfktf4aFM7mUalLOYumgIWDng45Yhq7JOs3qPCxWR3qeaJp
	 Jj51hAkB3K2E/VUKqT4541PMUbQf5Z0SM2EjPro267zUSuV2X9WuNqYWOAcqpSyrZPUv1
	 CNglpddK07ot/sF6vcJmkzZySi9QxD+cBBiO5a+aUBdaf9ZBcVDV3MxBkNqCbF8YypJiK
	 +9MixZPiJgVX0346kFccAK0UC14R0r6p4twipXnf99aNHaW9XZAXeVrAEGrRXtwfqX7kU
	 w191m0zHXnQ7aJZrDz7eNOIKXi20X+hKaBkfFZO6IU+T64AyEc+c8cRUFuJCfW95eZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hwthhbboLl3CxlGtVGevflHbZjp3xY5Pz6+Q3rMasLo=;
	b=hjLrvmKpBHp4SvUMwVWTj8cy00Zi/GXEG3JCexPsBVps/cllWW7nzlS0ZEUryAFQyFRS
	 rJ9w+hYBeXyamuGfqUq0qoBpuVt+9fmOagnvEOl/Uemg9/t78ImXeZUwHYCuuqOG91lR7
	 CTJ2F0bOqvzfisC9t7bm6gTci+GTDz7irIW+WFUPD52R0f5CPto05B6brA2f1P6g7Ps2i
	 Rb16/jopoUmBn1eOGjNNS68c6FY7BtrMUhgYyeNVpftjogGxpwe/tFWRJXT61dztT90gz
	 0qIyGPAjUBGwEppCG7pNs8oHxJDWHH3iSmxCWFz8pyeav8xdp45wjKZFmDcBZkE8jrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMcTNiOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA64606A333;
	Sat,  7 Nov 2026 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMcTNiOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E011F0089F;
	Sat,  7 Nov 2026 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065007;
	bh=hwthhbboLl3CxlGtVGevflHbZjp3xY5Pz6+Q3rMasLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMcTNiOdw8Y7w1a3IjS2Bmmqr7AGPY88+QUe9UftXgIZpLdEe1sMr5QH/yLBR4yuH
	 t6jeIdb67OZrga5kHUhvI+5E3amvSIDaSGUCxVdhlLtyxsFDgrQ8aMtQfM8y93x5rg
	 XkJsUtucKpNlfbq7QiMEL5bT5dEUHX4UrxmTcHs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0872/1257] hwmon: (coretemp) Return -ENODATA for invalid temperature readings
Date: Sat,  7 Nov 2026 08:52:48 -0500
Message-ID: <20261107135003.412212825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit f63aaa529cbc73146ff0d52235e5479042285cae ]

IA32_THERM_STATUS and IA32_PACKAGE_THERM_STATUS have a valid bit, bit 31.
The Intel SDM documents it only for the former, but the package register
implements it too: x86_pkg_temp_thermal has required it since commit
f1a18a105660 ("Thermal: CPU Package temperature thermal").

This driver checked the bit for both registers as well, until
commit bf6ea084ebb5 ("hwmon: (coretemp) Do not return -EAGAIN for low
temperatures") made it ignore the bit because some CPUs clear it while
the temperature is too low to be measured. Since then, temp%d_input
reports such a reading as a real temperature. Userspace cannot tell it
apart from a genuinely low one.

Fail the read with -ENODATA while the CPU reports the reading as invalid.
On a CPU that clears the bit, reading temp%d_input now fails where it
used to return a low value. sensors(1) shows N/A in its place.

Cc: stable@vger.kernel.org
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/all/46f9f319-de71-412f-a424-6cb801478456@roeck-us.net/
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20261006-coretemp-enodata-v2-1-64e788acc7dc@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/coretemp.rst |  3 +++
 drivers/hwmon/coretemp.c         | 21 +++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/coretemp.rst b/Documentation/hwmon/coretemp.rst
index 3493016833814..09f885a847e30 100644
--- a/Documentation/hwmon/coretemp.rst
+++ b/Documentation/hwmon/coretemp.rst
@@ -50,6 +50,9 @@ All sysfs entries are named with their core_id (represented here by 'X').
 
 ================= ========================================================
 tempX_input	  Core temperature (in millidegrees Celsius).
+		  Reading fails with -ENODATA while the CPU reports the
+		  temperature as invalid. Some CPUs do this when the
+		  temperature is too low to be measured.
 tempX_max	  Maximum recommended operating temperature (Tcontrol).
 		  All cooling devices should be turned on.
 tempX_crit	  Maximum junction temperature (in millidegrees Celsius).
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index ace51e08e72dc..bee2c9896d4c5 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -60,6 +60,8 @@ enum coretemp_attr_index {
 
 /*
  * Per-Core Temperature Data
+ * @temp_valid: Whether the CPU reported @temp as valid. @temp is not
+ *		reported when this is false.
  * @tjmax: The static tjmax value when tjmax cannot be retrieved from
  *		IA32_TEMPERATURE_TARGET MSR.
  * @last_updated: The time when the current temperature value was updated
@@ -72,6 +74,7 @@ enum coretemp_attr_index {
  */
 struct temp_data {
 	int temp;
+	bool temp_valid;
 	int tjmax;
 	unsigned long last_updated;
 	unsigned int cpu;
@@ -398,7 +401,8 @@ static ssize_t show_temp(struct device *dev,
 {
 	struct msr val;
 	struct temp_data *tdata = container_of(devattr, struct temp_data, sd_attrs[ATTR_TEMP]);
-	int tjmax;
+	int tjmax, temp;
+	bool valid;
 
 	mutex_lock(&tdata->update_lock);
 
@@ -407,17 +411,22 @@ static ssize_t show_temp(struct device *dev,
 	if (time_after(jiffies, tdata->last_updated + HZ)) {
 		rdmsrq_on_cpu(tdata->cpu, tdata->status_reg, &val.q);
 		/*
-		 * Ignore the valid bit. In all observed cases the register
-		 * value is either low or zero if the valid bit is 0.
-		 * Return it instead of reporting an error which doesn't
-		 * really help at all.
+		 * Bit 31 indicates whether the reading is valid. Some CPUs
+		 * clear it while the temperature is too low to be measured.
+		 * Such a reading is not a temperature. Do not report it.
 		 */
+		tdata->temp_valid = (val.l >> 31) & 1;
 		tdata->temp = tjmax - ((val.l >> 16) & 0xff) * 1000;
 		tdata->last_updated = jiffies;
 	}
 
+	valid = tdata->temp_valid;
+	temp = tdata->temp;
 	mutex_unlock(&tdata->update_lock);
-	return sprintf(buf, "%d\n", tdata->temp);
+
+	if (!valid)
+		return -ENODATA;
+	return sprintf(buf, "%d\n", temp);
 }
 
 static int create_core_attrs(struct temp_data *tdata, struct device *dev)
-- 
2.53.0



