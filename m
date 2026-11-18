Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022634;
	b=bkO5c/fuMd6RzpyTgbwes2VqdTlsCsmJajgYwJc6cPGJEwtf/WQa0eeDpO/Rmaka4Y2B
	 sqGaNpdUdPZSWX2SYCMdEilWm9oWMhp1HA2WAb9NG3o3bi7tC073Fntk6t/RY7U7cDG4V
	 ZDFHCLuK2h9fARDrUUpubfbAFTl9KrmzH4j+o2RXwMNgyjBdHwm1paeuzLtLwL2nFCvt7
	 hDYLN9hZuxdKE/JM5sYXBd4zTnz0lM4OB+P3c/ueuN+CkrRKma0lTsHlCW4h5BQxvZUx+
	 w0cXUB3gHkj14esCeLjcPWDjEuho648Ge/sCRCzq00tdLY0Fd7fzhWrm4Eq07Ckptcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=73FxLtrB36nb+Nl9xdHe+rvg4VkbLzgm6xRUgg/lmK0=;
	b=xcoEScxmq2MAg0bOr1Yk+ym4sd9LS2onaIaycw2IkVLANIPecAyuFvnzPznQIZa30dxV
	 E4y34d17PxKTpEyYMBXwrDPEz7UV83NezWbSUzwkAw8Qbz8wRmQtLtnd9Pq6Y2N9ritmd
	 UiO7iU4I8K3z5YoStEUvO2S+78xwdyBM0BJ3lxuLUahsFz1LMrZI+bW4mvLh5r4fT9n0F
	 rHWa7T1JpXR7aVAiwUOux+/OEFrWyAT/4H7vfNlUXH/rHGWkpSuw77kRJhoxgge+8AmWM
	 YhwLB9bWPYU5C1DH0pwe+px4wO7mYgMkS05KYeiVUEgxZf1h9rnzuMnpHIks40Jh8/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MByCX/x1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B73B606A32F;
	Wed, 18 Nov 2026 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MByCX/x1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9541F000C6;
	Wed, 18 Nov 2026 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022634;
	bh=73FxLtrB36nb+Nl9xdHe+rvg4VkbLzgm6xRUgg/lmK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MByCX/x1M92FhgHQbN0kxotZgzVblEikxoZQqT4EzBi2SHlEqE+SWlVr5sBzH7+kt
	 7uTbWfjX5H5jKc5TWsJ0M0+ni5rxfu0Pkcfuz1cTkgZH4UyGhVzxjiUiQjWoSWn91/
	 PdFSsjcMmiwCg9IxVSeExVsRFRPxXA5eeIRHqLyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0082/2151] hwmon: (coretemp) Read TjMax only when refreshing the temperature
Date: Wed, 18 Nov 2026 15:30:17 +0100
Message-ID: <20261118150124.765052190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 5407d2b7d5279b7100621d92f2181184c8f00d62 ]

show_temp() reads TjMax before checking whether the cached temperature is
still fresh, but consumes it only when recomputing that temperature. On a
cache hit the value is discarded.

Discarding it is not free. On CPUs that report TjMax in
MSR_IA32_TEMPERATURE_TARGET, get_tjmax() returns the value it just read
without storing it in tdata->tjmax, so every call reads the MSR again.
That is a cross-CPU call whenever the CPU owning the sensor is not the
current one, and it is made while holding tdata->update_lock.

Read TjMax where it is used. The value cannot go stale in the meantime:
bits 23:16 of MSR_IA32_TEMPERATURE_TARGET are read-only, and the register
is package-scoped, so every CPU of the package reads the same value.

The temperature reported to userspace does not change.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260924-coretemp-temp-fault-v1-2-1884f0ff97d5@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Use the existing rdmsrq_on_cpu() interface and struct msr in show_temp()
so the subsequent timestamp fix applies without changes. Read the
validity bit and temperature from the same low word as before.

Stable-dep-of: 9a6aa085c94c ("hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 03b40d643dccf..3cbdf48b15af0 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -392,24 +392,24 @@ static ssize_t show_ttarget(struct device *dev,
 static ssize_t show_temp(struct device *dev,
 			struct device_attribute *devattr, char *buf)
 {
-	u32 eax, edx;
+	struct msr val;
 	struct temp_data *tdata = container_of(devattr, struct temp_data, sd_attrs[ATTR_TEMP]);
 	int tjmax, temp;
 	bool valid;
 
 	mutex_lock(&tdata->update_lock);
 
-	tjmax = get_tjmax(tdata, dev);
 	/* Check whether the time interval has elapsed */
 	if (time_after(jiffies, tdata->last_updated + HZ)) {
-		rdmsr_on_cpu(tdata->cpu, tdata->status_reg, &eax, &edx);
+		tjmax = get_tjmax(tdata, dev);
+		rdmsrq_on_cpu(tdata->cpu, tdata->status_reg, &val.q);
 		/*
 		 * Bit 31 indicates whether the reading is valid. Some CPUs
 		 * clear it while the temperature is too low to be measured.
 		 * Such a reading is not a temperature. Do not report it.
 		 */
-		tdata->temp_valid = (eax >> 31) & 1;
-		tdata->temp = tjmax - ((eax >> 16) & 0xff) * 1000;
+		tdata->temp_valid = (val.l >> 31) & 1;
+		tdata->temp = tjmax - ((val.l >> 16) & 0xff) * 1000;
 		tdata->last_updated = jiffies;
 	}
 
-- 
2.53.0



