Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063508;
	b=eF1JDq68MVU9dODS+GLwLbNkhU88ZaCTEFdRfBqt+htPeXYC78v000TdtAQTdop/C7mV
	 5Lmwny8sFCqmFeINmJejtgqFk/LTGaecY0MiGZ7Thqh6ErKDq5J+IoZudrrkwUNfNS/+Y
	 VCMB7pDpBPXvjBZ0LTElwZa19TpapsdwRfCWholo/F2VwBzKodZZ+35YeVk7+uZJCjP04
	 WJ5taYHFdb0aGhl4A83Elb7PecaGnUKWLgm4ANt+NGgVLOS9j1cfWYv5qKj4H8gsVtd1E
	 MYaB2vyWRTl+Txcs1nUrgIyKyctcwgd6mkJZ8PsJKj++hi1QqGCUJthuAC7/dA0Q7pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30TS1Z7DvQxeeK4OuUmMjPHxK/WB7RdZFpkJFhgbidA=;
	b=fgapN/TB0mTLb8kKLNKRNd2U9Q4PyKlevMJn3WL+Kv4/iyirznJ9+Mxw5myCB7J3ANQY
	 Q6zHrgBYmBPKCQQPlhe9xZxYm/p9vgcMXXll5UbTwDMV88u82uvvQ/kFzhpONwUUd8xaM
	 TbMaMC0PViKjhdZs9zsk6TqePhkwrwwE4DKWZRApiLg7MkcM4FadX2tWwrpK2lbxmF8os
	 Rce9HzlropwkFrSqDGYD5XqtN0Ux+B/heTVKiqh65hiPt7PEB83UoSb0y5+jJi36FfJBr
	 oGXLOisTubW525RyYtXfNMZCXiLyq8cScIguhcemGPIhcgEnbxD6Pt2Gb+yZeu05BcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyRLmdd+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F35B606B8AF;
	Sat,  7 Nov 2026 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyRLmdd+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC061F008A6;
	Sat,  7 Nov 2026 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063507;
	bh=30TS1Z7DvQxeeK4OuUmMjPHxK/WB7RdZFpkJFhgbidA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyRLmdd+7bVkui3dlMyPAM2ESk6XgKH7POT6fiMq8pg1EHGFyyC97yWttcV6912nt
	 PIjvZdXP+8pACnOtnNYfzY/U9NwcaGxtLTQDn7Z4iL4GXvt67glJIVZsgIv/RQu+AC
	 3qBudsm4okVKMsnWw3tvQMN7rhzB078BnrVXXXrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 652/869] hwmon: (sht3x) Return the consumed count for heater writes
Date: Sat,  7 Nov 2026 08:55:34 -0500
Message-ID: <20261107134915.159321943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 5d04013efb522..c3e68bde709df 100644
--- a/drivers/hwmon/sht3x.c
+++ b/drivers/hwmon/sht3x.c
@@ -543,7 +543,10 @@ static ssize_t heater_enable_store(struct device *dev,
 
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



