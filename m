Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591092;
	b=UXekH3wUd1vefGx3Yjs1MVvsg+b3DDkaGY8PNMWpGi/AXw4RqIbiuH/0ybpMstJQ7xZY
	 9DRtYbT0sjxXUbMxZmsWLyj0dd0YE34bR8AS62ZkFRj7tSwUPnZX4uqmdnxhSgotZ2laj
	 a+dUr1VoYoH6VEtZeSCb31t8ds48lxfCMORODemJSXIlVWrSJ8iXSy7b/29dgNihrSMaw
	 Rv3WFRWvRsJjfOqXeh2IzFirfcFwUXOM3sMGDygItDZZ7+I0LTNdVZMNoO0EcI0uq2fTV
	 m+chmhnum86bOfB/pYkt9gQmxKAFfYuoUNlKtwxN17KYufmPgeGV2C1q4W7hYNzn2bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmQeNPJQkd2U7eTdKKiZHY8AdpX01kbUnxDBUA+HVh0=;
	b=NcQv3hUqXkcQWv9HAm1+BxBBxveKdqvRgc+FiCYzSwe8utsFB1XoRIKDtAxV3ianIMpo
	 pGQ+aQhyJBxltQs0ahgwMspYradXxqnU96tmj0sWfdZ8/nwcmeqjFUKQW53TgJtw03Edw
	 LE59j9jz2U8sUZNdddBZVBk75jyK1RGtmYMWiUgwzNag9q1I0LY/a1rGdRYKNPe/Bacgz
	 eMMwhTcTach8oCRxGCYG8n0zis5vAik83epvgdiMzr548IfC49VxcIoRp++XNL2tFvFs4
	 3Woh016snE3oYhpj8pCuKDUCrO+2VAjPsGdeKb5llkzmKR2rU2JCVFhLrRSeEn3Cr3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgJcA+oK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937C6606A880;
	Fri, 13 Nov 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgJcA+oK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A701F000C4;
	Fri, 13 Nov 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591092;
	bh=RmQeNPJQkd2U7eTdKKiZHY8AdpX01kbUnxDBUA+HVh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgJcA+oKqEMPd3wCtYmJi3Rx4nFPZ3tErVjJ8nbc4jgE5pu59IHDTSsRKyPSjt4Ee
	 YfFM1ztvirkV2W4wG5YRYUj0Yvai9c0NRpq2ymBbbmGayLPAdPglO6dGxVthNs96oC
	 9nZ6cjZP3zVrnhy9+r7DlWiuj5q3vYDwfiMQO2Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/670] hwmon: (corsair-cpro) Cache fan target only after a successful command
Date: Fri, 13 Nov 2026 10:46:48 -0500
Message-ID: <20261113153820.113764991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17bb080eb9bb6..1c152a6db3806 100644
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



