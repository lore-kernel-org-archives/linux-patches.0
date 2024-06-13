Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15131146D43;
	Thu, 13 Jun 2024 12:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281378; cv=none; b=tpwcRHuYayswbd8ng38VQ3/H/d4H25JzmLYaUArS8nj32Cj7hwFFlsfUUj/G99+uMp16Y/43bn2nX6dvr4WBkeAPS4WSqumy/IWZR1UM9qbjXJn9NBm5Y/0e+mwzrDiJKvKtxDIcDb0OuFGgJDZirWNAX0nOZsB0h5Hj4ZedNUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281378; c=relaxed/simple;
	bh=Y6OXytQb2Lo2wF+htNE15z8JKblRJYSKjQ35HagkBdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=absqozh7ZAVa5YbvdzlaoejKQK0rfChRsBFwT91ypJe8vPUG9X9ysKZJKAnYALKicJV7op7Cp/gVa7IVu2FODRScXv3I2iGd9rG0as//FvBElOBfjNxq3tyBj0purqLqMN65FdyiVvXKD/lbSYdHVhPSS0AVQkodHpxW4QH8uRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kgZ9Vc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kgZ9Vc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B447C4AF49;
	Thu, 13 Jun 2024 12:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281378;
	bh=Y6OXytQb2Lo2wF+htNE15z8JKblRJYSKjQ35HagkBdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kgZ9Vc2Q2nINnoW2zuqQnqfIe77FQAMz2zqDUSxo5d0j6NIm8lD0jl7NYK5o9gdC
	 IHLGoDVjc5CvKVMWb99sRxGm+Ne8gT+bmv4EcHWQmJRjzon3tXvgMkCw6ejRqPl7Og
	 MabnOG+P3WalvDOvThBUU0TOGdlyG36xx91TIo/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/317] Input: ioc3kbd - convert to platform remove callback returning void
Date: Thu, 13 Jun 2024 13:33:32 +0200
Message-ID: <20240613113255.060736154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230920125829.1478827-37-u.kleine-koenig@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: d40e9edcf3eb ("Input: ioc3kbd - add device table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/ioc3kbd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
index d51bfe912db5b..50552dc7b4f5e 100644
--- a/drivers/input/serio/ioc3kbd.c
+++ b/drivers/input/serio/ioc3kbd.c
@@ -190,7 +190,7 @@ static int ioc3kbd_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ioc3kbd_remove(struct platform_device *pdev)
+static void ioc3kbd_remove(struct platform_device *pdev)
 {
 	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
 
@@ -198,13 +198,11 @@ static int ioc3kbd_remove(struct platform_device *pdev)
 
 	serio_unregister_port(d->kbd);
 	serio_unregister_port(d->aux);
-
-	return 0;
 }
 
 static struct platform_driver ioc3kbd_driver = {
 	.probe          = ioc3kbd_probe,
-	.remove         = ioc3kbd_remove,
+	.remove_new     = ioc3kbd_remove,
 	.driver = {
 		.name = "ioc3-kbd",
 	},
-- 
2.43.0



