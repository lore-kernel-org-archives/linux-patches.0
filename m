Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064002;
	b=4V1Ib64wrkLtb+CAQr34KqASsRW2+IeJDyDN1VKAhPVQk4iIPYJAh0RU5vsz72R7gGrl
	 6tE5IvMgzC47v0LadLuSegsrXfOuvkXiQd1LF74VFe60UVIZ4oa3zrTyio5yItSOc6mc/
	 IGX9kdnDdsjDrSpbImiWUtI2+VwY6LHAPtJ9Ry1AOQDo9hG+7eppPEw0yTUVgamTrm99X
	 FnI2+QVckoWABy2Ua7A+bVPnRaxAVxMSdOxNO3t3uX+IOPEbBO/QYg4GDliKoTvvXlcRY
	 P4rLr4AAzi/KXhYRMLqlCA05j9yME67ndePQ334IjIVzgNZda9XGwboiJVeW6VjuvSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRh3aeEyDNONsh3ISq9FG5xRlGcRNgczgUJz9nc+3Pc=;
	b=l/vDZnEha+7pcmfu1NA8svnXNzmvCzlTDE8+JvXiB/Evz52adkLzF4nE2EYxBtgsJIn0
	 pjHkVKF2p0fVqOZIu4zmSMHgdbmDts7KiIrefwvNWIwmOeE+hWxk1sD04OAkSR3iDq97F
	 PVJxWHqAtDd2V/LwR0fbq0E3IiAGppCcSGB1VIhS/HSGqnVz2TlaahjCwlhXpJIsrb7hY
	 aPCfIqrc3OfD1TnCqGBYI65uluB0JmWEajj9F4HfcNn4CjdFvtRJpoGx0GskkGhuQg8Mm
	 TSE6npAnHrLdtQcR0xthbBotn8E0TezWKXogup4VzG13NREqTRrTQcCLaKJVeVs7S8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BoeJWwIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5214E606EEA3;
	Sat,  7 Nov 2026 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BoeJWwIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0023C1F008A3;
	Sat,  7 Nov 2026 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064002;
	bh=YRh3aeEyDNONsh3ISq9FG5xRlGcRNgczgUJz9nc+3Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BoeJWwIxnACAIZIkAzFGhpVYSGIxxtcHT9XVdJiywgMcP4WMNs9EIV4B2L+uaigzc
	 FjTpisT7Gu69HdP3KJbnlnxoF33jrZPrYmSbb5HLzj6bFyBli5HVlJkW6rZ55CNhVw
	 eDKHbMgEJcONg6RfdApZjVhqnJSq9x5GLeh40NX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0183/1257] iio: accel: mma9551: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:41:19 -0500
Message-ID: <20261107134944.507872144@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8061720f6be1811478914f8b6143778d70f6033f ]

mma9551_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 6da93a6710a3 ("iio: accel: mma9551: Add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index 7e01427fd9c4d..182f488edab1c 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -500,6 +500,7 @@ static void mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



