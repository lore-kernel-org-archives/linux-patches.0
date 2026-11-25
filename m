Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620042;
	b=DOVcQpNi7bTjTgnVVmF+D8t5gfTimuKjVmTWR/X9tP/5NitCAh/Azplid8wqP2Gre1jI
	 bnw8W4aTiIF7dfiGgBrzFsZZioV2sGeYe4pD+2xRSql5SbLFXAytdEZ27BvrYbldA1iEe
	 w7VnVbeJBtphijh32HS0tvl0Cs7I5Dv7+LYWSkT1td0pu/FoH1IB3E3LKHG3+jxDA0EjX
	 +l1QdW5tU8FKIuS5pjIITKsm2YTcCPyPfF3rQdv+d/hlP33szDPhSj5CXog5YzWCHaQ1d
	 L5jYxoq+zfmSobiLMlobmAFFXSuntwQG+gXQ8g1//g0K6AvJ3BAybukFcjsrj2cwf1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14nD29MyDvVgSfEqYm67Zk6nKqHpIhzqCfLSIVALizk=;
	b=peSW/yEQtVkbqKk7yx8p2X4e13UMmqGzP9aM8DdmUB9pVvlMfay5q6VV2OI5oQJA7uru
	 vugbslNhnRMXEv2dwNoQVuBdWPuEKhtVkxiTaeDLgO6eqackF2XeumwSnDIk1gRvS+HFm
	 SFDfGC3jC/0y86FJ76kAvu2RGUv9Sz7nVrOQyFSU53i6ZjFyWQAL6sSPgavDXqk6kd86F
	 amPqWfiAeWurz0q39ZjQcAm6DUL8QVSxhm6tivAzxSJWaqfNr3tRo2O7tQAp478cOL1SN
	 cwbrMt+IHa3j+Apr8A16JImNFavbMM7rSwzCcAdY01xk2TMKC33so1HtC5U6iE8HQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSdmUTe0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EDC606A321;
	Wed, 25 Nov 2026 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSdmUTe0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2081F000C0;
	Wed, 25 Nov 2026 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620042;
	bh=14nD29MyDvVgSfEqYm67Zk6nKqHpIhzqCfLSIVALizk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSdmUTe0Snjr+kU/ZWqaUxO/erQ+m5TXPQsb/IO00VUQawbAl6BH7xSh4VSfc0KgK
	 VauBHMzuABsbKvBqtlmN3hIqg9pTPwoHzK2MKv6W+0A2qKlUDPq75gBGJ8BiuYslj+
	 i2oVb/Ch+35g6Oomp7LGAdqf2wrxNuxZwfVE94xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0745/1005] hwmon: (aht10) Fix update_interval overflow on 64-bit
Date: Wed, 25 Nov 2026 15:34:43 +0100
Message-ID: <20261125143839.204461884@linuxfoundation.org>
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

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit b5c5b67e02406fb48acf57cf2c30a570230fd6aa upstream.

On 64-bit, update_interval writes are clamped to LONG_MAX ms, but
ms_to_ktime() overflows above 9223372036854 ms and the interval wraps.
LONG_MAX becomes -1 ms, so every read starts a new measurement and
update_interval reads back -1.

Clamp to INT_MAX like sht4x, so the limit is the same on all platforms.

Fixes: 8c78f0dee437 ("hwmon: Add AHT10 Temperature and Humidity Sensor Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Link: https://patch.msgid.link/20261108172651.220121-1-zoone.rupert@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aht10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -222,7 +222,7 @@ static int aht10_read_values(struct aht1
 static ssize_t aht10_interval_write(struct aht10_data *data,
 				    long val)
 {
-	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, LONG_MAX));
+	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, INT_MAX));
 	return 0;
 }
 


