Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619925;
	b=OX1Zp8KPoLou7e/mBI0zUgj2rfjokNDCu6YewWdyEwZZ2nnw/alme0tvezRVibB/cpj5
	 uXdxnN6/G+uXYA0FkRIE92tVaKrzpJUIPJ276DWuO1cUjuGd+KYC4gJMRCGIr+QyX1w+A
	 AIPblC2Q8HlIciam/R2x4crienpFuuLRvdvZ5ObEF2PMdzhJcA/Fa+55s2UG+8dNmNixq
	 dvLrqVJPubRLsI869qE8Qwp3Imnylgz6ugOD6xrghfItx4Pxtzi60T/yktxn7oqu/bEA0
	 y/PY3vNQX5Yc7+rrE1T859rUecPMS9w5Zu43mzVm9FK+e5Ch0pNg7gN+pmh1TAIvXvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S1dzi7FjMJx+kWOne5Fd87N1tyQqtcB0uiCwvCwdt3A=;
	b=iAT1d51jFew6QU2toV2J8Zl/YSvuWve5tVCgpfHw8PS34nkVz2n3UnseYhWAUuFDz61o
	 oWAhpPQn6jpo+mTel6b9tB0gOEiWOMXBp3nDplgoO+5nvrb0fhduj/V+MXXO0Y8RXKCuC
	 UsfCLf+nuhlR3f4OU3YxnCnPcx0UvEY/P7sAk/n4S2rMBpjmpbWkG2fcCWKp/mNo27Lh3
	 Dpaf0hYjgmbXlD1/0XEe9fizS9Uwap2M5HqlS4FQZkn6KMMp3oFiNYMRZT6YccbwXVSzw
	 o+7u4JJ1Dsg5y/1yXg5yU/zdDONsWnKyT57Gs3Si0jKGhZ/q8R43M8UrZHLMoCK+alw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6CeZRwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1CB606A323;
	Wed, 25 Nov 2026 15:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6CeZRwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750B01F000CA;
	Wed, 25 Nov 2026 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619925;
	bh=S1dzi7FjMJx+kWOne5Fd87N1tyQqtcB0uiCwvCwdt3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6CeZRweIeOjqLYUnECA+FdIm6aBx+UVr95wfuKuJdPvbGTptQ7D1UupXtyEbSNoy
	 7UrsB6WajLaJtv3EeykJQlfD+/BmNuYNTTq9uGd+4KS9foO/GUy8bDKSgl5oBE9PNZ
	 qn6awumLNnB3nvQy21qJA7BFyq5E0icQDX7Ll+6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0752/1005] hwmon: (max31760) Fix the local temperature limit registers
Date: Wed, 25 Nov 2026 15:34:50 +0100
Message-ID: <20261125143839.363310513@linuxfoundation.org>
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

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 028ed93145d9be88eee670088ef13482b5d36c1a upstream.

temp2_max and temp2_crit use each other's registers, so reading them
shows the local limits swapped and writing temp2_max changes the
overtemperature (SHDN) threshold.

Use the high limit (0x0C) for temp2_max and the overtemperature limit
(0x08) for temp2_crit.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-1-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -27,8 +27,8 @@
 
 #define REG_TACH(ch)		(0x52 + (ch) * 2)
 #define REG_TEMP_INPUT(ch)	(0x56 + (ch) * 2)
-#define REG_TEMP_MAX(ch)	(0x06 + (ch) * 2)
-#define REG_TEMP_CRIT(ch)	(0x0A + (ch) * 2)
+#define REG_TEMP_MAX(ch)	((ch) ? 0x0C : 0x06)
+#define REG_TEMP_CRIT(ch)	((ch) ? 0x08 : 0x0A)
 
 #define TEMP11_FROM_REG(reg)	((reg) / 32 * 125)
 #define TEMP11_TO_REG(val)	(DIV_ROUND_CLOSEST(clamp_val((val), -128000, \


