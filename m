Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CDD200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2485AC433C7;
	Fri, 21 Jul 2023 19:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966230;
	bh=+1hMspF/G9VnTE1U8jAUe9oapUDtIFZeqHZj3czvEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjAnONimX3qwciODkXWAeEYES5gBhK0cImE4JLXcvqdOjC8UwNxMR84scRUuI2dVx
	 9d6PneGbcZjtIXqwR+0Z7ml2Jcx9LjIMtAGy6uGHcePxyPrmMEQGLU6Y6Ttv6vAmND
	 2f+37ozPKI5rxXN+ffUTRw2svm0Et+SbI296PjD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/532] clk: qcom: gcc-ipq6018: Use floor ops for sdcc clocks
Date: Fri, 21 Jul 2023 18:02:55 +0200
Message-ID: <20230721160629.044159755@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mantas Pucka <mantas@8devices.com>

[ Upstream commit 56e5ae0116aef87273cf1812d608645b076e4f02 ]

SDCC clocks must be rounded down to avoid overclocking the controller.

Fixes: d9db07f088af ("clk: qcom: Add ipq6018 Global Clock Controller support")
Signed-off-by: Mantas Pucka <mantas@8devices.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1682413909-24927-1-git-send-email-mantas@8devices.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq6018.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq6018.c b/drivers/clk/qcom/gcc-ipq6018.c
index 3f9c2f61a5d93..5c5d1b04ea7af 100644
--- a/drivers/clk/qcom/gcc-ipq6018.c
+++ b/drivers/clk/qcom/gcc-ipq6018.c
@@ -1654,7 +1654,7 @@ static struct clk_rcg2 sdcc1_apps_clk_src = {
 		.name = "sdcc1_apps_clk_src",
 		.parent_data = gcc_xo_gpll0_gpll2_gpll0_out_main_div2,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.39.2



