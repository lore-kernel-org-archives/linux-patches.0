Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288A4143867;
	Thu, 13 Jun 2024 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281974; cv=none; b=ej2V6KSdVN1bFIvHFI6nBz3mdW6WfdLFVNLPSaQPuogsNDgija3v6k9n20HTvCyBryXEi+xwDxTgfqZYROuyGElZjdWcifx7zrmVDTgoXvJNw23aGOOl4eRjkUcgBxwV5qzJuRLN6HC23ZqpTJDnHhjENzvHk0xAy/22gS0uGBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281974; c=relaxed/simple;
	bh=TjouqR8cMyE1CNGGZT7c+weBBoxOr3n3i7UT584FKhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/+bYQOln2TAYOFnWw/WeYVXDhXAo5MROT/8KM2riL6Vcvd74F3ReKij76MvQX8edY8b31bD68cV0ieoL40Q5aB6vSW7Ppy9Kqkw4yVRv4OcN7IiG4q/Mvw8TWPtzjgqa6BuPdLpJi0dg9jVJ0xP8Sjz2ey1mgTxEdQqrQC7uXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoBVZ1jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoBVZ1jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DE5C2BBFC;
	Thu, 13 Jun 2024 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281974;
	bh=TjouqR8cMyE1CNGGZT7c+weBBoxOr3n3i7UT584FKhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoBVZ1jjasYhWW4OhaFM3hUUfk6ymouTBvnEpnhoQVcy7qZlwtcdyHXfdHo6R+u2Q
	 PmlxxLRnYBeg2GjExzZtrk5PEoounv/iJfLWcwzhbMGkAhMjTOqDijECKjtKyFxXR4
	 qI6BjSXIAfRN1ui1fLCnJq5cvrOMhlkW8yIehPcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/402] pwm: sti: Convert to platform remove callback returning void
Date: Thu, 13 Jun 2024 13:30:46 +0200
Message-ID: <20240613113305.611416201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



