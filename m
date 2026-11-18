Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058599;
	b=Kh6QNUTtlLaZGMZTstXlTIZNRrKjYDcpp0qKwXsZQ59KDFaZLBNAyhpmCVnW0CJxTwpw
	 rz53bS59gcXpMXDVV0k+CWcnGC7kyXaoZI1/4MsumDIyOK/MWeocYg3mp7dc8Esg001Z6
	 +Qi43CtvhWpEIxC09AFw2+YZxF4xVH68UQ2uZVXcZ9+EV/V5pFI+loy1gQlKJKQ8IJSNC
	 i26ImzAOWLWbyoa/fOjiRWRZuS48Fwdav9Uotnez9CTbeYoxq7+rECE0Ire//1SKFo5K3
	 3dA/Wg/wp5uUFOGUGxnFCDoP/Os+MSpu6PsJ0n7yJKKgOPOy1ekW5mQZ0tHeFTSTR7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dd94rpNDcrPzibebQrDq+q+NM4VbCp5UrZGg/110+lI=;
	b=usqYuKD8G2eY3TwIQM/oCKAW0k6nxOMXqYafZL15auTAe4+rMvmdgdeQuyOSITJI2kOl
	 0C+Y9yqLcYS0Tei4XXR6InjPdRQVzijrn4M0WBkhuNtS1e/wzqgWkl25EfUhjqVFlYbhg
	 7Ftjlc0xKS+4kb80R6f5A/lH8/tvxvp2WpD4ltqiPxB2fE0b9izJXHHU+1vYL6xYhOsyZ
	 11ChC2osGdyndNefoHDWk24Bf2dgyKgqas7nDF/FiSaJ1Bi8QR1nfL43RFoRzchbUqxDP
	 IoSBWkrqaMhqNDfyo6eNF6qTZBxy4frGWBsHJu3742Ls7Ck8hT7EvD7XlyWbLXoHEAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIgVqN0B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BBC606A31C;
	Thu, 19 Nov 2026 03:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIgVqN0B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFAE1F000C4;
	Thu, 19 Nov 2026 03:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058598;
	bh=Dd94rpNDcrPzibebQrDq+q+NM4VbCp5UrZGg/110+lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIgVqN0BAuQmM1YRg1NfRb4qrO1THvzR6/DorfBPG1J38bEPe+52PXvbtlqZKkhAM
	 oXn9co12/2GJJaPcbggiDQu5LdCos1dDJwDMxQb4Lm35U3x19uN3R9HAX7PZD89QJ6
	 o83drtI4JL5fQwmGYz02PTnpY5MQfalqJ5VA1mnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0544/1848] hwmon: (sht3x) Return the consumed count for heater writes
Date: Wed, 18 Nov 2026 15:43:02 +0100
Message-ID: <20261118145937.753678186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f279aa1cee5e..7176d63a42151 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -541,7 +541,10 @@ static ssize_t heater_enable_store(struct device *dev,
 
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



