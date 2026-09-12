Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E541A575;
	Sat, 12 Sep 2026 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215110; cv=none; b=boHP/alejWmEOeMZziOF+aLesEj4dy/q46NxndV7G6yVq58nWR1NFEw9rLmG2y2YHfbm3Iqohe2zMk9Plg13uswRZqn2TrWsdc5x8ON5vL2b0CWOBsnt1Bcs1TqMwJJh0FDINMSyyKQmCEle3nNSOIQ9ogiIA3MYR4NmiKX/kHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215110; c=relaxed/simple;
	bh=iv4DokEsWSCo5VqgGNpDsEBRdfK2UwEBU3wtmAeqjKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrHLyi68kTMaylQWIYeEvAMHS1PLoBZwdjJd91e8hMwyiaTXtzT7QVn3p+R+Fj0cediNSODeNinSzpEOs8pRWU32dxc2ZhiwD+joIk3EjcZVCtIHzm38qTqQSMsy5N2AzTLeiNaATObXly/gTDQpyYKsQHoVAaW3ahaTS4n86TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIR9gBpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIR9gBpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08EC1F000FF;
	Sat, 12 Sep 2026 12:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215109;
	bh=M8kfen3Etd7d9ZP7SxKQxHmSBpnAO3tB2zVEWzH77Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIR9gBpzFAZbqH+Dk/3RFWgcf0Sc3pVItkWWVSfawCud9sSGaiCEJ8aJqEYVtR3fI
	 YECz9fZ52EyjqWEcXfN/Dfn33QU5qef4SZNjcbtmX4NcvTfUFKwCfhQ0IDnhswVGsL
	 py5DXQhT3rXv42f8i/6ByedvA/BaSuQfpiyHeSsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fu Hao <fuhao@open-hieco.net>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0462/1376] iommu/amd: Add support for Hygon family 18h model 4h IOAPIC
Date: Sat, 12 Sep 2026 08:48:08 +0200
Message-ID: <20260912065617.827183608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 66f30e3883d57..d0ef7c936fd40 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2966,6 +2966,9 @@ static void __init free_iommu_resources(void)
 /* SB IOAPIC is always on this device in AMD systems */
 #define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
 
+/* SB IOAPIC for Hygon family 18h model 4h is on the device 0xb */
+#define IOAPIC_SB_DEVID_FAM18H_M4H	((0x00 << 8) | PCI_DEVFN(0xb, 0))
+
 static bool __init check_ioapic_information(void)
 {
 	const char *fw_bug = FW_BUG;
@@ -2991,7 +2994,12 @@ static bool __init check_ioapic_information(void)
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



