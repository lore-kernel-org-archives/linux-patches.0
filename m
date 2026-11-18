Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048289;
	b=3vN3sb5WRByR6ZO+csf/5Uxh7AoGHD1otSEpnL22+9T1fXQFCr4q+pTZRqmCtOEJCwCc
	 4e2BMQSBuwVRrmNABuU51IcMxxwF8ibc6d43N1i2Uo9RdeosNRZIj3FM6DutoMWe6dXad
	 EEwGA4ykd66oVnrR5y8IRfSCa3CWYmq+NoN8RkRTtt2yNZHdaAoF0ik27qyVap3PAGIGQ
	 pzplNj9MyEgFpfUHbKgfskzCm34p1tNRYzjKkKxo25eZgYhsJwZxtBkVLIqeYsruCCpC+
	 TdYvcyjNN/M5hfWixNi5LGYiVifKncD3B6tMu1ucZ/04OVOqxdXjD5/BRPPcbht1eGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MxUYijrPIulGMdjl68E5/71aP/nSxW2Y6lLzDArOj6I=;
	b=usRtr2bf7L7s8658kfkQO7MfEY2TjMNAeas1ZpTgrs4H1cYGZb5ZaYHQuQQoNPMYjn77
	 KSCR5KHRtPAtL+I6JDwYmuJf+Hd4CSwoMNERBCljOA2VwvRw3WKRF6ZguO4GXVTIJM3Oh
	 Ms1lO6M3OcVkBHhSDgn57EeTM9qC5X0RkR4pHH5p3UBbBfi6cO/yYVTyGVEgy+pGzDmWP
	 707Amqa5t7obOcr/61uUxmy95gCMxQu4ZCZPbcWwGjOmKTGvCFu4AE1JmJOwpf0pCnfOB
	 92DJ/B0ymofj02s/L8TCe9pn3j2/27UlsXa/Zy3voJYsPIgDX9PLGwgyQirGz6h49Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ulj0HpH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234C6606A31C;
	Thu, 19 Nov 2026 00:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ulj0HpH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352781F000C4;
	Thu, 19 Nov 2026 00:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048288;
	bh=MxUYijrPIulGMdjl68E5/71aP/nSxW2Y6lLzDArOj6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ulj0HpH7EL8OaMsQ+FHktlXgPQYsNoYVvv8IZYnGmFncjokgkbNK0jg6e1zeDW9M+
	 8dn/Rkfp6wvp9POG0N3+4m0U7n7o3+UbBLfVIaKIH3xJZRhlbgG4FyvAXLUoKAO2Zt
	 ry6ng8eAd5xw7+6eTKUveS+47WBC6QBMUWiztmYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1939/2857] memory: emif: Convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:49:33 +0100
Message-ID: <20261118150311.027965090@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit c8a53461990cb697ca494d6671fab9e196d20ce4 ]

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
Link: https://lore.kernel.org/r/da2fa8d040d542edc1318aeae5117317bb22aa06.1702822744.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 314ef67d6732 ("memory: emif: fix device_node reference leak on np_ddr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index f305643209f03..434982545be63 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1159,13 +1159,11 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	return -ENODEV;
 }
 
-static int __exit emif_remove(struct platform_device *pdev)
+static void __exit emif_remove(struct platform_device *pdev)
 {
 	struct emif_data *emif = platform_get_drvdata(pdev);
 
 	emif_debugfs_exit(emif);
-
-	return 0;
 }
 
 static void emif_shutdown(struct platform_device *pdev)
@@ -1185,7 +1183,7 @@ MODULE_DEVICE_TABLE(of, emif_of_match);
 #endif
 
 static struct platform_driver emif_driver = {
-	.remove		= __exit_p(emif_remove),
+	.remove_new	= __exit_p(emif_remove),
 	.shutdown	= emif_shutdown,
 	.driver = {
 		.name = "emif",
-- 
2.53.0



