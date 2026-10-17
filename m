Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FB36F90C;
	Sat, 17 Oct 2026 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255820; cv=none; b=bw9LniEm6MFKr/GQtMu9sdBDJzjKZDakXhPIYYbyjarSnZYTMAhQtqbmEiil+14vkgAAlUfAG9M85a/gfIOAWQVII/fd1uUMwr3Q9sRJP5VuycXPJlB689jTtnqJ0WPt+3Va007dXXn7Sv15t8Gt5eEryXYC9lQbXLqB30nQz5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255820; c=relaxed/simple;
	bh=P4NUGqtvdbmeXxVB1iIUQ199CmhRt568xAVRPz2tW7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZfYulLujGmSZWGtdbI8RiZkqhFcS6sogqbIevclMGkjyvyjQmqizD17FRunAThBEbGWtYd+XNCRl/i5vTp/qYgVsFbYo3lp4MC+Y70OFzHEdyDV+xeYF6sp0bI5tKxu85QtbnFbYMlFQz4z41lwlPQHxhBuJa1ZhgHMvPPA1Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6p2DdW9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6p2DdW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D8B1F000C5;
	Sat, 17 Oct 2026 16:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255819;
	bh=j3te9VCpXwYTsBgOYcOiX4M2LsfKheOqb4JY2jwMiiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6p2DdW942Sb8HKVMyMmtLxpkjlTS66iKr+ztTHyxd98Qa8dUyh6Sa4/vO7iRfJRE
	 U5+55ehahnQNgMYVL+Lg+qxtQOU8pV/Q+5YWIqi48EPY7TjwPPNOxjRJ99y/B5WKur
	 ZIsfjIzPnPKIsHb2K+oj/3z+sRVoxksCA9WgUrkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0033/1674] Bluetooth: btqcomsmd: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:38:25 +0200
Message-ID: <20261017160431.989046233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 4a62832f565c950d645a4f7b199a0a7985815940 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: f5a427b16e45 ("Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqcomsmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 11c7e04bf3947..88dbb2f3fabf9 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -197,7 +197,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int btqcomsmd_remove(struct platform_device *pdev)
+static void btqcomsmd_remove(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq = platform_get_drvdata(pdev);
 
@@ -206,8 +206,6 @@ static int btqcomsmd_remove(struct platform_device *pdev)
 
 	rpmsg_destroy_ept(btq->cmd_channel);
 	rpmsg_destroy_ept(btq->acl_channel);
-
-	return 0;
 }
 
 static const struct of_device_id btqcomsmd_of_match[] = {
@@ -218,7 +216,7 @@ MODULE_DEVICE_TABLE(of, btqcomsmd_of_match);
 
 static struct platform_driver btqcomsmd_driver = {
 	.probe = btqcomsmd_probe,
-	.remove = btqcomsmd_remove,
+	.remove_new = btqcomsmd_remove,
 	.driver  = {
 		.name  = "btqcomsmd",
 		.of_match_table = btqcomsmd_of_match,
-- 
2.53.0



