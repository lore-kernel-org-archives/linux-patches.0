Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F044DBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C5C4339B;
	Tue,  7 Mar 2023 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215818;
	bh=1JuYttSn3ht/CJWRtuEQTErsofXMlpxaYWbopeHMiLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpy8vvbHy6SK71TpWLuAQRqBg+3bzoAe1Gb0IPodaCMKvD3FbJkj9MWM27snhfWMr
	 cGUU3T2vZMoQRBB7jKN07FFrWQr+/0TzbU5NW1zgJEe8i4y+GfHiNH0A7X2Wa90Hg1
	 i8jPdyqOFyOyRT6/soPLl2HTNZ+q6II3ZC/rcmLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Zimmermann <tim@linux4.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/567] thermal: intel: intel_pch: Add support for Wellsburg PCH
Date: Tue,  7 Mar 2023 18:02:00 +0100
Message-Id: <20230307165922.489441031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Zimmermann <tim@linux4.de>

[ Upstream commit 40dc1929089fc844ea06d9f8bdb6211ed4517c2e ]

Add the PCI ID for the Wellsburg C610 series chipset PCH.

The driver can read the temperature from the Wellsburg PCH with only
the PCI ID added and no other modifications.

Signed-off-by: Tim Zimmermann <tim@linux4.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_pch_thermal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index 527c91f5960be..768c66046a599 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -29,6 +29,7 @@
 #define PCH_THERMAL_DID_CNL_LP	0x02F9 /* CNL-LP PCH */
 #define PCH_THERMAL_DID_CML_H	0X06F9 /* CML-H PCH */
 #define PCH_THERMAL_DID_LWB	0xA1B1 /* Lewisburg PCH */
+#define PCH_THERMAL_DID_WBG	0x8D24 /* Wellsburg PCH */
 
 /* Wildcat Point-LP  PCH Thermal registers */
 #define WPT_TEMP	0x0000	/* Temperature */
@@ -345,6 +346,7 @@ enum board_ids {
 	board_cnl,
 	board_cml,
 	board_lwb,
+	board_wbg,
 };
 
 static const struct board_info {
@@ -375,6 +377,10 @@ static const struct board_info {
 		.name = "pch_lewisburg",
 		.ops = &pch_dev_ops_wpt,
 	},
+	[board_wbg] = {
+		.name = "pch_wellsburg",
+		.ops = &pch_dev_ops_wpt,
+	},
 };
 
 static int intel_pch_thermal_probe(struct pci_dev *pdev,
@@ -490,6 +496,8 @@ static const struct pci_device_id intel_pch_thermal_id[] = {
 		.driver_data = board_cml, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_LWB),
 		.driver_data = board_lwb, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_WBG),
+		.driver_data = board_wbg, },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, intel_pch_thermal_id);
-- 
2.39.2



