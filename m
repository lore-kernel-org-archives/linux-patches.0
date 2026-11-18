Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045741;
	b=uNmB7iVWag4I1Dt6gKqMDwfO3C9d8Afi6MjARVXLQlA/wMvfJXOstaN0k8P4iFUD70Pn
	 yE3CC+yOX6FiSk6Gy0zTfv5o1EPVqNrFtKaBCAjJW7pUwFJebO43IarI/igbqVTroqJke
	 TiXKjqbJQQAnmRxwoZEB4UXskO7bFgqpGpzij6Y+YFLSBmRW9nkrk75rWn7ABkKauLQnD
	 Xi9Q4mN6vU7BVe4BAe58MEfg4K4mi8C8p9sOKo31wwvm4PFNwJ2kZdviWUeEk4opHkQHc
	 A7mxTKJWCO4XmU3/YNPnIgulrrR23AuHBp4hR3Ealkhsiwkpzh0rYYoeBNuDe5YwfZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTpLu4SZNjaxLSj70XAvHZ5HbwHeGzgUjMcXeyvAPG8=;
	b=SmRpTGhk+AGN4SNW1oOP4+OHYxm+yT3SwcxfoLIGy94OTsmT7KhQaUKshp1Z6Vqxb1DG
	 SM/GpbpQQkIZmYAiouRR4qO8NiZf2yhRluwioHwMrW/bUalzPOnn5xdI8qKQFxhtv76ku
	 fPv88V2H3TYZUn0Rf+CA+6Ba1SkOjGQLAMikoxKN6vHIf8TI+Tqyu08E/sm5VYds2Ccqs
	 WDajsR/CgUvAIzlJ7eXez4XCScIsZFuKkW1oFpVHZ8zPQKD905HKz/A6zZFBA6RyXOQXP
	 rFgaqM52A2j3hctgBPcH7k3fmIC+b0HCAS0dMEWOKXPDVUVRlgYiTJRU/ksXD9+oPYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngnqJKt7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAEF606A336;
	Wed, 18 Nov 2026 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngnqJKt7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2891F000C7;
	Wed, 18 Nov 2026 23:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045741;
	bh=QTpLu4SZNjaxLSj70XAvHZ5HbwHeGzgUjMcXeyvAPG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngnqJKt7OwPSUdKDxcWVKkDbiTuMe9oVWRsdMnTzzy060fjx3jc7n03k+fBQ50bwm
	 RDz6aXdIs3gTjWb/J2OPhXpoZdH/338918Yv5Lpwwv93BuBIx7BnuPvK0qJYZdzMW5
	 qUQ7y4vs/m6lhy4onynu3h4XV14rqaz7rSs+LP6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0991/2857] hwmon: (sht3x) Return the consumed count for heater writes
Date: Wed, 18 Nov 2026 15:33:45 +0100
Message-ID: <20261118150237.284543690@linuxfoundation.org>
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
index 381e33c6b4a2f..0babcb466e25c 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -542,7 +542,10 @@ static ssize_t heater_enable_store(struct device *dev,
 
 	mutex_unlock(&data->i2c_lock);
 
-	return ret;
+	if (ret != SHT3X_CMD_LENGTH)
+		return ret < 0 ? ret : -EIO;
+
+	return count;
 }
 
 static ssize_t update_interval_show(struct device *dev,
-- 
2.53.0



