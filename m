Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046325;
	b=oPr0uvNIZo8y8s6blXfYrq9auElf0VHyQ0sViSvtPzcOeYOu5+4camdnItMyJx4C/Xit
	 /ZgKrUk8sq2WqFl9TPjRiBSSQefDmcwdXr8LZsFL067U8oeX2fa6vRKSIexlV4tPXZ59f
	 bD0JnUewBNs7DAK/kAYRgwTuONqR2d/ySKc8ySgl2IemIFA91KqcfoYID1OyrNxGcRh/g
	 i1fhX+bgr9oNk8D9CPIP3hPUNBJJBLZdu8FC+a4Jl3cMsHECFdVtAkKyhS+NTmnURq92b
	 13cL2WMz4MUZXtKrOQ9or8akJHNEugfNTglEaDgrGvqqG1jx20Y2fOmTAM7l5LsDdnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xQvqVDpf+38w+W7k2u39NzZtSgDNL2IvbxrJuLJVtHg=;
	b=Pu76NFst+Xwa0B+I/Of52lpCSqp8c8lZW5MN/W5BSucx/moMG+HHLqCI4m+vNy7RDZL7
	 t7IBNaleoEt8AWD6zqKMn9fdh2NMF1bV3A1qimfdFQjVHDovQQBO7X3uiXf8+ZeEuKNd9
	 ji1yyLOr0h3djskF+7HKcw3158JnRz/lx8RB2jBmpOUU5UQ+j9TkQhVJZhfe4P5Ef1ULI
	 YAwEC970CqC89lp8iVnm0mhibRvC0YElk+ntfLQkYKYYOIuBXz+iZNoksUt4lcUQ6tVmw
	 mlQfXwvA9Dg9vsaghKjhlqAiR6J38hYmX+d/dmbnlT0o6/cCTngMYHB0Z34KgKy7e1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CRBPb7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC27606A31C;
	Wed, 18 Nov 2026 23:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2CRBPb7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7851F000C4;
	Wed, 18 Nov 2026 23:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046325;
	bh=xQvqVDpf+38w+W7k2u39NzZtSgDNL2IvbxrJuLJVtHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2CRBPb7to3+gef9KtZfqjBytJjZwbhfMnmGe2s88TkqJkNMk/JnUFUYrUR3pgSt2P
	 ElbEo/UM5RqBKDlisTbVQw3orjCrSn/lDr/exqH1I54W/b0Gp+DORLMLZiRRFuhJZD
	 CVqSGs4NOLy2SCElnmNtE8/isEz7le2Z3uz7wKVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1240/2857] hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()
Date: Wed, 18 Nov 2026 15:37:54 +0100
Message-ID: <20261118150246.197968397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index a872f783e9cc3..b4c036b20dfcb 100644
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



