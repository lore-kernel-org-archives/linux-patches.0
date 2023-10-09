Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0391A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx2wsByt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF552C433CB;
	Mon,  9 Oct 2023 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857560;
	bh=vX1idf7RSso39h+X7wrK7hp/+Vz9dM6x/1RuYfUCbpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx2wsBytaB+D4Mpq9C94YxeeBsWRXwFCyjYEEi7h8pziBc2f4PfMST+1d5EnZ5yki
	 6GMOJ/FfnJENwm8/JNLCRTeO1e4qIBObF0woi5003PSZu9L8ebxWwXhTlXjy5vlJYE
	 oS1B5HwmfKwMil4u84wlPv6vrSyxXsG2cL0Qn3Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/162] regulator: mt6358: Drop *_SSHUB regulators
Date: Mon,  9 Oct 2023 15:01:06 +0200
Message-ID: <20231009130125.264341149@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 04ba665248ed91576d326041108e5fc2ec2254eb ]

The *_SSHUB regulators are actually alternate configuration interfaces
for their non *_SSHUB counterparts. They are not separate regulator
outputs. These registers are intended for the companion processor to
use to configure the power rails while the main processor is sleeping.
They are not intended for the main operating system to use.

Since they are not real outputs they shouldn't be modeled separately.
Remove them. Luckily no device tree actually uses them.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20230609083009.2822259-5-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7e37c851374e ("regulator: mt6358: split ops for buck and linear range LDO regulators")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6358-regulator.c       | 14 --------------
 include/linux/regulator/mt6358-regulator.h |  4 ----
 2 files changed, 18 deletions(-)

diff --git a/drivers/regulator/mt6358-regulator.c b/drivers/regulator/mt6358-regulator.c
index 8a5ce990f1bf9..153c1fd5fb0b7 100644
--- a/drivers/regulator/mt6358-regulator.c
+++ b/drivers/regulator/mt6358-regulator.c
@@ -505,9 +505,6 @@ static struct mt6358_regulator_info mt6358_regulators[] = {
 	MT6358_BUCK("buck_vcore", VCORE, 500000, 1293750, 6250,
 		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f,
 		    MT6358_VCORE_VGPU_ANA_CON0, 1),
-	MT6358_BUCK("buck_vcore_sshub", VCORE_SSHUB, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_SSHUB_ELR0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 1),
 	MT6358_BUCK("buck_vpa", VPA, 500000, 3650000, 50000,
 		    buck_volt_range3, 0x3f, MT6358_BUCK_VPA_DBG0, 0x3f,
 		    MT6358_VPA_ANA_CON0, 3),
@@ -587,10 +584,6 @@ static struct mt6358_regulator_info mt6358_regulators[] = {
 	MT6358_LDO1("ldo_vsram_others", VSRAM_OTHERS, 500000, 1293750, 6250,
 		    buck_volt_range1, MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00,
 		    MT6358_LDO_VSRAM_CON2, 0x7f),
-	MT6358_LDO1("ldo_vsram_others_sshub", VSRAM_OTHERS_SSHUB, 500000,
-		    1293750, 6250, buck_volt_range1,
-		    MT6358_LDO_VSRAM_OTHERS_SSHUB_CON1, 0x7f,
-		    MT6358_LDO_VSRAM_OTHERS_SSHUB_CON1, 0x7f),
 	MT6358_LDO1("ldo_vsram_gpu", VSRAM_GPU, 500000, 1293750, 6250,
 		    buck_volt_range1, MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00,
 		    MT6358_LDO_VSRAM_CON3, 0x7f),
@@ -607,9 +600,6 @@ static struct mt6358_regulator_info mt6366_regulators[] = {
 	MT6366_BUCK("buck_vcore", VCORE, 500000, 1293750, 6250,
 		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_DBG0, 0x7f,
 		    MT6358_VCORE_VGPU_ANA_CON0, 1),
-	MT6366_BUCK("buck_vcore_sshub", VCORE_SSHUB, 500000, 1293750, 6250,
-		    buck_volt_range1, 0x7f, MT6358_BUCK_VCORE_SSHUB_ELR0, 0x7f,
-		    MT6358_VCORE_VGPU_ANA_CON0, 1),
 	MT6366_BUCK("buck_vpa", VPA, 500000, 3650000, 50000,
 		    buck_volt_range3, 0x3f, MT6358_BUCK_VPA_DBG0, 0x3f,
 		    MT6358_VPA_ANA_CON0, 3),
@@ -678,10 +668,6 @@ static struct mt6358_regulator_info mt6366_regulators[] = {
 	MT6366_LDO1("ldo_vsram_others", VSRAM_OTHERS, 500000, 1293750, 6250,
 		    buck_volt_range1, MT6358_LDO_VSRAM_OTHERS_DBG0, 0x7f00,
 		    MT6358_LDO_VSRAM_CON2, 0x7f),
-	MT6366_LDO1("ldo_vsram_others_sshub", VSRAM_OTHERS_SSHUB, 500000,
-		    1293750, 6250, buck_volt_range1,
-		    MT6358_LDO_VSRAM_OTHERS_SSHUB_CON1, 0x7f,
-		    MT6358_LDO_VSRAM_OTHERS_SSHUB_CON1, 0x7f),
 	MT6366_LDO1("ldo_vsram_gpu", VSRAM_GPU, 500000, 1293750, 6250,
 		    buck_volt_range1, MT6358_LDO_VSRAM_GPU_DBG0, 0x7f00,
 		    MT6358_LDO_VSRAM_CON3, 0x7f),
diff --git a/include/linux/regulator/mt6358-regulator.h b/include/linux/regulator/mt6358-regulator.h
index bdcf83cd719ef..be9f61e3e8e6d 100644
--- a/include/linux/regulator/mt6358-regulator.h
+++ b/include/linux/regulator/mt6358-regulator.h
@@ -48,8 +48,6 @@ enum {
 	MT6358_ID_VLDO28,
 	MT6358_ID_VAUD28,
 	MT6358_ID_VSIM2,
-	MT6358_ID_VCORE_SSHUB,
-	MT6358_ID_VSRAM_OTHERS_SSHUB,
 	MT6358_ID_RG_MAX,
 };
 
@@ -90,8 +88,6 @@ enum {
 	MT6366_ID_VMC,
 	MT6366_ID_VAUD28,
 	MT6366_ID_VSIM2,
-	MT6366_ID_VCORE_SSHUB,
-	MT6366_ID_VSRAM_OTHERS_SSHUB,
 	MT6366_ID_RG_MAX,
 };
 
-- 
2.40.1



