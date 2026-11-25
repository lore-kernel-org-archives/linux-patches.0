Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623199;
	b=w3zFAi808STEbtcc5dnLIc3ndy4QHWl65Os6/KWtoH1MzmAjZ2LhOSuGc0g1FiaPabKf
	 biXZQC1JCX4NJhZNU2vJbyITKFmrpphmEGjZW22RDeTn/Y1iv+OrLHJemTB1AAtyi05Ib
	 wdlLyJY2ejQLt5Y4knGt8iDzSGIqWrIUbNCiLWeCH/9yWzBYAC3cXairvt8MHyWsIZuse
	 dF43a/IcKw6xE0kmCYVdpFosVndup9qVD7SQGEA6TRlSHs+uyWIYOuvv2B09sXw3lDOnH
	 KT2vL89mk1pH/4Sd0sqpWQdMuVmvBEGjGr9/ktUnQZlkyvAls6x8ogizT+R62emo+MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzN7Fmv1yzVkqPOu0CDr4lBwd06GfC5eGIpwJ3Y1FfY=;
	b=xluT5BhjaczlQMdVBoTSzhRPNj12jYgTmFj5aDzsSpuf6KAX1y0rF72HCDEeQa/XxVLc
	 5rc1wSsIJJdksu04Smiq3N/fRmMm6x0HZKl31HcVralTjZ+M/+fA5CTM4ezkWCiQTwyJ3
	 aHjNKStphnohxKgjREbtRykMfZrquISoZfx9fAqVzFJ/J6QTTPNVkNGO7d6U3Kx/zJgL9
	 CuGwA8vCBlgu99LMjw6p/7H++lgxApp1FEIJ9ZkUOCWQMOeFBE5khUuQGuYFGbsiCfugq
	 1hwHq4PeqGr7Fhzh7WCC99+e5hiKltK+GlozllE/Sqwd6z1xtx2Lf0I7xflzb+rT8LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDQBei0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C43606A321;
	Wed, 25 Nov 2026 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDQBei0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6BA1F000C4;
	Wed, 25 Nov 2026 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623198;
	bh=QzN7Fmv1yzVkqPOu0CDr4lBwd06GfC5eGIpwJ3Y1FfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDQBei0S2Fpw/OwnWs+uKkymqT/RLokZkFLb96/FwdLsY6KQEra2r+eiVV8uS2fTA
	 jpIPyxggf8+XAhp9UzN3E1yc6Co0cs2XffyGy5br1c5T0xmC038dtZHHCzpfEHthtK
	 pcVeTwye+/nd5MeCSNmMh3VcF6DKNrHuCqmzl7a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 780/990] hwmon: (scmi) Check channel config allocation
Date: Wed, 25 Nov 2026 15:35:47 +0100
Message-ID: <20261125143840.320434274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


