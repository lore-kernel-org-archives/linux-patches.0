Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363CBA36
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4FDC433D2;
	Tue,  7 Mar 2023 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210386;
	bh=R8WRriDInyP6Dmq2ZbHt/uemX/Qx5RiTebLK2k9hehw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdMxdJ0Mari1a6Oa5z72dPW7ujdNIUseaNz/HLLigZgW46/NF2p2jTp/fQ0WTYEPC
	 v2GyhnUpCgViQDa9RhvtO5qeXJUQgNlAF6wi4/nFWuRqDPGuh8M7zj+oXB67tGS01s
	 KAr0CvkTO96+j9rNkXPTr/viWNrqBrfPPUahM8p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0493/1001] i2c: qcom-geni: change i2c_master_hub to static
Date: Tue,  7 Mar 2023 17:54:25 +0100
Message-Id: <20230307170042.770059985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 597688792c4d9939e1900f5840ca18804e9d4290 ]

i2c_master_hub is only used in i2c-qcom-geni.c now,
change it to static.

Fixes: cacd9643eca7 ("i2c: qcom-geni: add support for I2C Master Hub variant")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index fd70794bfceec..a378f679b499d 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -1025,7 +1025,7 @@ static const struct dev_pm_ops geni_i2c_pm_ops = {
 									NULL)
 };
 
-const struct geni_i2c_desc i2c_master_hub = {
+static const struct geni_i2c_desc i2c_master_hub = {
 	.has_core_clk = true,
 	.icc_ddr = NULL,
 	.no_dma_support = true,
-- 
2.39.2



