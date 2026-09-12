Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4350837F8BC;
	Sat, 12 Sep 2026 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207018; cv=none; b=motYZcdklk20woZYm2z6VcvW26+Bsywt5mxyB3B1Hgk77QGnvGRbbEky+u4yxs8qLV2w+E49NtekdjZ0j6mJHa11vOQtEvSFNmtB3DoiJnBNGtFHzYlvX9mMUHjdI3P/zyzoWNk+olNFnnWDKOUHhoKQ7/wjw0HJWogYwr2mi1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207018; c=relaxed/simple;
	bh=tfD+2ZhSF7DCbQ7xaMKVhkKosZnCX7VR48xHqmlYCaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdE5aBtOB/qh7QkgjOnmQgd8Um6kL83hyQFBOJTFaczPWS2SyKpSYo/fJ4/FKv/F9l7qzADL79QUEg4Bi2UJSZhN1QdFaZtN7D5gQsrr8JOHu/tBqbvE07kfipzzDR0iLrBWgA/h1+2CmI5E448GKe0gn7N6df7A2phXPn4tHkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AienhIAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AienhIAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8DD1F000FF;
	Sat, 12 Sep 2026 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207017;
	bh=k0AQPF2v0BrOWpiA8O3oppqrqvELU4/altA2NWeb9MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AienhIAOK3kPr8RD2sFeTg7LrJVxTORS3upVUVczXdykpLPXKNYIOZxK1ILyR7u1s
	 ZIS1qh3KGDN3JBr+PJDNqcUE+HVgj2sSAQzSGBhJf5gKzmanexmgTH5JGnfxR1waQ8
	 g+ZA/SjB9Voqhg67O0+01k51O47G4OHO41+u9Np4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fu Hao <fuhao@open-hieco.net>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0283/1518] iommu/amd: Add support for Hygon family 18h model 4h IOAPIC
Date: Sat, 12 Sep 2026 08:40:52 +0200
Message-ID: <20260912065629.884338121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 20b1cc2159332..bf8b114386884 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3096,6 +3096,9 @@ static void __init free_iommu_resources(void)
 /* SB IOAPIC is always on this device in AMD systems */
 #define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
 
+/* SB IOAPIC for Hygon family 18h model 4h is on the device 0xb */
+#define IOAPIC_SB_DEVID_FAM18H_M4H	((0x00 << 8) | PCI_DEVFN(0xb, 0))
+
 static bool __init check_ioapic_information(void)
 {
 	const char *fw_bug = FW_BUG;
@@ -3121,7 +3124,12 @@ static bool __init check_ioapic_information(void)
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



