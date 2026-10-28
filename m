Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208181;
	b=Vv1gznzMkzO1OGRJwzXnP4+rgMeBKMXQMVU5uHhGYI/D8tSrOGEsGRTDzbW+a5vFM4c6
	 nKqLGxW8U60KrMjP4YGlH+zrW/AtLrUZaGTzTuFCexbHC6S8P65Xd4HJTpMQr3UyQCnaC
	 aPvBOgpUD/lG4lq8qWwhJILrCXm4kl0RQt0zBY13oe5zd6XKdTMf19/SCIvYnSXY4/Ttk
	 AE1HHHlAw+rkF2fa5ZNV4CoPMs9bNyYE3m8XLFoSkNu/gqlJjQK4dSbWIknQCGBGJ3z2O
	 jYWwEVaVH3EEBI7ieuRTigoQAa/31se3IJcQFJGM2hvCwFOn2hDIo0Wm7UEFv4QsMzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=E4Rhvkm9h2zKKJ7qtH+5ceJMa7DZmDU7ZPJCw7FqKaY=;
	b=a80Ca0+4+JE9WemnRup/phIRJmERn/1bm0jlVyq8GJKh1LkoUFPRf6UiaadI0meLae/i
	 lJ8T4aNbAzGNg00nv4sDVtw/3Czl7u+3pjcAdg49zUr9REPYO4RtUUb6TFAm0ltiyuecy
	 J/W2IGD8q6Hhw2kXrwTeUMt3LjRScOMjg+OrnMbmlZSHSOopEBDBsYdtzZSq587jDf+xg
	 JeJTby1MneX6bu4XDdJPvWiE+ZkpVkdjG/RqFsYRgEe9FGnq4gzbDx2n4eF72DmhRZQ4I
	 Q0MgGvjYzEP2QaNnwCulThoXc6F1nSxvQakNPxlb2B5sYCUaVSjsyfyAzsROmWzLO7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAWPAkBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5DD606A31C;
	Wed, 28 Oct 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAWPAkBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091B21F01825;
	Wed, 28 Oct 2026 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208180;
	bh=E4Rhvkm9h2zKKJ7qtH+5ceJMa7DZmDU7ZPJCw7FqKaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAWPAkBPkfcC/mSPa7g1YNSsnYM0O2lFID4fidSKGmEMs0YQqkcsY5VSys0wmOAhL
	 UZNzKu4a7CVgNANNQs+dzlR6kEUkjcgG83wzMRSgveyrWUJE7+uVRC8IspdKG/S+gT
	 OfRoBBdSG4gCt6BtOwhdlvvWeaIiGQ0dcB+6FgvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/516] Bluetooth: btqcomsmd: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:53:01 +0100
Message-ID: <20261028170004.217938543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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



