Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591105;
	b=lA2KOJygB+diiHeqJ7v/hP7OZGe0XEexRq4fiZR+U4AmpCM4urflwMJEFTAnb0TWgt9W
	 KYKjWPYiHnj3k4OM9ytluSNCz1TQI/sbtoRt5Hctb9olw4O0XS4vvoLYJfD/brB1Y1x7+
	 thMbN0NODXJFuTzcwdXBTOLdze7xskrIgjiQX7MN0GOIZqnKlcfqmXpfndfOleHhYDBoX
	 MEi93+KHhQLrZd5pkL4U1FIrPp6HtoLmgRwGw0+3zrBYDGbTwHQkKPoDQ26ovn2y+Ttzv
	 KuPwPVFL2p9T+mTGpfTbogN4SL1WQBcsMznYnln33dct4HG0an3lF3NCeIt6rPOXAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpbwUVry77reZnb2mJQg9v5bZlpKqYGpBpD4inIqmhE=;
	b=RbTcyeCs40AVbA/vW6VwT22EJ3q2D4rVmi/QWhdxvdAFpH1sCTmUn86qKgIgNw1CxTp5
	 EWBU/796Qu+gGxd1pF61ZqoynMbZXM4SF9fsAhx9JFZzJgGql81xreqrNt49KV6V3x73f
	 K649Qyln42KmiT5sqOxK5tVxf/7Q4kJY+PxYyH/kumjvnK8E8TS5aeeCZQVgu1/dbUzmB
	 uGWQQeY+0P6SF8SS3zQB46neB8ZeQQ70Z8OfhSRFnrzG1Wweoe5MGP/o9HZql/XCvdTep
	 lvpJ3TyxNbBrq5PcuS7xDsMn9uiXJclA+CrhhAPab2UolJzGjNmoDQMgJI+7IISqQEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKA2fEmP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092E606B37E;
	Fri, 13 Nov 2026 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKA2fEmP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE3D1F000C5;
	Fri, 13 Nov 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591104;
	bh=rpbwUVry77reZnb2mJQg9v5bZlpKqYGpBpD4inIqmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKA2fEmPbtV9WHnZDMXAbQ3/osxk/egoMD9JoB/iyBPJvtzyPuOANlECds6vWrjML
	 VWs9B8Sclyv5AfJxwc/YY+phpDnhLwrFxILUIs03IqeyBGvoiQFvwGX3IO7iBmVkaf
	 10UALvwEDHikeMvh1Kk9KUX2ID+8JVkOQFWN/5Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/670] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Fri, 13 Nov 2026 10:47:02 -0500
Message-ID: <20261113153820.579638013@linuxfoundation.org>
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
index f71615e06a8fb..e091551688a02 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -914,7 +914,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -924,7 +924,7 @@ static ssize_t
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



