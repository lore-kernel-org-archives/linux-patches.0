Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585527;
	b=aGZzEPc5/TvgbupdvVpwSF2KI0v9iIDa1N2r9KCYrFQG4EcQVyX/IyNcbesewStUKOXL
	 tQSXRpygGyKQ1ewPVPbsV9vfwygdStpe6Nz2A4hP5BCXWjQl17ccx0Jb7/IEfgtHD7FLE
	 usr2EB3fvwJ+aprM+d1lk0twJOwc5Hpoh49s8tY4ti3/qSPKwAqWR8v4IA7ZXwmjfDtgV
	 cjPcepO+ifHkP4lV2JP+O0z73SmYDc3YLCNaT66ks6UqB7N4CV/iLdPwJ5K4+/TL68X1E
	 k4m7/9tT+TbeHhbpXBsyt3F75hCYW37yX5fWtxU7rEysKxTy/NAPbauT4cJF7+pCubw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63PePifV7ql9R6Nl+1f2RcD+0Ohy3fainJfJ5wogyXE=;
	b=Q6zdXDDnQycLTa0MedkYSsddu0YzyNGUfPK51CdJtSzgHIsyeXVd+nvymVk4Y0uu5fte
	 H8ZPf8+VLZfrF2UcowlSu71zhCQb3zMrSUwehXjBuOylQ6/LVfKVbd9LW+nNhZYsfDLh/
	 6K4BXwXFeRrTy5807BQiekTt6cpJCT7m1us0OujAEE+hQt34pYn7F8D9AXseP4RNv8nVq
	 6lxT4rKE0UbgidA6ohUweAF5HfPv3m8sXOYNwen/UZn7GmwXZSfDYxC/jmwm3LfHK1gwb
	 iR32env79FWzH9E4qME4XCyV+CF8EtJWzh+Ac6x3IAKrMnqTWXpZSapohl3hYoY32eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4CELQh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307A2606D449;
	Fri, 13 Nov 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A4CELQh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE0D1F000C6;
	Fri, 13 Nov 2026 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585527;
	bh=63PePifV7ql9R6Nl+1f2RcD+0Ohy3fainJfJ5wogyXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4CELQh22w6MvpQflj7RrKzEkh/NC9RDqXfnmd42sxk6fypyJx6LyFdQQwb6nXg+Y
	 g7R7et5Zhx/nAvghFaOnZe+17I5qwnjQAvpzkJ9W932b8aKf1hlzcb52ZDxjJtra+Z
	 rIkW1jZj/zgwsANvy9REiPJQsO/QbvOvxRddf++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 169/507] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Fri, 13 Nov 2026 10:47:53 -0500
Message-ID: <20261113153800.204911065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index e6d31d3676980..6ce5da37de03b 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -215,10 +215,11 @@ static int set_target(struct ccp_device *ccp, int channel, long val)
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



