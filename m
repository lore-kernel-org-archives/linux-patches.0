Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619922;
	b=rAv2bALKg6FZ/HYpUW/6gw6DrTSpXMgNKMk/xAvuXJX2Qin8PB445JgdVJi4yf0iGfQW
	 ggKK7FpRSpO0405qik2r2w7FhqEH66zJjFp4+DO48h8Zt2weD1R7/eq609fEVgJLvGoJN
	 WxZO2NUGOujqHwTqau92dz5IY02azRlZCs9DZ0DU2mMIV4peFiaxieVu3sfZrse5+G+W7
	 N31vYmRJY5v8jpi4dwnDMZe+rtUENNPWqb5d7fvYOc68ROnLITNPQ8ha3rztMjIcUpaM1
	 ZFZjTLZrt0htuNxJ9kkX4E/tizhLuE3dHxB1F70by8dZ4J1mFjwUQPlWBySQ39U5XrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bJuX9/IyXm4YJDoGnx0q1vg406bjOkLzMiGgG1UKdOw=;
	b=0OQCFC9wpuXhXBI832ZtTBuoZtNz5pLPr0YXgj6mLmO8kfhWl88TsxEAQ2KZ9XPMAagG
	 xKb5o6DC1WpQPdVF1OI7XL/TETzwhEPdwc9K3Ki7qbdgygEjotT79Q0hYFzSxzjP2DQXV
	 8GQ4BntggQipuUfNt+46Vprm2WOytwNW45aVH0wje2tdRjYNN0GC3qqMYEYJ3t4rdYBGO
	 YvavsA/QJRxSQn3PL5DFofvqSvBickGkW2Cac9ff8zbPFiShiLaiWM8SPstnU9YB/eVjQ
	 e6rxycBNEsXb/3up59m4f3LWhpCMZ4A84RVPBBlOayBHv5pUfDxPhcalRgRkhsJX1Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afTExaH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA71606A31E;
	Wed, 25 Nov 2026 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afTExaH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6FB1F000C0;
	Wed, 25 Nov 2026 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619922;
	bh=bJuX9/IyXm4YJDoGnx0q1vg406bjOkLzMiGgG1UKdOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afTExaH6ih1l0rheIk8v5XQsX3qgYodGp1SbPbXsJEV0ICqiQ3fGmuwpslS05c0h4
	 2sBv4g2Sz4cfagpo6i8SaaF7TLSsMLB37E057FqqPD5leXEpIWaGK565h8zhkl2wG+
	 1kEJGaxjA1XC1stOYVFYgtVIUSk89pD1f5xovsq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0751/1005] hwmon: (scmi) Configure sensors before exposing channels
Date: Wed, 25 Nov 2026 15:34:49 +0100
Message-ID: <20261125143839.340248260@linuxfoundation.org>
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

commit 68af85b730f9a9e5f66c96ba861a66da08cfa5a9 upstream.

SCMI hwmon enables sensors with SENSOR_CONFIG_SET, but only after
registering the hwmon device and only for temperature sensors. This
leaves other sensor classes disabled on firmware that defaults sensors
to off, and exposes temperature channels before they are ready.

Configure each supported sensor while building the channel list, before
registering the hwmon device. Leave failed sensors out of the list so
their channels remain hidden, while continuing with other sensors.

Cc: Marek Vasut <marek.vasut@mailbox.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-4bdf9a68-22d5-4305-b684-f11fe6d1dbcc
Fixes: 72804d1631b3 ("hwmon: (scmi) Enable sensors to assure they can be read")
Cc: stable@vger.kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20261109151927.1672956-2-sudeep.holla@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/scmi-hwmon.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/scmi-hwmon.c
+++ b/drivers/hwmon/scmi-hwmon.c
@@ -327,6 +327,12 @@ static int scmi_hwmon_probe(struct scmi_
 		case ENERGY:
 			type = scmi_types[sensor->type];
 			idx = --nr_count[type];
+			ret = sensor_ops->config_set(ph, sensor->id, sensor_config);
+			if (ret) {
+				dev_err(dev, "Error enabling sensor %s. err=%d\n",
+					sensor->name, ret);
+				continue;
+			}
 			*(scmi_sensors->info[type] + idx) = sensor;
 			break;
 		}
@@ -343,13 +349,6 @@ static int scmi_hwmon_probe(struct scmi_
 		if (!sensor)
 			continue;
 
-		ret = sensor_ops->config_set(ph, sensor->id, sensor_config);
-		if (ret) {
-			dev_err(dev, "Error enabling sensor %s. err=%d\n",
-				sensor->name, ret);
-			continue;
-		}
-
 		/*
 		 * Warn on any misconfiguration related to thermal zones but
 		 * bail out of probing only on memory errors.


