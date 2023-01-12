Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F563749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE6BC433D2;
	Thu, 12 Jan 2023 14:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532461;
	bh=W1LKCVn0PBOqt+2V60iYP5trZHeO5f7NMecwdQZPAEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9IfkZoam3YeVBJYnibap0fP2Fnw3RyM3vAtbjXngtGuHbj5981x1ou/Cs9/fBXio
	 cU6hI1iyuFgwl88fOzSfsSeZRxh6cieX9RMujXhiwiwFtXnNIw2Z0sJW6hZtLi1LEu
	 NNCGk/BMtxZCd8kPCpJ1XnnZmHBBBf3UYIj/BuOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/783] clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs
Date: Thu, 12 Jan 2023 14:47:35 +0100
Message-Id: <20230112135530.770165544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit ac1c5a03d3772b1db25e8092f771aa33f6ae2f7e ]

USB controllers on SM8250 doesn't work after coming back from suspend.
This can be fixed by keeping the USB GDSCs in retention mode so that
hardware can keep them ON and put into rentention mode once the parent
domain goes to a low power state.

Fixes: 3e5770921a88 ("clk: qcom: gcc: Add global clock controller driver for SM8250")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221102091320.66007-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8250.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8250.c b/drivers/clk/qcom/gcc-sm8250.c
index ab594a0f0c40..7ec11acc8298 100644
--- a/drivers/clk/qcom/gcc-sm8250.c
+++ b/drivers/clk/qcom/gcc-sm8250.c
@@ -3268,7 +3268,7 @@ static struct gdsc usb30_prim_gdsc = {
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc usb30_sec_gdsc = {
@@ -3276,7 +3276,7 @@ static struct gdsc usb30_sec_gdsc = {
 	.pd = {
 		.name = "usb30_sec_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc = {
-- 
2.35.1



