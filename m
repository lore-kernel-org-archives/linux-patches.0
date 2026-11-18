Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059044;
	b=EZmjenYp8PUbcT037R5Woz5kxFq095d3Y/OxCIiyjKvFoFk3emdI7vAUyviTSHEabc8C
	 Ixt/iR/tZG0M+FJImfvx0uYuTaa5hI5CGj5wTPmOdwkVALLPltEVNIuzUqBUUteWk9Ot4
	 XP+SiYrmmRZRtXwkRR4BtD59Ju3CAO7naUJFza67YZ/vrgv4bYehDdfGK+0sy4MpEfu1c
	 59hBTkut0ih+Xo+d+rPfT0JlInn5vd5Mu0MZ+sytQSw7jLOI8X0m0zPq42Fv+9VdwmRUu
	 OYYUDFDFG/kE9kAfnAYpbwNeTwRK1oVWldfERG6c7LXJiNGHO33dNuibJgvrXctcemg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOYilem7dTjHmFQVXvdx/V5Ry1Iy0CrBrql28ZdrNdc=;
	b=nzVdPpwee+OK4W07Wvz+G8JHokxkqu1mAbR4ORmWfYLsC8q1y3FHysov7o2gOU7+VktS
	 IJeaYNMGQEc4rAg26UCKpA2o4Fr/NKZMRMSIf8Mn4QVbrzm/2WMHXzH5hVBIP9YOOstkC
	 /E8urULugitywY3yCn40cvkNiymiGkd5U22E2gEvI8OnARUtS5+jRc08LjXWLjiy0iynO
	 VB3QW+x2n4ib6YTEM5HI9CkeXGvBUo6w5kLkG2Jhs238NIltGCjhxYbfI76VS59afzdzm
	 vsmnnAv0uwQXvKROHIiy/WtIyPb280FDPR4SlvID9gW18R5UnQjNpHTNbPs5D8ldbDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HXGJsqqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F400E606A31C;
	Thu, 19 Nov 2026 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HXGJsqqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A371F000C4;
	Thu, 19 Nov 2026 03:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059043;
	bh=ZOYilem7dTjHmFQVXvdx/V5Ry1Iy0CrBrql28ZdrNdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXGJsqqkDUJ5CXP5bAspBQWwjOQf3Ppo0y0KspYYNhfIbBA9Dj9TORkyL4yG8VLi4
	 you3PUooOFFHrW4hBloTor0pYrKzcUxBFVU3okRmmlQzJ7lZP0+H9MuPwRsc7VasbH
	 Q/fN9m9OjNjV24uEWG6xr9KXr1CJwSLgSVj/LVjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0700/1848] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118145945.172224305@linuxfoundation.org>
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
index 05bf1bbdc4c0a..06b48599fa660 100644
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



