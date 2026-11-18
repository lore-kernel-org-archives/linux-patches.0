Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053658;
	b=LV4HlK9s2UqPlRd3yGPqJORIVnf5XXfH8Mw1beARAxtCNQPM7aHAjtEXeUcN8qPsrQ5A
	 0JFYfY2rxYngD3wpAPsVXk0fIC7pqIhhjGDCOJ77Obcz26m0jVbBlCLe/hI6o05EiRO6y
	 TM2m8rnhKCdxfgUHamq1CBuOw+DOkydBxHuYO1EbLO3BP8lKBMaUXRqeFoJKqmJidmERD
	 uR7rF4JWTnkSucryx4lSAQ4m2QG6jHU0Mt5q1PdiMOWKW/cn1vFBCSeRPRMuX7BbArlfJ
	 ZnwZO86sXV8CYSMmnHEo3fzArY73gyuMEhi6iG/yZ6vnXIx4WBgrbimQo9hg0S6LHZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5LmXPPML30Ais+WuEAEoOWEPnuhD5+Hj7aCvDxc42nI=;
	b=32IR0QKhRllqgPv/kKcR85jPUUNoxYbQmhGlZEgy7N47ESnfi/JalcVfZYG7k3t6BdCV
	 6V68679H0TYw4HnTdiBOBAo8dFzJTaL6kjMTx6BUrmsn7Ii66SG6RyXlbnw3J6WZtWc8x
	 BU6ZponG3yN5fl5pmJ8x4WMEjhVxVCLMNo//1fwu1zfD05wtJ/xNKxIGC+lK6O1mNPtMQ
	 A9OFUXFRcc7EA4YinTCO7YrbxnpftyuJyFCIe4iXrQJqhiXZZ68DJPeN9pTpT0Q0307PT
	 IKw1Y9Dv09zo6r4VbMMG4bBeqjzGecCbJo8RoqdX60kHFXS/y64gi7B9AzztNM2HDrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBHBPjGc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E34606A325;
	Thu, 19 Nov 2026 02:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBHBPjGc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620B51F000C4;
	Thu, 19 Nov 2026 02:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053657;
	bh=5LmXPPML30Ais+WuEAEoOWEPnuhD5+Hj7aCvDxc42nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBHBPjGcCqa8fHUjU4+08LdH8SdSYezRBoiKW5qO2k8kN1hTSQKFL9zsXIMauowZt
	 cU9qpfMjnAUq600kBKkY5Pf/xCvysU3LZHWSjlCqbb30ukGnRU0QBf6Z2SZ0+jYwlO
	 42Qld4LC+MYYAKOkDrYebg9thTxxm13mGtL3dE+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0997/2214] media: i2c: ov5647: fix power cleanup on remove
Date: Wed, 18 Nov 2026 15:44:33 +0100
Message-ID: <20261118150052.273379386@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 6e81cfc38548109021ab761b94ecdd01f8753154 ]

ov5647_remove() disables runtime PM without powering off the sensor if
it is still runtime active. pm_runtime_disable() does not invoke the
runtime suspend callback, so the sensor can remain powered on.

If the device is not already runtime suspended, call ov5647_power_off()
and mark the runtime PM state as suspended.

This issue was found by manual code inspection.

Fixes: 089b7c70f0d8 ("media: ov5647: Use pm_runtime infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ sashal: adjusted context for the int-returning ov5647_remove() with existing mutex cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 9d28f1c81d444..35a8b03e3b94e 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1460,6 +1460,10 @@ static int ov5647_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 	v4l2_device_unregister_subdev(sd);
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		ov5647_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 	mutex_destroy(&sensor->lock);
 
 	return 0;
-- 
2.53.0



