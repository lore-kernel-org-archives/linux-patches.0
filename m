Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053304;
	b=1moo1to553LYRvYBvSiZqqvSFmlQFoOj62HvUx8iYTaEksMjMd/u3yT19H4od6BbMUUf
	 MJkVGnICERfl0BdSr5sEnUn+Xjxv/snBVxzuDmdcfdp9oyIBlVhLFvDQUNgahRUHubQc3
	 ireOkHjHSxf85flw/MSriDJFBBqoWHOySYCfIFnjpMKfW7/M/c3AoS4Vo4UU1K5yMWMpc
	 763Df6mUKHO57WwamPefI/LjUDl7ewguUNmk5/NruN8FkK8qeUxnbSHNvMa6CP0Nym7EQ
	 T5SKzOV3jDCdi6ClbQ0bdyyT6aM4Rt6eQo/f23IBRg2I0ndzf953AahMFKvZDMlTXjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sou0Vzge7m5svjHqpAkBCEROvy1BlVhey91PQzB6MFw=;
	b=I2/CyPeaoTrI06NEoxBBuBCkhP3Y4ujSNjCLWuvpWNkXwfnHMPM8Z2ooFecLfb45p/rH
	 9eItDflR2w1QSOyLcxZFFf14plbjfwiU0mKvakmP2NnpELWXZGrBg7P14airFfPNiNYtp
	 M00n47Hk56k0qAE3+gs34+bzIAruXAPHMz8nLytdwK9N8kQ12oaq4PzyGqIb20A2smZYu
	 VvIBmtdLeaQpingcPlGTyn5I4+Z/t6NhPKwY20Xkf5uevLLgXugH2ktCIcBNiWumqqgpq
	 3JPppfiNkIEeXk4c8/Hofr7dOzi6YcURH4SbN7WnoE05jQO7Dq6LQ4+ddhA/teEODrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pti06ytg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6FE60A2611;
	Thu, 19 Nov 2026 01:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pti06ytg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE84C1F000CB;
	Thu, 19 Nov 2026 01:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053304;
	bh=Sou0Vzge7m5svjHqpAkBCEROvy1BlVhey91PQzB6MFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pti06ytgJLVi4izs5Bgp7KpWNkQ4YQPV+TXDf3/lj+PU/154tSq5M+s2F35lahcWH
	 Ryg5ZLtLn8LfN7va2ctQKHuqq4QAXoJoajHFsOGGQtYw2axySsIbLc+/yDicS2NyY9
	 1CPzlahQVgHtK1YK3oLA2LzLJdUpI9WB3FH1o10k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0871/2214] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150046.979873232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c4a01c2a80b203ab5f80885f6994346fe217f19c ]

On big-endian architectures, reading or writing the pwm[1-8] sysfs
attributes in the nct6683 hardware monitoring driver always redirects to
channel 0 due to an incorrect struct downcast in show_pwm() and
store_pwm().
The driver defines the PWM sysfs attributes using SENSOR_TEMPLATE(),
which initializes them as struct sensor_device_attribute (where the index
is a 32-bit int). However, the sysfs callbacks show_pwm() and store_pwm()
incorrectly downcast the attribute to a struct sensor_device_attribute_2
(where the index is an 8-bit u8). Because both structs start with struct
device_attribute, container_of() resolves to the same base address. On
big-endian architectures, reading the 8-bit index field from the memory
layout of a 32-bit int fetches the most significant byte (which is 0),
rather than the intended channel number.
This type mismatch causes all PWM reads to return data for channel 0, and
any writes intended to configure other channels will silently overwrite the
duty cycle of PWM channel 0 instead.

Fix the type casts in show_pwm() and store_pwm() to solve the problem.

Fixes: 41082d66bfd6 ("hwmon: Driver for NCT6683D")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6683.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6683.c b/drivers/hwmon/nct6683.c
index 35f8635dc7f3b..90b3d114ebc01 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -910,7 +910,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -920,7 +920,7 @@ static ssize_t
 store_pwm(struct device *dev, struct device_attribute *attr, const char *buf,
 	  size_t count)
 {
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	struct nct6683_data *data = dev_get_drvdata(dev);
 	int index = sattr->index;
 	unsigned long val;
-- 
2.53.0



