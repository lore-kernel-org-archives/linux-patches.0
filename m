Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065033;
	b=hxmhqM9cHefSTY97NUYfYl4s4Z5svbBIccapuMMwE0RJqCAZiUpMjVr3jpFrFQa+Vn8x
	 cu+uz3RxJsJMMir1TkVTYDi3QmGbbIQDV3UW4m/wLN+8TEk4Q/u5qOB2ePn0/NrqIILyO
	 zefHL5doX6HUihmpwjqEqVC9oDClf4BNJBTWPNPGkYAXGUmXBuzoGFE06OWTZ/t4oIwTQ
	 miWHe3ja47hJS+KSgDiWcAPn2LDvI1NWD/WCRnYdkpaFICYrdOyEttek5CWgNNPUbQvjx
	 T1Uzwef+IBPMgIBCutRnir4s8PuPz77NGl9c6ErLkel13YXesZv/4DZir5FnuXIj5Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ca0TcccchRtF3RY7YjVioKHOmHxlLzJgl02XtC92fzQ=;
	b=Cy9LKYQen+bQta4D09Ot8s4HEzrxlUhHFFbUe3lB8NS/PtHl6jMr3eNLTMCFBB6HExOK
	 UeZliJyHizlx1aDpBTOu6sDEuEkiXQa02K8rFFm1b4UTBfNX0JXxhT/JXm4m/iAUC+N4M
	 bsZwOyR266eaVvQjJIoq0clWzFtMfspo+nI76Uz6R8gJfHK/UVo6w0aSRUXLufXHvzYlE
	 7+MM368ySxbAlr/YL0mtm86+La9uI1WLN9/bbRGnWTGuCu866OAuE6MtQRZZxPk01jlnu
	 gwEg5dS/dIA/lm2PLqf9K9VzAQ06e5Yar+uLdt6AUx/PJ4mVn3pIoFE0U1f17RL/tPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsCdE4m2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C2D606A339;
	Sat,  7 Nov 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsCdE4m2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD901F0089F;
	Sat,  7 Nov 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065032;
	bh=ca0TcccchRtF3RY7YjVioKHOmHxlLzJgl02XtC92fzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsCdE4m23+AqZx60KsdK1KTGxf+vMvElNZ90/ntBjZiC7OlkmNAdtJMG6SRmR/u4F
	 fTpFumsOGcw6GWXng9c/kjDR4F7ty7xxvtFWOsXupD5VnBQpBAzW/NLzNpm9O8mxSo
	 04VDETonQI5d4b9yqv4a85HzDBTgDymuBKY4TBfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Duicu Victor <victor.duicu@microchip.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0890/1257] hwmon: (mcp9982) Update the interval cache only after successful writes
Date: Sat,  7 Nov 2026 08:53:06 -0500
Message-ID: <20261107135003.902288707@linuxfoundation.org>
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

[ Upstream commit fcf9aa9beb773bed9d2183bf34f822de12b2c91c ]

mcp9982_write() updates interval_idx before writing the conversion-rate
register. If the write fails without changing the register, subsequent
update_interval reads report the requested interval instead of the
previous setting.

Update interval_idx only after regmap_write() succeeds, leaving the
previous cached interval in place on error.

Fixes: e2fe950f34e5 ("hwmon: add support for MCP998X")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Acked-by: Duicu Victor <victor.duicu@microchip.com>
Link: https://patch.msgid.link/20261018055750.1318723-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mcp9982.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/mcp9982.c b/drivers/hwmon/mcp9982.c
index 3918dc36c9463..2cd41dcbd9af7 100644
--- a/drivers/hwmon/mcp9982.c
+++ b/drivers/hwmon/mcp9982.c
@@ -624,6 +624,7 @@ static int mcp9982_write(struct device *dev, enum hwmon_sensor_types type, u32 a
 {
 	struct mcp9982_priv *priv = dev_get_drvdata(dev);
 	unsigned int idx;
+	int ret;
 	u8 addr;
 
 	switch (type) {
@@ -640,9 +641,13 @@ static int mcp9982_write(struct device *dev, enum hwmon_sensor_types type, u32 a
 
 			idx = find_closest_descending(val, mcp9982_update_interval,
 						      ARRAY_SIZE(mcp9982_update_interval));
+			ret = regmap_write(priv->regmap, MCP9982_CONV_ADDR, idx);
+			if (ret)
+				return ret;
+
 			priv->interval_idx = idx;
 
-			return regmap_write(priv->regmap, MCP9982_CONV_ADDR, idx);
+			return 0;
 		default:
 			return -EINVAL;
 		}
-- 
2.53.0



