Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052739;
	b=jvIMcNzWnhrz3UAHEDDoeJEcxqvGbvF+wuWySu4zSnBDaJN4MdDYyr212aBoGU4Qy4wx
	 fTyzCOFF70vSrezN8ZbkqYZLiP6iC43csm/3MMIH8MYcBIC5ISwU8wKp6cRXh1HCb7AsC
	 g7x/SYQk438svEr2YBxSDsCy1KpyFq+kJYOt5waDDQEzYrKiqQklxzaKw/e+Av3vvdiIm
	 lrUNJJLhOHrsbGkUcCxLtGw0OI7fvSLyLLmFn1C0BaFCjnd7ik4OH3PRy8XiqDKDn/qqO
	 yCcWFoI8c6/q1LZXhHYanZh4A2rvBb+QlEQMHlCh0lUYA7fWPcpbv9zrzTYG0NKp4Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwRCR+8ZZVCVE5NGOF3qj+9ljx8CFx8Vzr8fgAjIhoE=;
	b=NKFYOBpxn01Kv0WWYgXsu3R4sawALrSwmM73ZGgA2U5Io6Ptf5kS2zlox+ADhvnhH9Eo
	 zOhffqHoGdTceEXeaa1r9ZtEFLsInt5GYfED1DAZI6wTYOzLu7FKm8DZCgW5jys9a/gEj
	 upfmX4DsDQnTD+xbvfSIdWcSMnG8Gncwj0mrZPq8Dnj1+tolU83UxvDWa8ma/ccnLekEk
	 Y74LG9JvLMdKtBdn+OxZ5j+grz0d7oRzGH92VzgTOQlD5LdumN3XNuSBRgCXrqBLpNc8/
	 9HPjnlln60vqFHFFuYTZ7UJfuM666xYciv8fF14Y0qXGevji/qWQYIsRCLPdE813OGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSyqo2UC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4969B606A320;
	Thu, 19 Nov 2026 01:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSyqo2UC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB181F000C4;
	Thu, 19 Nov 2026 01:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052739;
	bh=qwRCR+8ZZVCVE5NGOF3qj+9ljx8CFx8Vzr8fgAjIhoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSyqo2UC9ugm6NTQ4ICnjzrP+u2y4TwOzGzF9oFUMA+nAozM3eZzXbtZbH9ln4asi
	 3dpbD9VYerIQvIkt5xSaT6R+SnRzCUBtCoS6TD0cIw6HnYv2G5Y8fRIm898zdH0aUX
	 t8zy7uCFDM68kX53Wv5F5nksVH7c9cayS4S6j2bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0669/2214] hwmon: (sht3x) Return the consumed count for heater writes
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118150038.595007575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



