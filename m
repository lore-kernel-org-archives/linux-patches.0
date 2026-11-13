Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585564;
	b=S1pG48omwH+YOXibtNVZfbwKFakDKRcbfYZ2fhB1i5zmTNqp0hAW8bUgA63eordY8+tn
	 uhIaVnsgJdoVZwvC8eHd1ILXCKFxKum9mSz9fexvoTH+e2d6CU7at/7Uswkb6Y2+iSBW+
	 FIfT1F+5Zm2ecPIr09o7FsX+GIB4jv327HLbD1v3VjeUAgx/PcUm8vgGhWE0QZ6/oQ+oH
	 AY+ij2zCFYnn8yV1fjOY3dx07hVUhSbIqZCzL3Ps0ysZDup1th5yQ9AVWa5QLA/Wj6vHj
	 +d4WzRM3ZYMjfs4vlMnLN05guScA/NEyXU42FLkI1FTFOY6NCDsJXFlZPdvE4unMTEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9hmOIeAfXmJw+Cked+/RuZGW+N0hdwgjQ5SXcxNZxms=;
	b=qIwjGhkBKAcOKcv2SySgypuuhxdUqBsvFK6GVT0odlN5eR680EPkp8b2t7sYrUa/j9KP
	 We8LWv/RFWIx2q5d9HqOVgNVE5lLFuYKCX6erpI9oE1liHPv/6bNG4MSWAdDqBMHAjSna
	 jnlwDCfQaF1frQMEHhTAIhOOY4a/qkPgJYXepaDUzE7kgm7GetlNFA8d7mI3xhmCHWaud
	 bJNEpAl05AqQ9iuHMZ2ruGk02VcU/l23KO2ctaPavb/6JyihlCPnzb7WMb3oLdYp0h+pf
	 nxeNjG4obj5CUb9DGeSaWB9j17kNqXNF+dL1L/tpV8q67uxs9LUa+v4VWgfLSY/19tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sallaKNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95868606BAA7;
	Fri, 13 Nov 2026 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sallaKNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F521F000C4;
	Fri, 13 Nov 2026 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585564;
	bh=9hmOIeAfXmJw+Cked+/RuZGW+N0hdwgjQ5SXcxNZxms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sallaKNkjEHlQUGU9B8yq7aH60EvYh5GN+sKwXj2pM2NFYD3IGK7R6okgr2EhHlEM
	 VoI9vgKhXYTlLMYO69H1LpLG6/fuAabKRL/N3cR36fRtCAmkPLIDT5SC9iBbWBWXSN
	 xv3JdRiwLziLKm727w9Hpgv+KYEBTHNQZLuKXZWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 200/507] hwmon: (sht4x) Convert update_interval to jiffies in pending data check
Date: Fri, 13 Nov 2026 10:48:24 -0500
Message-ID: <20261113153801.264642487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1a30ea0be623b7443edb6adc79e07632418cefdc ]

In sht4x_read_values(), the check for whether a pending post-heater
measurement is still fresh compares get_jiffies_64() against
data->heating_complete + data->update_interval. However,
data->heating_complete is stored in jiffies whereas data->update_interval
is stored in milliseconds.

Whenever HZ != 1000, adding data->update_interval directly without
msecs_to_jiffies() mixes incompatible time units. For example, with the
default 2000 ms update_interval, the validity window is inflated to 8
seconds at HZ=250 and 20 seconds at HZ=100 instead of 2 seconds. A read
within that extended window skips triggering a fresh measurement and
instead returns and caches the stale post-heating measurement left in the
sensor's output buffer.

Convert data->update_interval to jiffies using msecs_to_jiffies() when
computing the pending measurement expiration deadline, matching the
next_update calculation right below it.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 0eed6fc3d2b9 ("hwmon: (sht4x): add heater support")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 0bb9227674a85..f38c106b7090f 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -99,7 +99,9 @@ static int sht4x_read_values(struct sht4x_data *data)
 		msleep(jiffies_to_msecs(data->heating_complete - curr_jiffies));
 
 	if (data->data_pending &&
-	    time_before64(get_jiffies_64(), data->heating_complete + data->update_interval)) {
+	    time_before64(get_jiffies_64(),
+			  data->heating_complete +
+			  msecs_to_jiffies(data->update_interval))) {
 		data->data_pending = false;
 	} else {
 		next_update = data->last_updated +
-- 
2.53.0



