Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591642;
	b=SpzE18a9NNSgjSLOZ6jxjBQLBfslLbo1JuZ6NtjN43F5+3pGnk/as89v52XOgyML5gTW
	 l1qifjPp6BwIO3xX+h7D5RAeLlNyCGrnTzg7rB6mNLYDuIpPM5oPUrVqv/wjWwx54/EYU
	 u2a8bdGNiHIrjFTfMJsUrAEyeGZFFHsgSQrIoxz5ASpLpSujxBEw9xQ+raDf/CdaURcSE
	 YUPeIVZnnh5x+rW/LRUd8q1R1YfEIJvIctIjhge3BUHR6jnyZrr3eqU/XGBvADNr5u0bj
	 0qNo+bXnQv6UNwgTs5p4MaxuFBPNzBi1b51QZMqC8IkdmR1FRHSVHPFCur3GkcUYZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuH7r3lx6hBHH21fh6BgRshwi/+2mgQ4pfDaXEyiQkI=;
	b=taRtEMQ+/oh3lk8KqWz27LCCaECUQQH3WokDdNrTMwFEr9SpDC2VAjazNGGz8EVm7sYP
	 FqZ5dZ+pXa05whaHTpNReibsJfiYmfGBsnFu1sYl2yj1bVuvsWXrwdyS4pHR8YHVObSZM
	 wlgJaRYcGjuuIWpOKFMVRzldytZFjRKT30/VvALjRJnmYSgmE2wtvEBA4jyuvceeppRfQ
	 cxvWXTEjLbWNtg8PiHvxsTaLrom73/yulqZJNwJJo0qkhSstaiqym1ip5OdjVgmuPH2AB
	 f90c1VVInlxXugXYVevsxkQ0t0PUlGkD0mCXMCKIPJ+xVo1QaKFRE3YjzE7P2GvI7Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKSvevoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA57606B46F;
	Fri, 13 Nov 2026 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKSvevoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD4B1F000C4;
	Fri, 13 Nov 2026 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591642;
	bh=iuH7r3lx6hBHH21fh6BgRshwi/+2mgQ4pfDaXEyiQkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKSvevoHemQs57oDXgN4oQCMgNatpcktupiLH55cjdNYpdD/bFYdsHJYtLJJTUhAj
	 zFDt0E0mQuEV7WxdsW0hCy3KZH7pMN1rkjeWwv3iL+L3KcrePDY62H8dX6vstzqGdm
	 urBhL5tmQ0TwSCMl6ghcaaXSVOg3CrHIF+Yv1aek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 650/670] hwmon: (coretemp) Return -ENODATA for invalid temperature readings
Date: Fri, 13 Nov 2026 10:53:34 -0500
Message-ID: <20261113153833.883945571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the validity check to use eax from rdmsr_on_cpu() instead of val.l from rdmsrq_on_cpu() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/coretemp.rst |  3 +++
 drivers/hwmon/coretemp.c         | 21 +++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/coretemp.rst b/Documentation/hwmon/coretemp.rst
index c609329e3bc45..6089bee1159f1 100644
--- a/Documentation/hwmon/coretemp.rst
+++ b/Documentation/hwmon/coretemp.rst
@@ -47,6 +47,9 @@ All Sysfs entries are named with their core_id (represented here by 'X').
 
 ================= ========================================================
 tempX_input	  Core temperature (in millidegrees Celsius).
+		  Reading fails with -ENODATA while the CPU reports the
+		  temperature as invalid. Some CPUs do this when the
+		  temperature is too low to be measured.
 tempX_max	  All cooling devices should be turned on (on Core2).
 tempX_crit	  Maximum junction temperature (in millidegrees Celsius).
 tempX_crit_alarm  Set when Out-of-spec bit is set, never clears.
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 8de1c781ac7a8..cc81b849c09ef 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -61,6 +61,8 @@ enum coretemp_attr_index {
 
 /*
  * Per-Core Temperature Data
+ * @temp_valid: Whether the CPU reported @temp as valid. @temp is not
+ *		reported when this is false.
  * @tjmax: The static tjmax value when tjmax cannot be retrieved from
  *		IA32_TEMPERATURE_TARGET MSR.
  * @last_updated: The time when the current temperature value was updated
@@ -73,6 +75,7 @@ enum coretemp_attr_index {
  */
 struct temp_data {
 	int temp;
+	bool temp_valid;
 	int tjmax;
 	unsigned long last_updated;
 	unsigned int cpu;
@@ -397,7 +400,8 @@ static ssize_t show_temp(struct device *dev,
 {
 	u32 eax, edx;
 	struct temp_data *tdata = container_of(devattr, struct temp_data, sd_attrs[ATTR_TEMP]);
-	int tjmax;
+	int tjmax, temp;
+	bool valid;
 
 	mutex_lock(&tdata->update_lock);
 
@@ -406,17 +410,22 @@ static ssize_t show_temp(struct device *dev,
 	if (time_after(jiffies, tdata->last_updated + HZ)) {
 		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
 		/*
-		 * Ignore the valid bit. In all observed cases the register
-		 * value is either low or zero if the valid bit is 0.
-		 * Return it instead of reporting an error which doesn't
-		 * really help at all.
+		 * Bit 31 indicates whether the reading is valid. Some CPUs
+		 * clear it while the temperature is too low to be measured.
+		 * Such a reading is not a temperature. Do not report it.
 		 */
+		tdata->temp_valid = (eax >> 31) & 1;
 		tdata->temp = tjmax - ((eax >> 16) & 0xff) * 1000;
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



