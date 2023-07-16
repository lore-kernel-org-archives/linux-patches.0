Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E738F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE18BC433C7;
	Sun, 16 Jul 2023 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538828;
	bh=+1hMspF/G9VnTE1U8jAUe9oapUDtIFZeqHZj3czvEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyKX0lt9mpZiXMnAV3zQF4102SbufOu0ugWSEYxNMGf4IShQCKaNz+p3khsJC0cp5
	 mWHGeSbcAtEdAvWP+6jPHJsgU7lFTapKPtGk6na4ZHGzC2tasFgT+a7DNUOiV5gEv7
	 H8Z9CUDlEfKzoI2kwhPcjr6HcbiIYKQFfAgXSdeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 563/800] clk: qcom: gcc-ipq6018: Use floor ops for sdcc clocks
Date: Sun, 16 Jul 2023 21:46:56 +0200
Message-ID: <20230716195002.165330481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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



