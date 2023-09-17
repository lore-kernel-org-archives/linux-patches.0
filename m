Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99C7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53270C433C8;
	Sun, 17 Sep 2023 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981941;
	bh=snMCM8mXA7QX3252dzZFtjjuEAPsBrGg3ddIwPj0flg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG/fzTFiSU/PZdGpMACkdpHhdyLZ1KjW8yK5ikMLNdRHaGBoJIqfSfpxwFS4/x4nK
	 gcoC2j4vmjigKElVlIWzwfFYPFWze2nLH7VuwErU+00xP38rfL4uePnejy+U1/gYo6
	 Ov9MJ7GHDqCqwcH3Riu0p7PMTleCO4GzsjugVT2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/511] soc: qcom: ocmem: Add OCMEM hardware version print
Date: Sun, 17 Sep 2023 21:09:16 +0200
Message-ID: <20230917191116.981765533@linuxfoundation.org>
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



