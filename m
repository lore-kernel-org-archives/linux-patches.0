Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585598;
	b=G7YxCGLv368pxfncvoMTzo9cToNT83g7gn4dolgt/zOsn2yA2qe19+DN4sGMOGjR+ege
	 iMrRo2WjyFpUJD6ZWwbJ3bSn0NOJsfiAw7aOVqhZhDswoOlYk79m3xSTXZnJuk9W9AWDN
	 rDrA25RnIN4RypPMIlQUCfV6nO7H78lYCGL111++7wBrbc+Ivrx5/L4g+kxo3yAWmJjNL
	 YWRcRrzoE/giRYIkJ+LD6NucoA8upoSvYUaq8/CMRlcCaYxNt5G+X2VwA5Szdmrjvcauy
	 J/BXspfyqHJfZGOulBIqcVWL/GiOSYKLHtFcG9JO37CSRdFgWNFttlHy75I7g3TfLFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s11kQG0rT9XAYcNaoOe/yPBlDR/fnElR3GP/ThhDBT8=;
	b=xGs88fHV3DupITKWlVZ0WjFP9411r51bLxYMpt/WHvgUdm3VbXDVKA7n41a8ii1bZ326
	 xcfghr1XnffxSS7l3PvkL76PIkHZT8KpVNfH/G9u3hMoR98TKYod6mDPIWOviWWlOpJJu
	 aspi36ksRzABG2dXWvK/Gn2oQIO25kswPTWlMQVUDcn2T7VFU4ndZruPPuwNNM6IYUHlv
	 G6q80EyOjVw+OO9B22mHWWXqVZzD1Son+wcJVISkXxFxKovmt2sivd/iXpNzFObEebt/D
	 Gr/6lbuokpyr0Yk+WMimE1bK9bxmxafiXb4ssx5Q/PtIIiYjvLb0zyq+Fh9a2+7/zIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DROS0w3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEB606FFEC;
	Fri, 13 Nov 2026 15:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DROS0w3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EED41F000C5;
	Fri, 13 Nov 2026 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585598;
	bh=s11kQG0rT9XAYcNaoOe/yPBlDR/fnElR3GP/ThhDBT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DROS0w3kyQE22i5FF8HtK0m2MwBweV+LTyiUyQ8+JWntG63en6YKLwqH4LaItFiuh
	 0+7f492ms4e7FaOZBCswAZzYKDYv0K8VcjCGjcASjd6KK1jopUPOOwfs5WOcd+qvAf
	 DRlZ0Hub3+B9VEvYJLy+fTFIZofkzayBON+nFc7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 189/507] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Fri, 13 Nov 2026 10:48:13 -0500
Message-ID: <20261113153800.918703136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index e1c36c95affb2..f34cb62305be8 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -920,7 +920,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -930,7 +930,7 @@ static ssize_t
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



