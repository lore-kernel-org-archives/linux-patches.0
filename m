Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038144;
	b=DYUncMiKK5NGzo6m/tw8xH8KwrnCYY6tbk30wwp7+NQeXdwGau5FrtDOzRKtfNhZXj+T
	 FS4AWl4wWA0pxbmw6OYsMVar9EpuyDpmcUz42S+2U0tmJpi8sogLrwZK/wgRUGyHGe6NR
	 vY67WpNmSesbSuqWJPuCo4qH7EUzM2s1CRRICEjfSUNPdyz+NVvxS/F9mvIiyUMOJZqc5
	 2G5EJGsFulio2sBIZru1UrBJ266V5D8eG5WKozkuVvORdzzhZJ1999F0vW3DFYMa7e9RM
	 htceFGd2/XGIw45QSedHBBbTOV2stPFvtwjMldMJbhX0gI+sYuyzi9Eu5Xo+LC2lZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1t8BZEXt+Wva8ql7OibKU9u/si4488/Uu2JjBK8CMzw=;
	b=gGuOxM0hD39qkrtpbbHM2vSz1eWo4/f7ubHivVsg9bnmW0xK1BzNXrt679L8OG03+LEO
	 Pi+kwGdsSyaVaBP0YJfR2SCfCt+8u33TWa0BicCAJQ/Pck4xz4vdn+7VMYEJWiS9Mgb4s
	 Qy2v6wTF1iFTu4XlOhrr1dEutU1rx3/XF3SHtD3MEz1sOgZ6NDxnRPY3O7tbIXe7qLn+g
	 P0TDPro0CRxaoKPylBVeYfh0Ck0ZgN4caFYn/e9pKu3yoYyrZNWisGfSFbaKA/NpeeZmZ
	 f5xjTLt/tv0/ZPFtNKsyV13tS9AfRWOHtGX4F+iDit0c7NJfxv8kTPVc5JQPt8HkFSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZ7ZS7Bh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1DB606A320;
	Wed, 18 Nov 2026 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZ7ZS7Bh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDC91F000C5;
	Wed, 18 Nov 2026 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038144;
	bh=1t8BZEXt+Wva8ql7OibKU9u/si4488/Uu2JjBK8CMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ7ZS7BhF9ZhjvSyjkwTNWJAYt++Q2Q1rBwdOLx2VV6JeB9AmXuZA2edaOGazFKiN
	 liCLf+ID7KdiVHMpeQTmA8kR5FPJNI6jG6zhvJdOAxqIu4boxGmlgmFwSRCMtK5IPn
	 3xlHKqg8d8XzADwd1/RUxQaZC19HOEMkCtXQZnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1640/3318] media: i2c: ov5647: fix power cleanup on remove
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150410.961937076@linuxfoundation.org>
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
[ sashal: adjusted context for the existing mutex_destroy() call at the end of ov5647_remove() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index b8033fb7aa30e..66add3d6e3908 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1490,6 +1490,10 @@ static void ov5647_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&sensor->ctrls);
 	v4l2_device_unregister_subdev(sd);
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		ov5647_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 	mutex_destroy(&sensor->lock);
 }
 
-- 
2.53.0



