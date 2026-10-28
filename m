Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210444;
	b=ThgV6cJB69TXF6rkx5uVAQlxeu8CNKvL640dgDytIwMv7KTX39oOHfWc/f/is9CIWkJf
	 V1S8SUUWkudDLO7QuHgKxDtNH30YOCWo1HYGK+7wX++cIjQncEToLe6/TY+Jcx6+PR7cY
	 wiv3TtJLl2KA9VecemF+J3jR2t4zId0jToq8nJaS3PVWmq7qk3FUwsfPeWc3APhuRhMb8
	 b4zvjO7G0pek8PxK/s71bHjjNTsUAikJQE3oBcL2iADroWfLtz8/VdjoanfzurQZU5Sbi
	 EroNHrZdcz7MJwxlhIPotFQ4iag+M60hp8Lti6MKcwB9asJsDNzV6ulhzpOP2KZ5urw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TUDPBrgGJJ5VkljRDHVzDF9EYpDMQvzRS+udrdge4Kc=;
	b=FjfdXXUtCcRhxck9SM3OltajrhNR8i8CcpmMQtF1vyA7MQL/6/p+kldGxwv6E9ARPh/B
	 3l2ua3F9is1scIVk9Z1F9DAI7foOZeIuLoN51I2A4lwN45DIpBQwJMylvQdAo8SS+ofhi
	 U9ieCBxk42m6+zSNJJ5J+p5hwE+LsnJbL4S2CL2qk60D1DvjJ3N2ZVCOJAmQzkWmmjslb
	 qybIHO1nwXIGhLRqWzcV+nja/K+KV2Ngxjyj5kMSfWL3qp2LLhHrDtclqCZyHtsodZ3j2
	 cHHgi0wNqKdDpvOan2UiNuLSYRiRnI3jt6HazObVyGsmh18T4EU8ngZWQBYz35or1hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTpYVLgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC8C606A321;
	Wed, 28 Oct 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pTpYVLgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081AE1F01825;
	Wed, 28 Oct 2026 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210443;
	bh=TUDPBrgGJJ5VkljRDHVzDF9EYpDMQvzRS+udrdge4Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTpYVLggbd/YWJCwbM2w3izHN+S0sCZLKoc4s4RAqRcn5YkVwkb1fZvrDarK58s/R
	 idCCgSuZK9gSxa8k8egiOhQ0r2P6iiSwZQh0RARH9k6EA/lMJ2IwIAqpqjVxKzKeMh
	 KHokWMUZdRRTwuc2AUxZruJEIrNLlfATTkoU7nlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/571] Bluetooth: btqcomsmd: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:52:55 +0100
Message-ID: <20261028170008.691166390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



