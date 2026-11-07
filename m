Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065034;
	b=dnnuXRMI5tE9Dn/+bghssH3Og6mvsj4Hz+hqDjm6Z8+RS+KTVNzwOCs6LdXjcWTiKAtM
	 GPHx0zj8ZhV8YjKqnlBLzaIO5anZEXWRUXKhrTykeqFznHF/seeo1FsBfu6Vpx2Uubik6
	 S0Rlzo8cedNiQ/CZNCY6Ru4SYQeZQR5G5unaRDGzMSWvDjQjcnURtY/h97hScomnq1UCl
	 7kNRybpQL83CmZHafedSiWh0PK0ZdpCeQWrCLxac/WsNdOr0pO1W0B9MCEsBa6hCZjvCQ
	 clkOFC/ws1EzGNY45fNIy1hmNK37w/1A6IaStTU6NtQDbKacjVmjHd31Drg8LizGUdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7Suza9TE0YOuabcGpJ/IfGhnyWvdwcoPJpuupgcwBQ=;
	b=tGDh3dH39QPLnlYTSqIk1JyOBdIQTdizBIeMMphkOSEG6kvA/4IIl2Ed8RsxJ9uMzj8O
	 LbAJfzGQ73v6Sf76X8oFiKBAJwBN/WvMGqsdphEOzCg/b3PSu+iClSOlPmgdNYv5UliST
	 YzyGUvKjfUOK/8Z8Dx49XlyQreRyuMwU68oRg1yF9i+WgMUexPOZuv1RlwwPCYb96uqN8
	 mhpW+nCGnWsj4LI/hUbT714UJC+GQSklhzS2FcEWiWgYpAqYfN08thh8QN755G0NFaQKc
	 bBf4JoTaJ/gqQ7rok14rKWxBYI2xrmGRAjC+AcXphvS6IcDK1AqZ3ryk+P9GSLALmoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PaceURzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7C606A336;
	Sat,  7 Nov 2026 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PaceURzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB3D1F008A1;
	Sat,  7 Nov 2026 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065034;
	bh=d7Suza9TE0YOuabcGpJ/IfGhnyWvdwcoPJpuupgcwBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PaceURzD5iwFwUG+Xbqc1v/0rBO0rwyiSvQb/WqKos0Fkwn0cWMhqq32Z7h9e+y9+
	 AMuNu18JSom8voj+zmlBga12GwvQP38km7lL2cVsngjUi1wUEG34b1vJa5fpCCCyV9
	 pB27UpCY7E70ynaNnHYO0IKoViOBe/aKREi0w8S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0891/1257] hwmon: (sht3x) Return the consumed count for heater writes
Date: Sat,  7 Nov 2026 08:53:07 -0500
Message-ID: <20261107135003.929816420@linuxfoundation.org>
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
index b46de050e20ad..a0f5ba5c888dd 100644
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



