Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751476FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C37C433C8;
	Sun, 17 Sep 2023 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978678;
	bh=yR3Y0b7w97sOgoFX6JUVZ1b/Sp5R17ACsC4swEO3Q/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugd/+cg0JGC6Rvwxn1NodcG4m2ZKyUNWtaQGGw1VLJPICOZAT4mmTDNrt+u+xGlHb
	 yvUlCEZPQw3HliBC9h8LPdkhXTBztY4dYa9jwkz2Dxyo2/sJ76AgPTSmC/BJx1iuzz
	 BQIUcS+i4nDBqGIz/R7PuwFb7smirKU2MRE7cw7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/406] soc: qcom: ocmem: Add OCMEM hardware version print
Date: Sun, 17 Sep 2023 21:09:42 +0200
Message-ID: <20230917191104.528739333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit e81a16e77259294cd4ff0a9c1fbe5aa0e311a47d ]

It might be useful to know what hardware version of the OCMEM block the
SoC contains. Add a debug print for that.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230509-ocmem-hwver-v3-1-e51f3488e0f4@z3ntu.xyz
Stable-dep-of: a7b484b1c933 ("soc: qcom: ocmem: Fix NUM_PORTS & NUM_MACROS macros")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 1dfdd0b9ba24d..ae023bef81b6f 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -76,6 +76,10 @@ struct ocmem {
 #define OCMEM_REG_GFX_MPU_START			0x00001004
 #define OCMEM_REG_GFX_MPU_END			0x00001008
 
+#define OCMEM_HW_VERSION_MAJOR(val)		FIELD_GET(GENMASK(31, 28), val)
+#define OCMEM_HW_VERSION_MINOR(val)		FIELD_GET(GENMASK(27, 16), val)
+#define OCMEM_HW_VERSION_STEP(val)		FIELD_GET(GENMASK(15, 0), val)
+
 #define OCMEM_HW_PROFILE_NUM_PORTS(val)		FIELD_PREP(0x0000000f, (val))
 #define OCMEM_HW_PROFILE_NUM_MACROS(val)	FIELD_PREP(0x00003f00, (val))
 
@@ -357,6 +361,12 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 		}
 	}
 
+	reg = ocmem_read(ocmem, OCMEM_REG_HW_VERSION);
+	dev_dbg(dev, "OCMEM hardware version: %lu.%lu.%lu\n",
+		OCMEM_HW_VERSION_MAJOR(reg),
+		OCMEM_HW_VERSION_MINOR(reg),
+		OCMEM_HW_VERSION_STEP(reg));
+
 	reg = ocmem_read(ocmem, OCMEM_REG_HW_PROFILE);
 	ocmem->num_ports = OCMEM_HW_PROFILE_NUM_PORTS(reg);
 	ocmem->num_macros = OCMEM_HW_PROFILE_NUM_MACROS(reg);
-- 
2.40.1



