Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036841;
	b=gMiDkPujMLxOyfyXiMtUZ2UQA/dkqBawYMWSjn1m7/18SQm56plQcDg8jjtq/HYrlSds
	 a+spOm24h8BfdHAsracd7eJQAxtB/BqkB1FkJtIi6qZJh+Cdxtv2WMFmqswXHub/LFoy4
	 c14PI2VjQPHF9x/5m1D2penOG/cPm4cGxVTDodO5u1C9Te/LfwckFTqNFJaz7RlI8nAFc
	 dVCv5fcXQrs6jNbCwSywXDPklJa+xQy2Z4A8uxbqVKh4fQQEQGt2tgKgA1KJOJVxtrIQ8
	 v+SArCvDa2ED1tfO5KnHMObApQzTl8De+kTrkUznMEEmaP5LtFGFnSDTXdNlxkx7Hpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4SwMBfQDSpttshBbLTkxCQTAdByazO8tyq+ZdtJZsgw=;
	b=dk172YncW1UblZW1uGLNiEjSMlhujxDlF3gCdcO7EI2kCSoRGCBuOlmFx0D+q9Ky7Rcc
	 lt3xY7dA5JUYcmHnI6RT8IHyamlsgM8CP2dQ8oyeotWQkIege3/pTeuy+5TtO+12ep/Rw
	 9D6j+LHbeBeMWp2QNAxJvC9qMsGnGcFUJZR4Ejo2lFS54w56+aUApcN/+infR+KwJG1Yl
	 slf150beCu0Bvm09Kp+0XHftAhBhpgUuNr+RWBvnw8U5MPRranCxrmvVWYBn6oFfDAJ8D
	 i5wSMwDoAPX8kr+cMU8fc8IQ0URqjnPGO89fwrvxPKbeDMTfzddfWKQvOFujxiDkcHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vv6pTIDX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BA606A31C;
	Wed, 18 Nov 2026 21:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vv6pTIDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399C81F000C4;
	Wed, 18 Nov 2026 21:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036841;
	bh=4SwMBfQDSpttshBbLTkxCQTAdByazO8tyq+ZdtJZsgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vv6pTIDXvN5Q7I+VkjCv+fo6mo+5+NAnfhnqSkTNZu5hdExHPg0TmIpopbUmNu7zv
	 x//HtTfB+mi9AXt2AwVVeIeyw6THNTeccNhFsLmLGmG2//PnUu4xbCyW9NVdC/Crp9
	 3hJVU3wIlG77DyCaXcCi3uA89V1PnNFldqUiF4ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1162/3318] hwmon: (sht3x) Return the consumed count for heater writes
Date: Wed, 18 Nov 2026 15:29:44 +0100
Message-ID: <20261118150354.973653657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f757ef4bbe99..c2c5fccc97edf 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -540,7 +540,10 @@ static ssize_t heater_enable_store(struct device *dev,
 
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



