Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037623;
	b=LQSjqe+2BOe5xJUtzT0ZbAoiBrzjys72lwSX4ei7abwJK3LQPauMlfVs/oPWzMn8Bdc7
	 mClin6FEfhAxw0YdqHsYFm8VkGxA/bJJtmb6gmKuKNIVQ+slLOmY642KhWYXHAF4PGbCa
	 uIW3mnPltptb2A/U0B8DlrMq+RmlYYKRVwHBhklHA05EjhBEdOT/E+JxrXew2VlTsR4VA
	 O+DlbY5+6Qm91z+AQ5HYE+B4o2k4tJEzXyvMe5M/0p23Q/XEbk8R9VdM9HvScDev4KByM
	 8sMxgmwM+qUfXLFZiksitHFYFFQP9gkNj4KDMrl1qpSByfRwjTXG0YBuJlhbPAwPT5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E6KVU4UoMV8rPPQzGnDIAMDJD6ARZMTlxYL2QhiWjPQ=;
	b=oeC/Wd7tmtwgdqJX9u55IEWvzF9+N1QHxASrAFiewhQMuKG0iJIv5hugznsQYzFDz0bv
	 hUovAlyg0Z/ksnNwMbcs29Z45A5p+3ur0oR4dfr7QGN2NsR89SgzyaKbhEFlyzblmHzvN
	 pAOV19ytcEjhC5hJf0oc+0LM8yF+sIk+G17HqkjB0W069+tbnFoC0/Ve+DYKQg4G/EfE4
	 mJ3SPd0huLEzJLOfOqTj+YQIvV7QRDlskhJ29WRq60jkEHillDitIKQPCzt75BOqCN3Yq
	 ij+wf/aKgy8mUvCwAY2l1t/f8wIVbFc0w4Eu+mDZjfXPPQJsxKh/9aUADuwv244KAhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zhjrgyao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB3606A31C;
	Wed, 18 Nov 2026 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zhjrgyao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2F1F000C4;
	Wed, 18 Nov 2026 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037623;
	bh=E6KVU4UoMV8rPPQzGnDIAMDJD6ARZMTlxYL2QhiWjPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhjrgyaoGTeV6dNlDmUXU+gE1dzZhMzQ6kBWP3PzA2tdAI4az+6nUGkEFl9EMfNXK
	 u7ofdLPLAWwzaoCRhySuxw6IalShrQOrO0Y1hIkK95Q0b2g/EsfrctnnveHvQZe1nN
	 M8Fx4d/22BYY1A9Re1yMN7zAXfl0eT4EsFaMrAdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1461/3318] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118150404.722582428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f673f7d079412..e46844c04c93a 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -912,7 +912,7 @@ static ssize_t
 show_pwm(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nct6683_data *data = nct6683_update_device(dev);
-	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
 	int index = sattr->index;
 
 	return sprintf(buf, "%d\n", data->pwm[index]);
@@ -922,7 +922,7 @@ static ssize_t
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



