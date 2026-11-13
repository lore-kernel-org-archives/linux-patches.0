Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590296;
	b=bQK+MP9IdTcGJikzeSIL5W2lE9lL1w0QO2I2zF17XBJbgBIF1NIkYtudwv858T0paHaI
	 j4ohp8gbBYzHB+9AyR/NiKh/pm88Y3pqInvW1QwOMoDbQ5rPRlUnx86OyyXOD0tu53e61
	 jI0F+ycCbxjESExGESQZjsKK8siuLlqu90zvxHGwGjPN5tbOmxkpbJF/oGHQ9jWC4Jkob
	 stT8GMHSnNcGytzDHJLspUaDdGyhcRp3ftHLZ4jLQ9NPRwpgSKWitbi0m9PYDZB8RHQCs
	 OnYeWb6Sauv218XSS/OM7Kr6kqy6LODGQG8MtTUUVLxFlrJvVAGo/Rorbap3b3px++g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwo1T+d2gwnbSJiRoY5pgVx9cjJ44MwdFJdV8q8iCq0=;
	b=Jdkw4y0ZRgyjywe4J5o7z6nzBY3Mkxns2bCcqEHguOJGow/VzWvyt501I/efIbG7A35h
	 j8lBNhZd6GKyGXNMWmcBWZ3AG5jEQB5bAakwH6+LM2N5Q8REudXet7sbyII0EuBquBbnA
	 7//P1w6Y+5UIeemhBi2I3pDJfwrM2MG8XIuLrvnJYvc5bLwRUL42cYagxouey1ZfuetIh
	 Ppk05hkEWbrj2MvrnJur7Q9IoAPJudLTVz8a66MDTxAFgmVwvfUSBTv+eYB1Ege8vireF
	 rTYXAhISyfqjhGOyrKw5EEVvPmz5hTvenjf5NfTHr7vVgkQxV87sQ5IYhQWjlEsa6gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAZ5DeaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE25607B58F;
	Fri, 13 Nov 2026 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAZ5DeaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17C31F000C9;
	Fri, 13 Nov 2026 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590296;
	bh=qwo1T+d2gwnbSJiRoY5pgVx9cjJ44MwdFJdV8q8iCq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAZ5DeaBvfvyfxUVhkBDk2F1/Pg9FZwa3JBZ0KFL9bX9o68rGCa776mjWRlFArefc
	 unjytICnwZX0V/zCInMS21AAjWOGNtHfjwseCTJUgKhTt5tnar/3Fcdf74+yrVZ8qy
	 UbWWFY0RBlW3dNm7GDsNTY3QcpLWLOd3PgWU4AOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/686] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Fri, 13 Nov 2026 10:46:57 -0500
Message-ID: <20261113153830.605333814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 4a83804140386..05fc440f417c8 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -918,7 +918,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -928,7 +928,7 @@ static ssize_t
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



