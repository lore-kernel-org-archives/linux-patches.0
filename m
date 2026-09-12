Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDC2F7F17;
	Sat, 12 Sep 2026 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229331; cv=none; b=kBZvCnelCmdb8jBVke4oz+rAVAWykEziqp3TWBCxBMVkKMUpILY3j+jcGScSxLaqSu5YqvsMxBDJ4+6S8/vee25tMQ+9xQXFvI9UqFGG3Oo50lRxxp+9VQ8RpObv3wmdqAT2KB3BpvAKBFBOQAYwxGQjytxsAJYMjV3b1fkSuo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229331; c=relaxed/simple;
	bh=x9vD5PuiUqRNE1rVknophXLM1Am1tSynGSvzrxZ1T9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVzrGj+85McPPmHwmGScmM+x98isJZfxV0KuBEGSeDrxgaexQhSqPU4cJ1TnLR+dzfNsKCDPWi055hD5jxXAfmJxrwIIy/fjI3h67titpkR1nhDbplJBOUGcUcVcumGF16HfrI+CwJwIlNLmrt3U1snOPuvu2q9nZLXGmGWdYzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaGkfEyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaGkfEyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586941F000FF;
	Sat, 12 Sep 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229330;
	bh=Q4rAWAopUYvZ6524L89c0W9EWAVK6K5drvJ/maXJVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaGkfEyMeP/HIQYRkUd+pKwU+Ma1ixSAGCzQLCU0GnxQtkIVuu0Jm/hwzXK3zK/Df
	 CRc4Jp/8RYU96BisGGu6MHxGD6AGlhU7ON5X3X1irTrVjFFRo5EVcjkP4pYM01Ekv+
	 Yj2MsqiZk/4fSIAYyh+7DBCDXWelznkxMmbqj+C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fu Hao <fuhao@open-hieco.net>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0569/1191] iommu/amd: Add support for Hygon family 18h model 4h IOAPIC
Date: Sat, 12 Sep 2026 08:54:57 +0200
Message-ID: <20260912065601.026350493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fu Hao <fuhao@open-hieco.net>

[ Upstream commit 5beda8cadb1f072140e58b1edb7604444a42d955 ]

The SB IOAPIC is on the device 0xb from Hygon family 18h model 4h.

Signed-off-by: Fu Hao <fuhao@open-hieco.net>
Tested-by: Tingyin Duan <tingyin.duan@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 04fee302fac7 ("iommu/amd: Fix false positive in SB IOAPIC IVRS validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index a6808eaa48d49..0961866820e5b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2960,6 +2960,9 @@ static void __init free_iommu_resources(void)
 /* SB IOAPIC is always on this device in AMD systems */
 #define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
 
+/* SB IOAPIC for Hygon family 18h model 4h is on the device 0xb */
+#define IOAPIC_SB_DEVID_FAM18H_M4H	((0x00 << 8) | PCI_DEVFN(0xb, 0))
+
 static bool __init check_ioapic_information(void)
 {
 	const char *fw_bug = FW_BUG;
@@ -2985,7 +2988,12 @@ static bool __init check_ioapic_information(void)
 			pr_err("%s: IOAPIC[%d] not in IVRS table\n",
 				fw_bug, id);
 			ret = false;
-		} else if (devid == IOAPIC_SB_DEVID) {
+		} else if (devid == IOAPIC_SB_DEVID ||
+			   (boot_cpu_data.x86_vendor == X86_VENDOR_HYGON &&
+			    boot_cpu_data.x86 == 0x18 &&
+			    boot_cpu_data.x86_model >= 0x4 &&
+			    boot_cpu_data.x86_model <= 0xf &&
+			    devid == IOAPIC_SB_DEVID_FAM18H_M4H)) {
 			has_sb_ioapic = true;
 		}
 	}
-- 
2.53.0



