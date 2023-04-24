Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556892108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB49C433EF;
	Mon, 24 Apr 2023 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343357;
	bh=TUe1+MUj546q7CGO45GAVN/aI1BsHlyNJ0bXu17AEEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsUnNRvE+oL0sSwH1FfdyWTiit41Fp6Pe0JT89GUVRtDJODKEMF3QJpLPkxVf6Q7b
	 9MV6U+/LctYKjUWnQ4NsixpyoC/G2rMlyOHPq2Hgvj5sHB5v7hamDCL4M8jaLg1rWH
	 vfRzCuenYZlD1QpEupvKsIRaxkPzs7Nz9gDxcyKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"thierry.reding@gmail.com, Jeff LaBundy" <jeff@labundy.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jeff LaBundy <jeff@labundy.com>
Subject: [PATCH 5.10 64/68] pwm: iqs620a: Explicitly set .polarity in .get_state()
Date: Mon, 24 Apr 2023 15:18:35 +0200
Message-Id: <20230424131130.079761780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Uwe Kleine-K�nig" <u.kleine-koenig@pengutronix.de>

[ Upstream commit b20b097128d9145fadcea1cbb45c4d186cb57466 ]

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

Fixes: 6f0841a8197b ("pwm: Add support for Azoteq IQS620A PWM generator")
Reviewed-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20230228135508.1798428-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-iqs620a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pwm/pwm-iqs620a.c
+++ b/drivers/pwm/pwm-iqs620a.c
@@ -132,6 +132,7 @@ static void iqs620_pwm_get_state(struct
 	mutex_unlock(&iqs620_pwm->lock);
 
 	state->period = IQS620_PWM_PERIOD_NS;
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static int iqs620_pwm_notifier(struct notifier_block *notifier,


