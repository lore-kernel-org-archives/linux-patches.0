Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949FB1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B292C433D2;
	Wed, 28 Dec 2022 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244534;
	bh=6DWDjo+onS9Kmg/vNF6YJAbCDqtveaJBwccFfAlaeYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujJWfeDR2hsHUgQra96tyhwkU++NZhdzzpeljRN1Xj/oELnNek6F8bTZWDYJB4T0g
	 jY0jw4IrBjawYRjLcDBWsEGQA49cCVdN834eF8YQGTCML3uozJKqvhWXbeizyvTF+m
	 fCsiW82r015KFBB/XJd9LITKRJ9bY+6R+bSx9pRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0728/1073] thermal/drivers/qcom/lmh: Fix irq handler return value
Date: Wed, 28 Dec 2022 15:38:36 +0100
Message-Id: <20221228144347.797754794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



