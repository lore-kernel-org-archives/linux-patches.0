Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063943;
	b=JL9ajemo2vJrRylwiyko+AWBEWOSsp7sYsRc12BzfOeO+ygkA6MK0y8oEnqhqzSIKiMy
	 PKLFgkptN6wMBGalNlARDpTHbLtgxgIOy/jm3lOW0SilHZVsI/oHyX+JRwgaUnigcDYF5
	 e6E2NIGVdEFxjEKRG/LEiv0EGojx2h/esHk/BdEumwb39iPK3mfIE+VpiC4E3mg++6wrO
	 8qvIXDr1Tpavr6+AxBrIV8gjFXY+tgAONKB5Z52EwBuoPA3U+j82pTIyMGBKJ08OqVx9L
	 0NVvWMA3SG39Q4W9jRMnYAYFvBO7p4PpguaoNk9IRtZ40Tmo1qiH83ZTVMoW+Rukx0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xh0oY3a7usvzQojfohV+/H/SCGn1MC1ht3+Rqg/9fhE=;
	b=NIz6mP+Jk4KN2YD0wX+8pxSDs+ltt1TCdSjy6S4FgJk+KmibSLf6gJQg73AcNwID0Bro
	 ohGgm/vMFQIDR4nlutnFh8kdJr5awbQnhUvuBrdqW4DMm2uucbL9nAX7PWcVFa2Tt9joe
	 D2XVrgsH2nL5BIRH5bvPPdgFehLc/2zGcIvYkJxJSPOMj7PT64dn9UXYsWqrbxNbAmXnE
	 9X1idakP47f84tl68EaSVwfeB8GWUTbqrDTa3by+f1rbLm4Jk7iOOtg9ErSXsVNv9RFAu
	 tbZ+MerjezU4nzIe9ufNH3+QkZ0VW0mDEvEo2VEQQRZ+iLZcnGTkcjIr9rJxlofvjhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbeuLxXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC503606D829;
	Sat,  7 Nov 2026 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbeuLxXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6071F008A2;
	Sat,  7 Nov 2026 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063942;
	bh=Xh0oY3a7usvzQojfohV+/H/SCGn1MC1ht3+Rqg/9fhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbeuLxXs1i1heUulApoVchk8egyUhhl1MpsHPxZ1EoF3uTRLBksGEu+AshrdedLqs
	 jsFPhvKubuIs613/Ebgs6KYoUaBUXizzfwfhqFsn6XVbpBrHa7AHTK2JeFQdDj7RzB
	 9gv9ju/X0IKScxpDcFhvm3kDL6XEkUomfObh6vqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0135/1257] power: supply: bq27xxx: synchronize work cancellation on suspend
Date: Sat,  7 Nov 2026 08:40:31 -0500
Message-ID: <20261107134943.042760035@linuxfoundation.org>
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
index 01c9ec1116fa0..4d4809a70b622 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2291,7 +2291,7 @@ static int bq27xxx_battery_suspend(struct device *dev)
 {
 	struct bq27xxx_device_info *di = dev_get_drvdata(dev);
 
-	cancel_delayed_work(&di->work);
+	cancel_delayed_work_sync(&di->work);
 	return 0;
 }
 
-- 
2.53.0



