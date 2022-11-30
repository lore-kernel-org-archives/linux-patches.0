Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444FB79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B913EC433B5;
	Wed, 30 Nov 2022 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834397;
	bh=cXUFPo7OqE2nILNuP6wEGNjVgk3DTRgoHCsjSSUkV4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcall1uUstnRI1gGKTUxonGjlJpbaMghKi4Hp1jR+bwciIJHBG2ZqoqpihB+S8Mf4
	 ldX/UXuVmfRYjo5aegVrZL9RbjvUTagVIHDJayoywLvRTzpVf73WAYUj6fqljFpbae
	 brtqSbt8naw9AYpeoGyR1bUDPgM2m25L2cFAg8/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjana Hari <quic_ahari@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 239/289] pinctrl: qcom: sc8280xp: Rectify UFS reset pins
Date: Wed, 30 Nov 2022 19:23:44 +0100
Message-Id: <20221130180549.529446113@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anjana Hari <quic_ahari@quicinc.com>

[ Upstream commit f04a2862f9c3f64962b8709c75d788efba6df26b ]

UFS reset pin offsets are wrongly configured for SC8280XP,
correcting the same for both UFS instances here.

Signed-off-by: Anjana Hari <quic_ahari@quicinc.com>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # QDrive3
Link: https://lore.kernel.org/r/20221103181051.26912-1-quic_bjorande@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
index aa2075390f3e..e96c00686a25 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
@@ -1873,8 +1873,8 @@ static const struct msm_pingroup sc8280xp_groups[] = {
 	[225] = PINGROUP(225, hs3_mi2s, phase_flag, _, _, _, _, egpio),
 	[226] = PINGROUP(226, hs3_mi2s, phase_flag, _, _, _, _, egpio),
 	[227] = PINGROUP(227, hs3_mi2s, phase_flag, _, _, _, _, egpio),
-	[228] = UFS_RESET(ufs_reset, 0xf1004),
-	[229] = UFS_RESET(ufs1_reset, 0xf3004),
+	[228] = UFS_RESET(ufs_reset, 0xf1000),
+	[229] = UFS_RESET(ufs1_reset, 0xf3000),
 	[230] = SDC_QDSD_PINGROUP(sdc2_clk, 0xe8000, 14, 6),
 	[231] = SDC_QDSD_PINGROUP(sdc2_cmd, 0xe8000, 11, 3),
 	[232] = SDC_QDSD_PINGROUP(sdc2_data, 0xe8000, 9, 0),
-- 
2.35.1



