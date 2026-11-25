Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623202;
	b=vUbnGjLXEUmU4SBAuQA0cN1SePg0mHWTsSYB6pF/9YXEsQhGoVHCz9ThBHjRKiWAaXWl
	 LHdA8iYgRD5dOBdAITqyFKBRsNm0jd/VbJD7zw2iQJN2G6F8z4LCDKdb24NCRJRw03ZLa
	 IBOX3HQnoiTUDCaXEiRkZjbq+k8RtwlBbqZIhyMeo24ybWGYQGOLnk022SOhJVo8oa4R/
	 9eh4SqEJtu69wky4uSMxOchHW1jLCU5UiXaAhNRGvRl7TnDLrEExtTO/zPEFkNw2mTnLI
	 pjwfbOWPynsBtI2ggh+jGw7HvDCEJ/89QO7W/ZUk3W4jCB3UwncyebkO4n54EdEPJBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qlCcFaaPUgO1oyBC5XUYJMYRuLbZqjQBURti5o6er4k=;
	b=JIg3dDfJklTrmf5X16yS22JT8QdtpD3VVrYmrf4gQXkag6BAyYHetB+im7W8xUpeoDtr
	 KEjmUW4uuexG5pycykySiALApN2iMwiDAl+QdypC5A2TKY6IPWw71UFE2l52uy9GZmfif
	 V+2XDPF58zT7Is8qWOYuh/3Y9ERD/smt67URcAlvwreH8Lpgcvn/7LayY+OVa+pDkr/ZW
	 81IuJn6/uM1X4beG6JeNv4bB/kut+juMAtI5NgGGcRFN/Rw+JsXWN2iKKwRONALoenx4G
	 1vv0XL00SXs1qjsNKvoFWGD80jPISM6aEfuBVLFZmzX+T6e/3K2w/bp1tQrl+MOn1AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+u7LlB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F98606A321;
	Wed, 25 Nov 2026 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+u7LlB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C91F000CA;
	Wed, 25 Nov 2026 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623202;
	bh=qlCcFaaPUgO1oyBC5XUYJMYRuLbZqjQBURti5o6er4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+u7LlB278h5lzn4CRlnuqMRGSSeRZY/bMZtV+lAj+JhIAAQ56AOI+tBt9uE0PJLf
	 p0XBAgwTBW78vabjYRSgIj+FFvRhyl9vD7znCoTJ4HT5bHtCRXEXZ+2zxsawlVh//A
	 IpPZG8sTXWsiNIVGwUcZB/037/ldzeZISRDL8QuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 781/990] hwmon: (max31760) Fix the local temperature limit registers
Date: Wed, 25 Nov 2026 15:35:48 +0100
Message-ID: <20261125143840.342373593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


