Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556021C9B99;
	Tue,  8 Oct 2024 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392650; cv=none; b=NuAvNPrjBaeDDov+vFu1gf4pwRorB8NQipthgtMke8s+d2YhdfliCfuX/7fBiFLhXdW/I+o6nFHS8EIA0pAxPsOcw8IBx6xEhvQief2dAMSwOCwwZnqVs81h25WNeKUEjVJLm+jy8cYlBZnp7Ih85dt2EzGWtpym09l7IRpsCns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392650; c=relaxed/simple;
	bh=Pew3pT4WKn7K1TNrdzXysUF84GiTly42pXK4JlfBs9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuqVeSIo2aSR+oLEYxUaxo13+ytm4wqjwGD76DlwzuHEY41gmXi6PtSjl8SSkSZ/1LCTn4QZAHfiN4Ic/zxb7eh7jLJvO0d0S/olKrZg3/JguhPRAIR3uz82zD/duPkdizV0ndGKGxWsMpR3Yn9e0YvlgsGrjDrzEX6ckgieC7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBGxryVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBGxryVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC5C4CEC7;
	Tue,  8 Oct 2024 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392650;
	bh=Pew3pT4WKn7K1TNrdzXysUF84GiTly42pXK4JlfBs9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBGxryVSVkTolU7sgQ/5ZDEoJq/TjsJCPtGhU5ZkV2EKqhodmZ0Ahw5mcq4/gHhNR
	 K26lf8fPeH+iOkIUB9c97IQTBdt1IfqsSIkTfDTE0y1yWEssG3i/l2sTGo/16LCFjr
	 3Zq3+IGWuO8uuuguPb7jkB0c0mCktAcv2edzLcpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.11 447/558] leds: pca9532: Remove irrelevant blink configuration error message
Date: Tue,  8 Oct 2024 14:07:57 +0200
Message-ID: <20241008115719.852818687@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

commit 2aad93b6de0d874038d3d7958be05011284cd6b9 upstream.

The update_hw_blink() function prints an error message when hardware is
not able to handle a blink configuration on its own. IMHO, this isn't a
'real' error since the software fallback is used afterwards.

Remove the error messages to avoid flooding the logs with unnecessary
messages.

Cc: stable@vger.kernel.org
Fixes: 48ca7f302cfc ("leds: pca9532: Use PWM1 for hardware blinking")
Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Link: https://lore.kernel.org/r/20240826133237.134604-1-bastien.curutchet@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-pca9532.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 338ddada3de9..1b47acf54720 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -215,8 +215,7 @@ static int pca9532_update_hw_blink(struct pca9532_led *led,
 		if (other->state == PCA9532_PWM1) {
 			if (other->ldev.blink_delay_on != delay_on ||
 			    other->ldev.blink_delay_off != delay_off) {
-				dev_err(&led->client->dev,
-					"HW can handle only one blink configuration at a time\n");
+				/* HW can handle only one blink configuration at a time */
 				return -EINVAL;
 			}
 		}
@@ -224,7 +223,7 @@ static int pca9532_update_hw_blink(struct pca9532_led *led,
 
 	psc = ((delay_on + delay_off) * PCA9532_PWM_PERIOD_DIV - 1) / 1000;
 	if (psc > U8_MAX) {
-		dev_err(&led->client->dev, "Blink period too long to be handled by hardware\n");
+		/* Blink period too long to be handled by hardware */
 		return -EINVAL;
 	}
 
-- 
2.46.2



