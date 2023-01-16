Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CE16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664B5C433F0;
	Mon, 16 Jan 2023 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888655;
	bh=IGRtW/smLYfIYcZnexDGg8SWh3TaNRW9wHRlQrTtJmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnMVrMyl4VhMagfigvv62B9n0yEJmIIfOmY33sZ8yLnyW06//d2xgFJz7L1For2sK
	 tkBnwZ1xdG+p+L1djb89cXBLFjJLuQgckzbZAxWGWn2YG/AlpVojDUfgVJGqV+E1FU
	 vXkL+gaMpd1QJ4tw082W7bJ0kCONNa+yh0xgKPc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Aakarsh Jain <aakarsh.jain@samsung.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/338] media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC
Date: Mon, 16 Jan 2023 16:49:22 +0100
Message-Id: <20230116154824.757585614@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aakarsh Jain <aakarsh.jain@samsung.com>

[ Upstream commit f50ebe10f5d8092c37e2bd430c78e03bf38b1e20 ]

Commit 5441e9dafdfc6dc40 ("[media] s5p-mfc: Core support for MFC v7")
which adds mfc v7 support for Exynos3250 and use the same compatible
string as used by Exynos5240 but both the IPs are a bit different in
terms of IP clock.
Add variant driver data based on the new compatible string
"samsung,exynos3250-mfc" for Exynos3250 SoC.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Fixes: 5441e9dafdfc ("[media] s5p-mfc: Core support for MFC v7")
Signed-off-by: Aakarsh Jain <aakarsh.jain@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 75be40608bae..5cbb3151004f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1582,8 +1582,18 @@ static struct s5p_mfc_variant mfc_drvdata_v7 = {
 	.port_num	= MFC_NUM_PORTS_V7,
 	.buf_size	= &buf_size_v7,
 	.fw_name[0]     = "s5p-mfc-v7.fw",
-	.clk_names	= {"mfc", "sclk_mfc"},
-	.num_clocks	= 2,
+	.clk_names	= {"mfc"},
+	.num_clocks	= 1,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v7_3250 = {
+	.version        = MFC_VERSION_V7,
+	.version_bit    = MFC_V7_BIT,
+	.port_num       = MFC_NUM_PORTS_V7,
+	.buf_size       = &buf_size_v7,
+	.fw_name[0]     = "s5p-mfc-v7.fw",
+	.clk_names      = {"mfc", "sclk_mfc"},
+	.num_clocks     = 2,
 };
 
 static struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
@@ -1630,6 +1640,9 @@ static const struct of_device_id exynos_mfc_match[] = {
 	}, {
 		.compatible = "samsung,mfc-v7",
 		.data = &mfc_drvdata_v7,
+	}, {
+		.compatible = "samsung,exynos3250-mfc",
+		.data = &mfc_drvdata_v7_3250,
 	}, {
 		.compatible = "samsung,mfc-v8",
 		.data = &mfc_drvdata_v8,
-- 
2.35.1



