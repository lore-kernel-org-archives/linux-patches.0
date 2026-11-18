Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045032;
	b=WVAxNHWF/QBGC9Sx88vCRFLfWp121SpZeelVLqX8hRrKHdjBpsi6cjjiLx7xswGc2Qdn
	 hp1sFWcRpY86QGjBgBG/Jw+SbEt2LEnNLJV/5HzyLesU2VXuK+Ak8KWDRFj0z2XnGe09c
	 JvBIT9MbPXvoDpyp2Ir77y8tjiSyC6qBij98RLU41fQd+OSKaXAwjETB3nB3MszxI7yVQ
	 GBsCSgPfYMbrAIO38DW+8gv81VFHoCo/EPQXAUyoIV0X/Rcs8Mr903oLkTJ2J/xaXaLDh
	 1Yr//N8vIytblrMtjOnwLVAT4CZRbNMcBoUr9gdk4OUlC29nKaJb0MfxW5xO+lZfpcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSHWyGzGSaDwofHQ5mEHD5HH9BM60waFBPYRvkwyGHI=;
	b=b7dX7ytR/04el7n5vO6sut5EAFnXo2Y9elDWixoFlqL0nG64mQ3EPyGU5Sdy0LQHjIZk
	 rI721ZsJOWvboUPxVxuk6l9ll17nGunm8F5by1A0MrijRxNZL78K1btE4C8kBZEIdiy2U
	 IoH+qq4gQfl0eQeQHuc1voVd/qh9gnRnZGNU9pt7I+QfuEX8orhnqdtA4V4LpX+Cvip1/
	 bU0ItjJB3ome0nhchx/lF9R2aKN0/I18x0JxutvjB7SscdRvFrSAg6B9kZg+ktuA5O9yy
	 VJvj6qRRx7IFojB5ClFc8j9SV7tmHDkhDQnh0TyrXO0F5bzL16Ce/v/5ywrljOe3HDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSzI6UKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1349606A320;
	Wed, 18 Nov 2026 23:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSzI6UKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BA11F000C4;
	Wed, 18 Nov 2026 23:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045032;
	bh=DSHWyGzGSaDwofHQ5mEHD5HH9BM60waFBPYRvkwyGHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSzI6UKbFnwcjGe79qGJ8CfaZWqhzrSvYEcu3b348rOoemm7W2KQokjLBD1VGO8t3
	 UPJkbd/picHE6HC8LQoQBJdkz2G5yLExyh5G2Gbbvq09p2RXRrkkhCBLzBT9hhHtte
	 AR1HZjlBIi+i3PsJ5mWsVpb+18HQR9JZmJ5fKLzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0777/2857] iio: accel: mma9551: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:30:11 +0100
Message-ID: <20261118150229.544784214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7a793f4a8e34..c484866741e04 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -516,6 +516,7 @@ static void mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



