Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385C2FC21;
	Fri, 24 Nov 2023 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQw9auah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A5AC433C7;
	Fri, 24 Nov 2023 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851231;
	bh=OgVQL+a4r7aP591mIDbumP5Z94PKZo9zi3Ym5lLGbBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQw9auahKU0HRNfPWVAs0IuWiE/lcQgjrg5pwvh2tRIrb5WQlCIlWS7So3uxQN90i
	 yXM3SxjcpvKGJg+7gcHtxo0DfneEX7Lrp5ViD9Yb7w4OQhp7+ABOrt3Ru3aOldwJ0A
	 5vdIdXzj56Pwx0MPaz84npVaOXl9t23D12h2qxcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 366/491] pmdomain: amlogic: Fix mask for the second NNA mem PD domain
Date: Fri, 24 Nov 2023 17:50:02 +0000
Message-ID: <20231124172035.572871341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomeu Vizoso <tomeu@tomeuvizoso.net>

[ Upstream commit b131329b9bfbd1b4c0c5e088cb0c6ec03a12930f ]

Without this change, the NPU hangs when the 8th NN core is used.

It matches what the out-of-tree driver does.

Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Fixes: 9a217b7e8953 ("soc: amlogic: meson-pwrc: Add NNA power domain for A311D")
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231016080205.41982-2-tomeu@tomeuvizoso.net
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-ee-pwrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/amlogic/meson-ee-pwrc.c b/drivers/soc/amlogic/meson-ee-pwrc.c
index f54acffc83f9f..f2b24361c8cac 100644
--- a/drivers/soc/amlogic/meson-ee-pwrc.c
+++ b/drivers/soc/amlogic/meson-ee-pwrc.c
@@ -229,7 +229,7 @@ static struct meson_ee_pwrc_mem_domain sm1_pwrc_mem_audio[] = {
 
 static struct meson_ee_pwrc_mem_domain g12a_pwrc_mem_nna[] = {
 	{ G12A_HHI_NANOQ_MEM_PD_REG0, GENMASK(31, 0) },
-	{ G12A_HHI_NANOQ_MEM_PD_REG1, GENMASK(23, 0) },
+	{ G12A_HHI_NANOQ_MEM_PD_REG1, GENMASK(31, 0) },
 };
 
 #define VPU_PD(__name, __top_pd, __mem, __is_pwr_off, __resets, __clks)	\
-- 
2.42.0



