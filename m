Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28CBDF4F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D505C433D2;
	Mon, 12 Jun 2023 10:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567090;
	bh=gISjHfdXsuSWMW/xs7lUJ24htPx4lap4xXE5Djk52cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXC4Kt6c3Yj2j6AIJuPOvvgEpMt4EVrvz0LrVbcuu4fQDDpCWK8cMvXE0uNjSW6HW
	 Jq1MMYU557X5wNgr9j9zM0vnuEwP5xGScCneNAhZZ7B1ZuaGn0uwf6Q0lFSP33H1Rb
	 bTVy9eVhP+QWJQMRba5IBwfF8+D+DOUKxi3cDQ6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 118/160] soc: qcom: rpmh-rsc: drop redundant unsigned >=0 comparision
Date: Mon, 12 Jun 2023 12:27:30 +0200
Message-ID: <20230612101720.460771644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 3395d36e6805786c26d13188735bc796b9d7a7c9 ]

Unsigned int "minor" is always >= 0 as reported by Smatch:

  drivers/soc/qcom/rpmh-rsc.c:1076 rpmh_rsc_probe() warn: always true condition '(drv->ver.minor >= 0) => (0-u32max >= 0)'

Fixes: 88704a0cd719 ("soc: qcom: rpmh-rsc: Support RSC v3 minor versions")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230513112913.176009-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index f93544f6d7961..0dd4363ebac8f 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -1073,7 +1073,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 	drv->ver.minor = rsc_id & (MINOR_VER_MASK << MINOR_VER_SHIFT);
 	drv->ver.minor >>= MINOR_VER_SHIFT;
 
-	if (drv->ver.major == 3 && drv->ver.minor >= 0)
+	if (drv->ver.major == 3)
 		drv->regs = rpmh_rsc_reg_offset_ver_3_0;
 	else
 		drv->regs = rpmh_rsc_reg_offset_ver_2_7;
-- 
2.39.2



