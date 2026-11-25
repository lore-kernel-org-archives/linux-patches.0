Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625812;
	b=A37bAIu1jCbd9d8B2tBBFmukmY4m9xfWgVPVe4ILph+DlsXkssWaaSXTEV+iJkp7vKSd
	 JQo9zVjv0KeOQufRorq7C+0wnETXU51TW83JbqbUv/KxEOc41ADOOcU0p5k/QnccaRIOE
	 6snAuoDnD4rM3bE63uu/Yrae0ZCSPdWbr1fZJUuoFDtfmCapBbuReJCI4BUYC7gr+IE8u
	 qWss6FcWgPINqtH0ocHbFcx0N7FTIvntES27fPwFzSIPSV7WE3swpkCAd+tDKRjUSL+BN
	 0zDEmljLk5b/AW8eFKZcsmnl9ZPHuZzF9JkuKTtGbPOW7vuLrjugdTbIyU1rmTIV1Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sZUX8a0UpY63IyjeFVUkPWqIxmkfJpT5wBAXVabTY7k=;
	b=bWOxtrFzFQf6jDMl+STWncfMgRKjQqqUfh1eGYc7lrYz3ssJDPbApr+Y4Q2bgVKY+7ww
	 i0yXrl7ApyCzZaH36uiWJlPUHSc7k0AnDToUXgNIZ0GFdUEgQRgvdyptTO91ydnDAFvDB
	 tE4XYG00YE20uN/qn/UUMlRcAftKqj7pkQZUSCtBoSDe2EhC+anKyBFyhfZvcMIFoqOdN
	 ao0a2IakSa3lijuIMHHgzIMo5BNsFtZZYU2KmMGP2bAKBZY3ckI8B6lMrB/fWv2fBWzf4
	 RaTDZbpIr1Z1Vn+MiRZ4TgH7/gOaaQjLrybBuVNo2+6Da5YMbFwUzmzH1G1kqPcFR0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYIbwmJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDCC606A321;
	Wed, 25 Nov 2026 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYIbwmJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520BF1F000C4;
	Wed, 25 Nov 2026 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625811;
	bh=sZUX8a0UpY63IyjeFVUkPWqIxmkfJpT5wBAXVabTY7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYIbwmJZyNxwaWrnSsLvOTW3xbZ4oKM1jNcsfIPPqOOBOTEl/VF7/ZzRsvMzOlxoK
	 hMi5tC6IzoTXxVbJEymz2f92Z6L8/HOQ7NKo3LI23GUghJM7EXgMMWjIwhN21LTsWn
	 AMpN7k2R7bMaP3O31Zk+KwA5AZn8YS31nVo9UWHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 638/816] hwmon: (scmi) Check channel config allocation
Date: Wed, 25 Nov 2026 15:36:26 +0100
Message-ID: <20261125143903.951395072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

commit a2996d892d0150d059d39c683d95d6fd7a37630a upstream.

scmi_hwmon_add_chan_info() can fail to allocate a channel's config
array. Ignoring that error leaves a channel with a NULL config pointer
in the hwmon chip info, which hwmon dereferences while registering the
device.

Check the helper's return value and abort probe on failure.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-d10ced6b-a6f0-403b-9619-f5a6573f9e7f
Fixes: b23688aefb8b ("hwmon: add support for sensors exported via ARM SCMI")
Cc: stable@vger.kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20261109151927.1672956-1-sudeep.holla@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/scmi-hwmon.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/scmi-hwmon.c
+++ b/drivers/hwmon/scmi-hwmon.c
@@ -228,8 +228,8 @@ static int scmi_thermal_sensor_register(
 
 static int scmi_hwmon_probe(struct scmi_device *sdev)
 {
-	int i, idx;
 	u16 nr_sensors;
+	int i, idx, ret;
 	enum hwmon_sensor_types type;
 	struct scmi_sensors *scmi_sensors;
 	const struct scmi_sensor_info *sensor;
@@ -297,8 +297,12 @@ static int scmi_hwmon_probe(struct scmi_
 		if (!nr_count[type])
 			continue;
 
-		scmi_hwmon_add_chan_info(scmi_hwmon_chan, dev, nr_count[type],
-					 type, hwmon_attributes[type]);
+		ret = scmi_hwmon_add_chan_info(scmi_hwmon_chan, dev,
+					       nr_count[type], type,
+					       hwmon_attributes[type]);
+		if (ret)
+			return ret;
+
 		*ptr_scmi_ci++ = scmi_hwmon_chan++;
 
 		scmi_sensors->info[type] =
@@ -333,8 +337,6 @@ static int scmi_hwmon_probe(struct scmi_
 		return PTR_ERR(hwdev);
 
 	for (i = 0; i < nr_count_temp; i++) {
-		int ret;
-
 		sensor = *(scmi_sensors->info[hwmon_temp] + i);
 		if (!sensor)
 			continue;


