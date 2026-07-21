Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0243F4C3;
	Tue, 21 Jul 2026 22:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672945; cv=none; b=t0RqoFKNLtjKeJsw1l20IF9PXY6PNLxwZnumr/H0FaAsw+Xq/DiEoW3ElFEHQNp5zCvFqBToZ0hVa5sMkdbXhg4oUOoD6GTfCuB9UKba5MJyO/4pnEc5LjxmsZnFiVm6NBVoHGV+M2e2L2QdklIHjTne9s6RibUcA1f5vbtmS74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672945; c=relaxed/simple;
	bh=QPgKjGoaDL0JaQp7Hk3wKbNT9o7gEF86+/6SFmnTz0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uj7DCbmiwEEUWYX7Bh5YihGgablnmE+tmhY9kY9tSvl9jaJ1GhZNZJFJOi0837zr1Hc2H+iXe/AyN8YIoEUXBBvlj24TnuKIAWw2fp5jVwy9K8aEP+iCw5V//euHpZLfd7P1QCXwTU5pxQA88X7LSyeI3WR7YN1FXx1lxu8N3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/PkQRsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/PkQRsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6BD1F000E9;
	Tue, 21 Jul 2026 22:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672944;
	bh=aqvlEZyQCv0aaNDXYr9wsdiHeokQ3VdO2EAEhHNKte0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/PkQRsp2Cf6oNi5sKxAeZqMrwzRxtDX/wWuN3TCD1a0DiCAn4Qy4HDhChJQxxJmW
	 O/Uv54YHi/YTT1FEoavYTzbsmJe+xZ5aeSKdMa2phHL2nugl+N5WlAf3YYoc0+ar8D
	 59Lv8cqFa039GraMt3XFUaYZ0NwT1A8wq5KsW+Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 814/843] drm/i2c/sil164: Drop no-op remove function
Date: Tue, 21 Jul 2026 17:27:29 +0200
Message-ID: <20260721152424.385373599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit eb09882d64807c24228ed1d005dbbae70860ca3f ]

A remove callback that just returns 0 is equivalent to no callback at all
as can be seen in i2c_device_remove(). So simplify accordingly.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1f0bdc2884b6 ("usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i2c/sil164_drv.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/gpu/drm/i2c/sil164_drv.c
+++ b/drivers/gpu/drm/i2c/sil164_drv.c
@@ -370,12 +370,6 @@ sil164_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int
-sil164_remove(struct i2c_client *client)
-{
-	return 0;
-}
-
 static struct i2c_client *
 sil164_detect_slave(struct i2c_client *client)
 {
@@ -427,7 +421,6 @@ MODULE_DEVICE_TABLE(i2c, sil164_ids);
 static struct drm_i2c_encoder_driver sil164_driver = {
 	.i2c_driver = {
 		.probe = sil164_probe,
-		.remove = sil164_remove,
 		.driver = {
 			.name = "sil164",
 		},


