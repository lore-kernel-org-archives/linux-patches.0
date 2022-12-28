Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273CF1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A841C433EF;
	Wed, 28 Dec 2022 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244869;
	bh=6DWDjo+onS9Kmg/vNF6YJAbCDqtveaJBwccFfAlaeYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUcItqWhttqiShn143BoCuwqMOEHQiqSmPcsegrfNZawDyFcvI3kA7nXRBR7CWl8m
	 KSuU9Wh7wXGlsqdo0btRBfRLUEDe8e7VroFRF+fbZ6S9sUt07JbStJb81zvJsi75g9
	 kABX/UUorrRCrvJgTVspZ7aBsjylQZDXwWGxlkyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0753/1146] thermal/drivers/qcom/lmh: Fix irq handler return value
Date: Wed, 28 Dec 2022 15:38:12 +0100
Message-Id: <20221228144350.597440618@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 46a891e45be97c6781ac34f5ec777d69370e252b ]

After enough invocations the LMh irq is eventually reported as bad, because the
handler doesn't return IRQ_HANDLED, fix this.

Fixes: 53bca371cdf7 ("thermal/drivers/qcom: Add support for LMh driver")
Reported-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220316180322.88132-1-bjorn.andersson@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/lmh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/lmh.c b/drivers/thermal/qcom/lmh.c
index d3d9b9fa49e8..4122a51e9874 100644
--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -45,7 +45,7 @@ static irqreturn_t lmh_handle_irq(int hw_irq, void *data)
 	if (irq)
 		generic_handle_irq(irq);
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
 static void lmh_enable_interrupt(struct irq_data *d)
-- 
2.35.1



