Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037605;
	b=0mW842HPoDdI6Tye9dpk7+1XrxWCxdl2u+DFZIS2qKk/y0TWhNvYWdGDLQpKiWdMhd10
	 MewItvDUmHSTpjDIrUWmURFdJzuX7n79WYt+rMJQU/1JdcNPco5VTNIjlLhwe5ldMvbkf
	 ejahsgs5vv/Xs9fnAx+7HjbS2k98wMu3WPG6spFgAC4y79/i1E1OqU9OZwBiqomzGUS78
	 QfX4O+GmqibMXs0vf43RPWgIVo45U+hxT6GyWp0j4TQObrIdMDYw0UJ85ncTW6IyTN2F+
	 IEcp/xmW4+1NQhRbRP1XJqaKSbDS2WOuyj7C2Tx6VI1/aJAKEAdODDvAd/oHkh3Mmqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4r/aQW+3aaF8FXN2qQIrvPGxtLBdd2ErGtpXQ7pGTQ8=;
	b=rnzsCuacqTGaZp6w82y/6TJgvJWMIxcF6XToWcVtNJZyiyvXQtJ/xr4oYurjZnz2hABI
	 NFpqHI4ILny06Zrj85A9IiGYeWKq/2Ttisv8jNyJfQr4hxw+729MwofW525Grmcwh3Cc7
	 z/xQdu7tUGoAC464a8JlFjNUZoka8fdCu0MRHnLsTZaawhq+EQglJxFy+Uf2enPh5No40
	 ckAXWsmVZRzz+goprah9nBhgMgal2CivgkkSb8y+ILWE7W4hd0xFVnhZuSOVKwcbWu8O1
	 q4jPKZw1z5VexJkbu884rBTqA945FmV+CYBh0qpFCBq5Wr4ebm2v467eUXNC5h0dtRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0lwPH/zr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1C606A325;
	Wed, 18 Nov 2026 21:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lwPH/zr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD421F000C4;
	Wed, 18 Nov 2026 21:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037605;
	bh=4r/aQW+3aaF8FXN2qQIrvPGxtLBdd2ErGtpXQ7pGTQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lwPH/zrdE/H+y+98gU2hzKlvlVR0u2dOx2I0jKi5HHKYWCJQHJLbSVr3NAbJQBIf
	 aYKvRt3NqK/PpyMEuXxe5PBChjqATUb1AGHCHA5+a8lkTCUVh8OVMUCm1sC/pZ7R6I
	 PiJux5pORUG3zyNDAq43UJBEuwChTvfM1HcKrcpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1455/3318] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Wed, 18 Nov 2026 15:34:37 +0100
Message-ID: <20261118150404.545343592@linuxfoundation.org>
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
index 197d7b6a00b7e..2f4db6ce11516 100644
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



