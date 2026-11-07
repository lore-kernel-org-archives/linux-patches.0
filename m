Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065011;
	b=bCm1xjGqr5b2IJFwoOnNcfdjPNhrD4EzGsb3bUCX1x9u8N/cc9qVPShmYz+sckalg+CC
	 fJmJ8ZxwJrI5uxsWjq89aDnAoPs9YVOV9dwvVAk1kW12hYw1/ex35rt0hmcif08cPi0HR
	 z9uFHZgv+w8mfF9UrWBMw/19J5pR5aWac3EIispgJH1ffmyGGXC0/cmhg3cKeWgbLnEje
	 Q6Dm9nvzDZ4gl7lSkn6GQVrLxC7iT4pzSkK8ggXpF+O/V3TsZ1HqkpK43c3JGWE2E1ebE
	 DCFnsCn5uLHdEhGnGoeB6cHEO3iKHFQB3Cogp5GEbomHrmPDPGFi65P3tUnem3RzAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ANvHR3BnKrlf51JmQRtm2ZgMNBWY082vfXtYy7e5Ric=;
	b=x5WOTPantW9WYKKFnIn2UU9AVztdQH4nFONfoKhSUPiTcSpLeDp9+RdF7hOV/sc/xLCc
	 1aKjBW9QS/y6CHy3jfavhpaFu3Zk3WsOzOMz3Dwt+YaU4TdUuZnc+R/0txJZGNDQEPVHa
	 w35+sQwPl8oC4pd4Y1v5rh2SHd5AQl6eKcefqrYoc+104aB0YbnumTbXG+06cJ1hY54uj
	 /gA+e+ZzBrS9wi2hdEH6CVge0YaNg+FLUqawsAZmXQ5K77knaV9lUrD65No8/0ZMgTiEi
	 cZwalI7neR31sB4lmIEjKX6HQoDGUdwdhy9nm/nHbLMZA4AMjgxOkTD0AqdTHG9pEsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8tMhKyt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E36606A333;
	Sat,  7 Nov 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8tMhKyt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F68F1F0089F;
	Sat,  7 Nov 2026 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065011;
	bh=ANvHR3BnKrlf51JmQRtm2ZgMNBWY082vfXtYy7e5Ric=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8tMhKyt2NFEtG7cknNBzuw4Xt01dhqZT7dv6re2+Uy4Xu68NLeXGPG+SIflb6b6a
	 owPdrK8Kybs4K8p4UoYyI9/EtFr1MSWVoSM8FoK2uEDAWtENRyJe9J2hoTgOBmekp/
	 Kzn+dl1y03y51Z5UP+HaxyIZtF/iHpHTAWDLd3lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0873/1257] hwmon: (sht4x) Reject incomplete heater command transfers
Date: Sat,  7 Nov 2026 08:52:49 -0500
Message-ID: <20261107135003.440706053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 0e1d292233c83d41530df6ffa4ec5a382f118b12 ]

heater_enable_store() treats a zero return from i2c_master_send() as
success. It updates the heater state and returns count, so another
attempt to enable the heater fails with -EBUSY.

i2c-virtio can return zero when the first message fails. Require
SHT4X_CMD_LEN before updating the heater state, as sht4x_probe()
already does for the reset command.

Fixes: 0eed6fc3d2b9 ("hwmon: (sht4x): add heater support")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261017205234.1084949-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 27fddff703542..0bb9227674a85 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -287,6 +287,8 @@ static ssize_t heater_enable_store(struct device *dev,
 	ret = i2c_master_send(data->client, &cmd, SHT4X_CMD_LEN);
 	if (ret < 0)
 		return ret;
+	if (ret != SHT4X_CMD_LEN)
+		return -EIO;
 
 	data->heating_complete = get_jiffies_64() + msecs_to_jiffies(heating_time_bound);
 	data->data_pending = true;
-- 
2.53.0



