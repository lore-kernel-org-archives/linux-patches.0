Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D17461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D023C433C7;
	Sun, 17 Sep 2023 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981947;
	bh=Yd/9mABRRi6aor79S350vDsRzYOwm16MoUIrPWPng64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxWEBtzhMVPeaAIkHBz9ydaU2LWMCsRbA17FrKAuwBoTO79zshZr5fxOR6dll8vDq
	 yx6YCZaNWUT179mmtpN5rW8Hj3TyvpXyT51qdIUfIRU+js4S4FO1bYayIYxf5UjY49
	 r8PtvoK+ndHsAfPCHlUcAnbiOlR8cwzkJEOilqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/511] soc: qcom: ocmem: Fix NUM_PORTS & NUM_MACROS macros
Date: Sun, 17 Sep 2023 21:09:17 +0200
Message-ID: <20230917191117.005048587@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit a7b484b1c9332a1ee12e8799d62a11ee3f8e0801 ]

Since we're using these two macros to read a value from a register, we
need to use the FIELD_GET instead of the FIELD_PREP macro, otherwise
we're getting wrong values.

So instead of:

  [    3.111779] ocmem fdd00000.sram: 2 ports, 1 regions, 512 macros, not interleaved

we now get the correct value of:

  [    3.129672] ocmem fdd00000.sram: 2 ports, 1 regions, 2 macros, not interleaved

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20230506-msm8226-ocmem-v3-1-79da95a2581f@z3ntu.xyz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index ae023bef81b6f..8b80c8e94c77a 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -80,8 +80,8 @@ struct ocmem {
 #define OCMEM_HW_VERSION_MINOR(val)		FIELD_GET(GENMASK(27, 16), val)
 #define OCMEM_HW_VERSION_STEP(val)		FIELD_GET(GENMASK(15, 0), val)
 
-#define OCMEM_HW_PROFILE_NUM_PORTS(val)		FIELD_PREP(0x0000000f, (val))
-#define OCMEM_HW_PROFILE_NUM_MACROS(val)	FIELD_PREP(0x00003f00, (val))
+#define OCMEM_HW_PROFILE_NUM_PORTS(val)		FIELD_GET(0x0000000f, (val))
+#define OCMEM_HW_PROFILE_NUM_MACROS(val)	FIELD_GET(0x00003f00, (val))
 
 #define OCMEM_HW_PROFILE_LAST_REGN_HALFSIZE	0x00010000
 #define OCMEM_HW_PROFILE_INTERLEAVING		0x00020000
-- 
2.40.1



