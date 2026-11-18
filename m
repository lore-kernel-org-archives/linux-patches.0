Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038526;
	b=DxbA/U+r3xBM3tKE3I4okK5cISTdhi97sSRub9NS6ekfoeCytEmym4hDbFBthchQBezL
	 gWIEGHmVzrClq1kEKqCrUw/IUo5tj8QqAe5QvSDoOfCo+Jvfq+cOIx4rYGxxSF9RydjRV
	 hfRFh3dzP92oi6Mb8Ft61HmCZNdafJhTtGSfSMOIzwvP/Ru806qZLd7lATOOt0G1nN4r7
	 oQ5p9tfCv69zN1w7pmojJI+08Er1HEadw26YqohTCkJOkVZCgAuQZ2aU0oWVpdhYpp5/X
	 vGEpBrgaB07nhFHDuRQwNW/yX8FeXwE597mAmyPTzcLQvgjc1oNso/ODjb1y3ayt8RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N91xi278zLV+GuOxXs1V1frAy0sVOK9ZMjL9skUMePI=;
	b=vAxcKa6HUgzZj2TChC3W+c8jpX0WXU+a1cd09YtuL2DJ0UQu5m8TQ1aic89jF5jFnJj8
	 RpzlZU175s7Ne/jhRINhAm636FWEEPaUBZGoaeWBO0FHCgemZtguMXWbXORptRdDH/P6r
	 U3yn7NrsW2+n3BhpmU+Ofe9tly69eqhJRs2mUTr0pgWCB8SvW/tYn7bmu2wANreQUpzNA
	 8M82bB1JPq7BlnCqKFTBhpUPVpRF9xg96/EZql8u2a5Txt3helfjMWWfK2GpxtdxjWoD9
	 xnA8eIfdzWOS35pis/f0p3VaVyoiFTZWtwN9dNovj9YEOgJILU+rPsFfhmp2nI8MTOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNWXOODg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ADB606A31C;
	Wed, 18 Nov 2026 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNWXOODg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FB61F000C5;
	Wed, 18 Nov 2026 21:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038526;
	bh=N91xi278zLV+GuOxXs1V1frAy0sVOK9ZMjL9skUMePI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNWXOODgyEEty+O7r3divNiOECLqUPzgIsV+yxLRi68cCljoWP6zAzeWVf96dzgdR
	 3HU+1etT3IKR12KPITlTSuCjkj/h3uQHTempqBWt6BTJKhlVS/ig7/IvA1Nn7MU1DD
	 uxARm8KRZpSmSC1ba3OK3Cuh6zCGvB5IgJheDQ98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1773/3318] Input: matrix_keypad - convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118150415.050028524@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit af90388a598d39584283c18e4047124fee8f1801 ]

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
Link: https://lore.kernel.org/r/20230920125829.1478827-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 1527451f87df ("Revert "Input: matrix_keypad - force switch rows to input mode"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index a1b037891af25..50fa764c82d2b 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -549,15 +549,13 @@ static int matrix_keypad_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int matrix_keypad_remove(struct platform_device *pdev)
+static void matrix_keypad_remove(struct platform_device *pdev)
 {
 	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
 
 	matrix_keypad_free_gpio(keypad);
 	input_unregister_device(keypad->input_dev);
 	kfree(keypad);
-
-	return 0;
 }
 
 #ifdef CONFIG_OF
@@ -570,7 +568,7 @@ MODULE_DEVICE_TABLE(of, matrix_keypad_dt_match);
 
 static struct platform_driver matrix_keypad_driver = {
 	.probe		= matrix_keypad_probe,
-	.remove		= matrix_keypad_remove,
+	.remove_new	= matrix_keypad_remove,
 	.driver		= {
 		.name	= "matrix-keypad",
 		.pm	= pm_sleep_ptr(&matrix_keypad_pm_ops),
-- 
2.53.0



