Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036064;
	b=G3h9FDOyROehK4Zpl2rZaXfryuwwG+dmJXIQQH5T41IyR8uwXH1QN6Ie84pvI8vVpR1d
	 C+1AM9jWNIi7aorSLT+iAkhFP8AEt8BcBlBCgSdBLtO0gNGU7826ReofhQc8xcom6y46P
	 2hywmQitaVIUgOyG1yl4RFcN0faxavY4aXG544CMHL4al2jR1BLgwAs2i7ysM6Uxy42dv
	 JIhAxjRwZuauhfifym5Ss+fWHqxraeiwQDQtp8uQI4nmUIy81fjOSm5aiBWCt/W5eDvnn
	 8ZuMEX+S2X+L3LOp44QsXyNVuZIG+TVwXflvAkdqp/GPqf3eA1GEqnyK95Tf1/jiDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7pqjQgfg+vfLfHl5t6EqoaKvVdIW4bTsTc0sSJz8Aow=;
	b=WLSyipR9Fy47c3UNZK+2B/34A3631PzLMk/K275JwJTbkjl674aKZmxIMq8O91pq7bFD
	 yNZmxhvPYLn+LDb7Mgfws7/8FikB4I/PhuID/BR2W1CusTLTacFFbP3X1JajKOmx9OEV6
	 GOQ7ISWoJOCJHUatzD3mtE6CAs9mY04Z10zHU9jMQjIu9fp2DfiL3uSSD+Myj0rxFRb4C
	 /QqIXjajoP3YFjkCtEZYGu4Q6Ds45H7ziLV4mdqDQoRmjU5W1CGolD7nfgr49vU4AJ0ZR
	 izAhiFM+NRU3p3pXe4JPC27EHk2UaqkjCjZzQccJ81zmd4Dp5UdDgNiuj4kAswAHYgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9i7Epvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF698606A31C;
	Wed, 18 Nov 2026 21:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9i7Epvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2046E1F000C4;
	Wed, 18 Nov 2026 21:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036064;
	bh=7pqjQgfg+vfLfHl5t6EqoaKvVdIW4bTsTc0sSJz8Aow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9i7EpvgEpMEfIX79xzfbZfltcz5iQtVGtwnbI1pKH458/JrFiOClhTyxE4fYVk0w
	 OnuskkPIpkvYnB1o11JkUdn6KDZyPGW1h8+R+B9QbaFf+3NV7xTRsPD44sBKX47oHG
	 HZJEFUUPB7SOLVy6cR+eI95ucq9mBHsccUrWvPWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0883/3318] iio: accel: mma9551: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:25:05 +0100
Message-ID: <20261118150345.852278144@linuxfoundation.org>
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
index d823f2edc6d42..a84fe944883a0 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -516,6 +516,7 @@ static void mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



