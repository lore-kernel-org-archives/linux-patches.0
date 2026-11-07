Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062505;
	b=jsrlC4xJDLldUuk7+7eArbjzZyMSAzS5jaRg89abXTFabqlynbEv/qZJ9zEyLw9LX7lv
	 MuPBW3hnY6CYOFtGequG13G6Kk1TXEgmukdpUkvTNvtQqOltfmvfe4IC+m5NXXBxk1nxw
	 xOEHIn7Y3Cd7MHPoosuOhhqgO8pn/vi9Yu8WHnp/c4ej7m9sfjpfg1Yx8EaTsFsSi7uIZ
	 LB2UOXkpZwOmfBjKVa/civfGDDPBUKF87kKB8jJCKgS7aWG0kqVsZrg7D1sYrepkQCYxg
	 4ouBVDavMUlXaCvGu1wnVv0p1pNpGDmcI9i1kRt2vHJelelk4KfEMV8ylpMl7T5iWTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V26TiMzslUCTrNMs/KDcV27KuBTayXvYpIsr/KWBn4Y=;
	b=Jto40fMhdvg+SAVKDh1EuAMFpjwva2BmevOSI7bSQxKRqjtIknHBxjIwcFPTNCaA5dYt
	 0+0xisBWd56cqmxdXjT7AwhlKIsryJg01j3/40n/h6eTnCFxV+TuuEPsXWBj7hbISqQiZ
	 xVXfMuOK/2i7HC54VIoOcr+OwiF7rOpiPJoBbf5lWfcHf/aGOKzpcJwWSaP24yKjnrdNx
	 RxzcNe4Bp3gyZb+XBUYJ68q87toTFMEOL1k4pYPryJ2oMiFben9E1sh43KL2SCGZuzjp0
	 Tw7VFy7U30wDRqgkmpW98EcIQFLiwvhVuahA42OR0H7DU5nMX3XqGdrXBDNrhFNzoWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t3//Sgv1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3F0606A331;
	Sat,  7 Nov 2026 14:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3//Sgv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F481F0089F;
	Sat,  7 Nov 2026 14:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062504;
	bh=V26TiMzslUCTrNMs/KDcV27KuBTayXvYpIsr/KWBn4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3//Sgv12AVrUPhLqIx0Jam7ffOLkzeCbvpqMta2dhV780Tq7alziE4sx4TEhxVEo
	 ntB7qyIDpdN0VpvbzErRrINqWP4QH0y+W+tjJRI5vqqc7JIQd53XZ9LvX1MY1e8EZB
	 JZ1+7qwS9UnoevRsGQf9yYk7kmQS/kHq1zulhNAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1364/1536] hwmon: (sht3x) Return the consumed count for heater writes
Date: Sat,  7 Nov 2026 08:56:20 -0500
Message-ID: <20261107135036.146875001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 817ac527100c8e20684211eb919ffd6d875adc7a ]

heater_enable_store() returns the result of i2c_master_send(), which is
the two-byte command length on success rather than the sysfs input
count. This can report more bytes than were supplied, or a partial write
for a fully processed input. For example, writing "on\n" returns two
instead of three, so a caller retrying the remaining newline gets
-EINVAL even though the heater command succeeded. Retrying the remainder
of "off\n" can also send the heater-off command twice.

Return count after a complete command transfer. Preserve negative I2C
errors and return -EIO for nonnegative incomplete transfers, so a
zero-message transfer is not reported as a successful zero-byte write.
Keep the existing boolean parsing, command selection and locking.

Fixes: 50c22cd154e5 ("hwmon: (sht3x) add humidity heater element control")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261019154718.2328055-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht3x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht3x.c b/drivers/hwmon/sht3x.c
index 1f63c07cfb085..87f406cca6cae 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -546,7 +546,10 @@ static ssize_t heater_enable_store(struct device *dev,
 
 	mutex_unlock(&data->i2c_lock);
 
-	return ret;
+	if (ret != SHT3X_CMD_LENGTH)
+		return ret < 0 ? ret : -EIO;
+
+	return count;
 }
 
 static int update_interval_read(struct device *dev)
-- 
2.53.0



