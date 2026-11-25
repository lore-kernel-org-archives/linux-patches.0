Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620055;
	b=f0bIKtd2XDkYFKoht7eKnezK1IfnYK5K+cA2iG/hTgWCcQrRS8oFbLOBg2bRFpiBGmv2
	 5zyZ+OMj3zUhA3n9bAXZlqqefeMLe6XFyq9NWN/MSVQIQlMq8r9oZgUCPNldqNMkUfzZE
	 dL2kOUm/iOa5cUIi3HLalI3VY7FpiZBfbMGJHEjV6Ib+y7AZmZ/x0ZJC8c4KfJyMBS/xl
	 M+bLglgPlp5qcv+bHvrrNWhSS4TA/XYteVmZPuOSahuKJDOINUKsTlfxABxlAVmRQ+lr0
	 b+UDsGtTuhGD5uP1O0IkWbud306KjWpXRNgN+V5OVQaFA8x3FbhOlBX5wvusErbM0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uCoVlZAG3ULtOkbKr8TN+dA2tlxSz52kmghp+Oppq+M=;
	b=a7ygZ41VBH9UjTYWz5f/WeMSZCJwdtzQB/fq6vcyUCe+9S73nubG91gujQTCZmkyV9KN
	 RXakcK56xgwcixULgujnaN0KU8YuKQWfcqlh/rvgMgwfZJap71/R0F5sJsuJyJEO80Z7U
	 F9OsKW4lpT5AmQLVBFyBt1ivH0CMv4BXGd2lI6o6vK80Ioh7D8axicmCOnG8U0OuW2d5R
	 UOsbzJONBSDB6AoNWMLueMzcmMW53gNxtLOzsCaTiLDVX4zXlEVBDkvCxLIMwkvavr3zH
	 EpvLERjN3uQS6jmjzbhWQw6RCZSaflcI1rb7apZ5k/GI8MEUUn1rRyXgvMV9xvZ7MUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vjg9BD9R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CA606A32E;
	Wed, 25 Nov 2026 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vjg9BD9R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1D21F000C0;
	Wed, 25 Nov 2026 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620055;
	bh=uCoVlZAG3ULtOkbKr8TN+dA2tlxSz52kmghp+Oppq+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vjg9BD9RO5aSQaYdwxqxt0xnLmshdHql8hZqoYk5M5X80pJtSlWIrPvLlPgeDaPp3
	 4rTCiKAy+H9J3i4Gcdy6h2/RN4hZFv6SiIZoQMpM5j/yuLzJJR1XH0JgcN48ZQpW8E
	 wKUKYaoJWxaLZV1CsmiwCkIfjm0/bgiGOJeVvL+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0749/1005] hwmon: (scmi) Check channel config allocation
Date: Wed, 25 Nov 2026 15:34:47 +0100
Message-ID: <20261125143839.295865948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -299,8 +299,12 @@ static int scmi_hwmon_probe(struct scmi_
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
@@ -335,8 +339,6 @@ static int scmi_hwmon_probe(struct scmi_
 		return PTR_ERR(hwdev);
 
 	for (i = 0; i < nr_count_temp; i++) {
-		int ret;
-
 		sensor = *(scmi_sensors->info[hwmon_temp] + i);
 		if (!sensor)
 			continue;


