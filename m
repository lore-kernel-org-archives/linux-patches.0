Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591365;
	b=Mw/fJP4ivhPJUuhiPV2TSeYkKerzj7YoL0OW1gaW7+TjaUjYOd+B+ysgE7FX1g0p5eyp
	 +8J0w9AdYE/xJXn2wx9J09GuhGlR8KifSpW9cSyHrZZwnE3+FGlfGCLEjjXID63qvkJt0
	 mPah4bAMOYwDDLZr7NYgSl6EBi9Hzd5GtctJsSWhEsowFd7oO9mFpraG4JwcOqoAFBa+N
	 KG9EElSc8l6Ze/h16yAlTO+wu0tXMkPQQ7gE7XkQvNv41oLaO+Rm1BtZLirblOLNSgzi9
	 fxzIL30BjKoA+nXgbwYsomEWM2nsUYudnb/ymDOgMxr1asl9Ii1wOotgEYtrOLCA4sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=banU3WJI6qDdbjuUFBEIr5aOjo9mES5vnlleKc/YGdg=;
	b=Dy7qN8LOstXsFwrFmWUYsiILj6TIZe1yHrhynD4J8j9Ha8pjbb6PqAr7/b0ewJ0RBr8D
	 6hNtB3XP3m8TTgw5brfYdwPNzuh36O5PxS1dHejHooY5y5Ztgyd8QWm2noukIMMGv7hjP
	 bP9Sm3Flwjo9ysVypA9cGbtQZYrnY7G0Y7eo2rn4cNf+2+ujg9XXHPiHQq7eA0J3LLuaW
	 d8nPEOSA3fDnU4itMyMVFqDkuuvEtk+dHSYRBNa4VbALRezUpwRADl0fyaJOg6Ln5pVoS
	 z0UOcP5DnrtfdQVJ4Q3o7j0erDXjM7e/d4tDaKAS1QrVEMPZ+qVJV+6auAmPbbP/Xpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui5YjbOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A06606EDA6;
	Fri, 13 Nov 2026 17:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ui5YjbOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E271F000C4;
	Fri, 13 Nov 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591365;
	bh=banU3WJI6qDdbjuUFBEIr5aOjo9mES5vnlleKc/YGdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ui5YjbOBRse0PGHa9sPP/RU4QG2PxFDCNNHeL6X/MdTfPAWqxSO4C1M5hcM0NTktL
	 8+/SUI67+yoQ9t4+/LgcqeRDEABK0N/eMa3DM54mms32cX4wdmobFMHqjMDSqbfWwy
	 LQN5kSkcusKeV6TXxKS6HHz2hiHcv/kHf2S4yoAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 467/670] media: i2c: ov5647: fix power cleanup on remove
Date: Fri, 13 Nov 2026 10:50:31 -0500
Message-ID: <20261113153827.799560532@linuxfoundation.org>
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
[ sashal: adjusted context to account for the existing mutex_destroy() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 305677913a0c3..3e7fd8f28df3a 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1481,6 +1481,10 @@ static void ov5647_remove(struct i2c_client *client)
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



