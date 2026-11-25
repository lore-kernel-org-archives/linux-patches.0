Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619919;
	b=oly1KdKaLJOxVnUHyCLZ2WQ9QPCojEnaqMqkSpjaTr0oyVn6JTqBVRw+sMElyJfO7xaP
	 yf2gZLfWVDJH4E/EmpwDPekrqp7yp0HfVZYxa2tILTQVTEupr1eyazF9maLXkerL//Cq2
	 dwcMH4ZlmHIhNycYoAOW1GudyCEc3gLNqG6AGjPu4DyNrnZuwLb9fi/UaQd/o18ymb7c3
	 o2jHHsK4D23UaMJ+IQd8dYeRp7O/4M8rmonBpEhHgFuZaGbomzRrd4UT8w5qd0Wq7f6x5
	 jdcCI0P0KK6XGedAoL3lygqh4oi/jaydyVpLuE2/vro7g5dHp6OEyhPtPgOq9qMrljA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CH/twT9BmEyNIPfVJyLjxpQ1w/zcVJcWL40HpcOWfqU=;
	b=s/DSGMRZ2CU1g0v8a0dAWI0dD4dPzX0yE5K2UPvEJ3z+7Ulm8jCC9wGdlYevZhHf7EP7
	 aNDJdRRBDEA/FL6ll36qOYmkr4oX+Ae3g9+Vzs1PlHtvCjUBKNBoEXkXcTN881fa0u4LJ
	 xnmWJHDVx+eNi2E3QGrIOlfewVUbi/Ms7v+C9rxP+SVGEYOzs/yPZCArBbASCGkJ7nmTh
	 T8ktKoELuIqRaRIzvYFuUAooYovezd2Iro00C6bTumFVzWIoQKcP62uVjg8bbVrc6rvli
	 lbPnYlfekecybPUuWm6gL45EzUtDy9fIata+TnAFziSzez9sLxzyCUm3t4Gog2VaKjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRmjNF5F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D53606A321;
	Wed, 25 Nov 2026 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRmjNF5F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598A41F000CF;
	Wed, 25 Nov 2026 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619918;
	bh=CH/twT9BmEyNIPfVJyLjxpQ1w/zcVJcWL40HpcOWfqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRmjNF5FYQ2UGNCwZMGGiIZYPd40nvUUSqTWMtUD7UoZToxh2/ZQIAGLibG3pqiCL
	 W04K7od5hvBRM0HXHdXjzS/SqtqJ/V7OzDd7CjsCkCmbcLlPD1aqmlXG+NaCIwu899
	 JiANjaRuLzwaDeVTR/PhcZl0r/JNJvtfolSbB3wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0750/1005] hwmon: (scmi) Enable temperature sensors using their sensor IDs
Date: Wed, 25 Nov 2026 15:34:48 +0100
Message-ID: <20261125143839.317661731@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 3ae1af2faad93276645d7620261643457daec73b upstream.

scmi_hwmon_probe() groups sensors by hwmon type, so the index in
scmi_sensors->info[hwmon_temp] is not necessarily the SCMI sensor ID.
Passing that index to config_set() targets a different sensor if the
platform exposes non-temperature sensors ahead of temperature sensors.
The intended temperature sensor can remain disabled, causing subsequent
readings to fail. If configuring the wrong sensor fails, thermal
registration of the intended sensor is also skipped.

Use the firmware sensor ID, as the read and thermal registration paths
already do, so temperature sensors are enabled correctly.

The patch was reviewed and the commit message expanded with OpenCode
AI assistance.

Fixes: 72804d1631b3 ("hwmon: (scmi) Enable sensors to assure they can be read")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/AED18609B941BCFD+20261109082854.3739085-1-raoxu@uniontech.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/scmi-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/scmi-hwmon.c
+++ b/drivers/hwmon/scmi-hwmon.c
@@ -343,7 +343,7 @@ static int scmi_hwmon_probe(struct scmi_
 		if (!sensor)
 			continue;
 
-		ret = sensor_ops->config_set(ph, i, sensor_config);
+		ret = sensor_ops->config_set(ph, sensor->id, sensor_config);
 		if (ret) {
 			dev_err(dev, "Error enabling sensor %s. err=%d\n",
 				sensor->name, ret);


