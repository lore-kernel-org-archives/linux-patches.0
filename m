Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061970;
	b=FfsaKHB5fRLk1znKVF3Ud1k/4ULHtdsMATmcselnPI1ui0Uaq8GMg2361S96wj5fGles
	 VdWCV2ynpHCVvyAP+Gf1Wj++f2Et7xF0e0chE1anJZHVu8hf7YE01KlIT4WCUdmEfJPPc
	 IjYBzyrSH1u93CKDrH1s9yGwi+t+E3eUa54RoQ+wkaHJt4bLzPOWA+JVU4kaJnOgtVzI+
	 2KeDnK5svASOnljXp7GUIjPPZm7mcJ8i9K1oTaxBTp8dGjR5UGgORvivFrb49vSVn+HU2
	 Aopxp2R8Vut1M3ximDWi5ww2qCTgrBLbk0c4241ebbOy3eXcWI1lVJqV0SPkacYKElA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4vNBI7yno6pj+YKxA2dcojZ94uxRO0KxsC1tBnJ4vQ=;
	b=4XyApRTbKvMGdrKeNa49cjoAm7tuoM6UJNsJbNWiiGl2m6nbtcLW3+7avb1XP5NTc2X9
	 HRjskNb9QmDU6SsPsKcIOLhRgbpeU3nkhMFUcq6auXh5YnmQAAcBcKUMNZmfXLo/GJwxH
	 GPbkS8aYeTUHqomXxyNcoBpbaEcIsdsH7FKxnWViZKZphJekxMAdDlaeD6LeaeXUBshrJ
	 6o4uwhUv/fk71Iw9s9zTFIq0Vy2E+N2aziPavtE1qgjQ6mncvDaYxM6peq1d3PFqdPp06
	 V4LxWLw9WbqyLHfPwoOhc0hQL7SReq7NZEx0jkEsHNGz57h8UbE5ePPuCU25jwEEBIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEoWhCTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846E606A32E;
	Sat,  7 Nov 2026 14:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEoWhCTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663B11F0089F;
	Sat,  7 Nov 2026 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061969;
	bh=Q4vNBI7yno6pj+YKxA2dcojZ94uxRO0KxsC1tBnJ4vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEoWhCTNSmSlylk15ig4ke3PhJRg7kKDQNo3TFp5+fSZE2tNHZl7We4p3IrDRsZ6w
	 kiU+dr+//zXsEfMbenguHf9fIZLzeQcvKNT5vSCtXvQQi48Q1CfeusLpFiAWthWYNv
	 5rQcWqxiFXc4Ky/c74musmwnsh/HiyDeLqbcZxLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0966/1536] power: supply: bq27xxx: synchronize work cancellation on suspend
Date: Sat,  7 Nov 2026 08:49:42 -0500
Message-ID: <20261107135024.782540821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Shengzhuo Wei <me@cherr.cc>

[ Upstream commit f0ff5673aa07ded2bb383ac526c1faee4fe9ca07 ]

The poll work requeues itself via mod_delayed_work() while the device
is not removed. cancel_delayed_work() does not wait for a callback
that is already running, so a poll racing with suspend can keep
issuing I2C transfers after suspend returns and requeue itself into
early resume.

Use cancel_delayed_work_sync() to quiesce polling before suspend
completes, as the teardown path already does.

Fixes: dfcb264a01a9 ("power: supply: bq27xxx: Stop and start delayed work in suspend and resume")
Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Link: https://patch.msgid.link/20260827-bq27xxx-suspend-cancel-sync-v1-1-77a67711cbc3@cherr.cc
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index fb16354fcb975..19c73aad769a5 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2225,7 +2225,7 @@ static int bq27xxx_battery_suspend(struct device *dev)
 {
 	struct bq27xxx_device_info *di = dev_get_drvdata(dev);
 
-	cancel_delayed_work(&di->work);
+	cancel_delayed_work_sync(&di->work);
 	return 0;
 }
 
-- 
2.53.0



