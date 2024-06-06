Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAAA197A91;
	Thu,  6 Jun 2024 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683298; cv=none; b=llh6IWLvrSbjNmPLJSG0KuPwGhD8PbVpTAgugyesPjf6wwakh9hWRfDVHrYg6f2EzdYMq/BjsALYLdJwNEk9Ax5TEj+gDHgmBkhSPhXoSwwKrIw2qwbF73qYHa15aKAaiNly51X1maMNvrBoLyUyO2F7ZNPj/287rAkYzoUht4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683298; c=relaxed/simple;
	bh=r8c435z/8aNU0EJ27A0CyeONID1FVs0eKzgzHe+ATPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lA1/mlhliVNILhmXldZT0SHdluzcZ/SDm1T18Xb1Ho0yZQXvq5vTLVaZYZwCwHxJCMySQbj9tg4NzL0DR1uFvaBb0I5zQyczZTFuFBAbHZm2Xg/pQS7xK4NTU0sOyP5O4ecIB7M6coBkyKpPWP2qWxX5VpXJ+YtJU/HQiWMXm8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtOXZchn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtOXZchn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEC5C32781;
	Thu,  6 Jun 2024 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683297;
	bh=r8c435z/8aNU0EJ27A0CyeONID1FVs0eKzgzHe+ATPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtOXZchnu+Bi+Ux9EJ32xByRAb+fktTlHwm/b+1fW/xER/Gnn3grPW+3z5uNFj4oF
	 elgmPpgsZ5pesA+X6CNvS5WzwG8pc6z2htJNiKfW5/If/9wpdc126PvEFP2la8mgXU
	 B8QIz3Z3JgcqAZPaDs4xQCR9DeXeVNfqjcZ00frw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/473] pwm: sti: Convert to platform remove callback returning void
Date: Thu,  6 Jun 2024 16:01:07 +0200
Message-ID: <20240606131704.492905609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e13cec3617c6ace4fc389b60d2a7d5b305b62683 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 5bb0b194aeee ("pwm: sti: Simplify probe function using devm functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sti.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-sti.c b/drivers/pwm/pwm-sti.c
index 0a7920cbd4949..c782378dff5e5 100644
--- a/drivers/pwm/pwm-sti.c
+++ b/drivers/pwm/pwm-sti.c
@@ -677,7 +677,7 @@ static int sti_pwm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int sti_pwm_remove(struct platform_device *pdev)
+static void sti_pwm_remove(struct platform_device *pdev)
 {
 	struct sti_pwm_chip *pc = platform_get_drvdata(pdev);
 
@@ -685,8 +685,6 @@ static int sti_pwm_remove(struct platform_device *pdev)
 
 	clk_unprepare(pc->pwm_clk);
 	clk_unprepare(pc->cpt_clk);
-
-	return 0;
 }
 
 static const struct of_device_id sti_pwm_of_match[] = {
@@ -701,7 +699,7 @@ static struct platform_driver sti_pwm_driver = {
 		.of_match_table = sti_pwm_of_match,
 	},
 	.probe = sti_pwm_probe,
-	.remove = sti_pwm_remove,
+	.remove_new = sti_pwm_remove,
 };
 module_platform_driver(sti_pwm_driver);
 
-- 
2.43.0



