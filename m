Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053298;
	b=v55CKJjDj8CjoVJDeiz/K7mDHEiqVlDqAH2zMKlR6Mv5mZI2hVKz++TJsXrE7DOiSevI
	 2BlI2WONqYjOOpuS136rW7WuKq6anZBZJU0hWUUALWrIPDqx2fNHDhkeo+s7IIz1AG2Gh
	 MpW0IzHX/EeEgCyyZ0/2C8Rv8wRhERWHWlLydBnFSAPPyMcHp/pgDwVJHpCE4XhevzNtT
	 KE6tUEkeRFuuEp24b6RX54cgPzJ1K4U09L/dplxZ9vMmG+o67l7Q7Gb2L8hA6PXbSFf6m
	 1gCC0kWD+Yoc8eCTd6jkm0yrKSbG11/59VMyv69fR2m+e62Yq5c0BgY+CPisPfLVa8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZM+AK3wy3xxKDLn9JKzslf+XxCrDZeLs1ikRWyVaLZw=;
	b=n3+AAU8/8oK50uVFLuspcLSrnoSCsrhv7P6ubC+Br+6eN4XxynXunKqYKt5pDRr2CBno
	 hSYc07h05l5kUMpradBsNJ2cugy58th1eO2W7Y4ZIkcRUMH0hoC2A1FGhiwjkzyHGnShA
	 ghpkD6dv16EdGgnFS5OUCBw30zdi5p1gQ+EVedPOvf/lc8oAB3A8cNvRReuTZFHOvP1Gc
	 eQfx4LlVM/wiDhNrIUKDSIbXVlVLykW8Asl3hj47Qv9sSdkgj/KzQ2i0oreGQ57VTvng3
	 MiifoOXDsf63kIGpD7gE98EIX6yYE97jsWNchzd3TGc5TqOziPsMcHQyM4tajyYunRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAXm6XES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE67606A336;
	Thu, 19 Nov 2026 01:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAXm6XES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3603D1F000D0;
	Thu, 19 Nov 2026 01:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053298;
	bh=ZM+AK3wy3xxKDLn9JKzslf+XxCrDZeLs1ikRWyVaLZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAXm6XESQdRSdBKP7wL9DqCObOQOOt3ucMvUQdN3vQ9jYsNf3HGF2PvSibRbg35Fm
	 TqNDTMpgntbFo0/Z9GgQA/9/mKNkJsweXRBqssBxsF9S+VgFNNulzvo3oie4dGJJ44
	 3lXm8efJcYy77hev866wbPnOQgROpC0smnAkLm2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0869/2214] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Wed, 18 Nov 2026 15:42:25 +0100
Message-ID: <20261118150046.893743592@linuxfoundation.org>
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

[ Upstream commit e2c26431b4e47892378582a414b4bbaa9edf1798 ]

set_target() updates the cached fan target before sending the command.
If the command fails, subsequent fanN_target reads report the failed
request instead of the previous value. For example, after successfully
setting 1200 RPM, a rejected request for 1800 RPM returns an error but
leaves fanN_target reporting 1800. A failed request also replaces
-ENODATA when no target has been successfully set.

Update the target cache under the existing mutex only after
send_usb_cmd() succeeds, as set_pwm() already does when invalidating
the target. Preserve the previous cached value and return the original
error on failure.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261020160941.36787-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index e0cf92896bc66..5d40207115fab 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -208,10 +208,11 @@ static int set_target(struct ccp_device *ccp, int channel, long val)
 	int ret;
 
 	val = clamp_val(val, 0, 0xFFFF);
-	ccp->target[channel] = val;
 
 	mutex_lock(&ccp->mutex);
 	ret = send_usb_cmd(ccp, CTL_SET_FAN_TARGET, channel, val >> 8, val);
+	if (!ret)
+		ccp->target[channel] = val;
 
 	mutex_unlock(&ccp->mutex);
 	return ret;
-- 
2.53.0



