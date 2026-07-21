Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF7543B6E1;
	Tue, 21 Jul 2026 22:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674778; cv=none; b=ZW2S6aCuaZZ35RVxlLJuJRPfjkpCiDenc0SrjjWVtUKz8tQJqQ29UmdgHJK3rZ3lDrLygaK7Eoidh8TMkDOH+JXXax2ZJvF+5LEuWBrhp6v6QwO10+X+7Puxpb3tUwSrcjAwpr6ICNq5tU/0emlfqp+nZ/Hb1KVxpKLfVMFfEdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674778; c=relaxed/simple;
	bh=ZUCHn8X1VlCTqPfUQAqy1Yaw9KgWDP1vA7RiJxS580s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSiwhVghIavt1pXQSA+goc759Eg3kUXmHqyLTKr0eCzp6owbvvjuiDWzlntFo4UuOtsXOxWQuCaIQbLFvKdArDUb2lRrTmEIfpn7GaSxAI3NgMGXkENKhrzmTwg3FESaeVE4yv8Kyceq9eD7NSzY8AWkX8yJ/5K+EGTpiSZbOvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3fRcDvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3fRcDvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9C91F000E9;
	Tue, 21 Jul 2026 22:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674777;
	bh=x70axlcFRn3/Eq2MW+L9+Rm/5lxi4e7UE2rdzHpRqdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3fRcDvo0g8XBryjTZgyM69JpObiFXlqSqZ89J8f6KR6iwKBdXa9KLT40IPj4o3JU
	 GkqRUfLdAAukiIIqZKx3X0b9X7RrDRG4Ktg94xTfs/S2e+ykMdgEWMZ29xGdbFZgjL
	 l3ZbULRv7ek1WpjmEX2gvOANfL9+fD4uMOoMgW74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 668/699] drm/i2c/sil164: Drop no-op remove function
Date: Tue, 21 Jul 2026 17:27:07 +0200
Message-ID: <20260721152410.832512583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


