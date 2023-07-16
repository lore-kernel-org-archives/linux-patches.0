Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EC88F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F55BC433C7;
	Sun, 16 Jul 2023 20:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540689;
	bh=GZSmU7mNcaxl7UzfPQSHelVVimnVEyOBvy0MB4ik2T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j92GEtt73GYk6iTrrV2WYY8NgXPnCbAFgrbQc9qs1Ba9NoL4ReIuUqOpO31JxEDQ2
	 ZYwoY7L6rKXEXDnUA0qdAERAojqyduXqxS7a3xLJsOqnVWmdZEhy2okYvTJoV+cAL6
	 CaEwEkaocI11ciK7BB74coYEaALpbTEE2uK+uArI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 452/591] clk: qcom: mmcc-msm8974: fix MDSS_GDSC power flags
Date: Sun, 16 Jul 2023 21:49:51 +0200
Message-ID: <20230716194935.602782778@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4e13c7a55cf752887f2b8d8008711dbbc64ea796 ]

Using PWRSTS_RET on msm8974's MDSS_GDSC causes display to stop working.
The gdsc doesn't fully come out of retention mode. Change it's pwrsts
flags to PWRSTS_OFF_ON.

Fixes: d399723950c4 ("clk: qcom: gdsc: Fix the handling of PWRSTS_RET support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Tested-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20230507175335.2321503-2-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8974.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -2372,7 +2372,7 @@ static struct gdsc mdss_gdsc = {
 	.pd = {
 		.name = "mdss",
 	},
-	.pwrsts = PWRSTS_RET_ON,
+	.pwrsts = PWRSTS_OFF_ON,
 };
 
 static struct gdsc camss_jpeg_gdsc = {


