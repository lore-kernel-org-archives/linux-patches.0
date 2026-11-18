Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059052;
	b=WMIFoW0zb1/q0GmoPmaOsz/jDOLeNX2amQL3WoqqVwGSjKsazit7LzYf1DXDO50DXvSx
	 6qpdSjSQ8zCktSp6SQQbaR8+oGYTTHep+ZMLkjRr8tas/Bh0prLOSQp4HbmP2KHi4rmJ6
	 PfW6ubHEsFSPak9RPpOI+tkfiM6oh4vFZDGkQ84sCPbkPgDakgT/r1K0UNvIV2OoStUc0
	 7ZjtryGUarDlCVkljETCN3v3PZasQkQiAoy+JXMV6Q3+g/qu19vEEzM8bXbVYsyzgAbWR
	 A8+3TSlc+jl5rcjuKmO8C5Iw9PogJfybVANnVgvNRX2p7Y+ydsCslq6aLBh2bM93d3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTKpQ6OkYYCQvfzq4s5rSrlQLu3jFvVvzdFlYV2YzFY=;
	b=DXyW6Pi8qeJRBwCPq9P23jZh3rMsrZMyxv+FG2tGP/4lbPRzY5lohIbhE4UXyClqfkTe
	 0iSvcGepPd3hsSWMHBTzjZ9iiukKnRq9tqZWz1Y423tBJz5HjxGtfgb5l5rZU4uY0/baG
	 L8/TXAu003HHfwycwfRutip7WCF8pigUVqKlkKOvkqF69eJLQzBrZOHr8sJ3M6dKHeRL1
	 uRtPHmJUDbZEYdtB/sD7Zvyu5HmWvazKIpsRjDjrwg4Z6gKG0ddzqT27o+wy31Yd32ody
	 y4chNQ1VWGnbzt05wxJXwsQOKcauH4ec0xjd0VyU2+eM4R+hMWipnRHwokHD/0wxfog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td6ttUV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B26606A325;
	Thu, 19 Nov 2026 03:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td6ttUV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EEB1F000C4;
	Thu, 19 Nov 2026 03:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059052;
	bh=qTKpQ6OkYYCQvfzq4s5rSrlQLu3jFvVvzdFlYV2YzFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td6ttUV8d/LVAW7nGoEAAoBKGtiVabDqZurbor/4Px8piYIMKPFKmEEGi1ZXiIvDf
	 IBgehML1pyE1sYv9k7vYEnExzLBZYiwdfuWzV0d6Pkgj4kOpXaNB6YVJ7+9xm/lpNH
	 LeDwqXuGZvKHVqsSya3YZJ9OiSNyhgIx5nqm2Z9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0702/1848] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Wed, 18 Nov 2026 15:45:40 +0100
Message-ID: <20261118145945.240120035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d299149f4d25..cdd45a5752a0f 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -911,7 +911,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -921,7 +921,7 @@ static ssize_t
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



