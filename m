Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5614734FB;
	Mon, 31 Aug 2026 13:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183323; cv=none; b=ilu2sqjCA0I9nJbGELajH2tNSj7ibHEIUjCBtp1CeCZmB4d0UGYna0k5Q48r9PUGeh3j01q0b3CL7HGnziP5rzAuci4AOJw1VgDoQ2UMYxi5Bo6SK9t/NT2Cq5qka4aDNd9e8Uol0lxuAK/dW7LkWTwPPa5mboG/h7LIgEfabRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183323; c=relaxed/simple;
	bh=kY54yd9m13S3cBlusIPrl6+fxB1LbSDb+0MUGkFbhws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHWhwYhtUrd8z0JTOYWJBUptWYnoYkU6Lc/6he8Uc3nW6P3Oq30rPVhbURk1CUfTyCcGFson+DQzlOJfbIMMauJZ4SRX9KN8n7TqElptqIWGLzJMHrFNWNXJUIqh1Fz/KJhaoJGAzXpC+mJNx40+IQiinhH4HfcGuLR9d2S08ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpkVAtQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpkVAtQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D371F00A3E;
	Mon, 31 Aug 2026 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183321;
	bh=8XtJme2S2RhgZz8CE8/RpMZrIgUXZNe5h5LArPZhVOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpkVAtQ0vl2uY/yzvVSJlyB/E6i+K1jIR6twJZcV20uvYVhHH6V4Gk+zu/ohwkn1Q
	 UyoOuZJKh8H2V4XFTaW2wr+xAW1zAjoWECYeq2sqRBnrAMHatVXoj2kmhrr+o0N7w6
	 as4uQxZL7McINcTqjPfZzmKJjsv0v3u9zPDJ4MBXoCIwDDtfJ8HkpTAlYJtC+I2lP6
	 10VgPf0ZycINrk03qwMMgCYMqAGBlp8o1FFfsEFkg13D8O4YxcfCcOvPifvKAoJ3ky
	 KsG7HtsO6WtWoHyobd6bscyxq6HrOwpGgrBUWfXcxKXwcIBZNsNrHDlPlDK1LpsmHT
	 +McI5PIMapc6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fu Hao <fuhao@open-hieco.net>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iommu/amd: Add support for Hygon family 18h model 4h IOAPIC
Date: Mon, 31 Aug 2026 09:21:47 -0400
Message-ID: <20260831133314.4125787-79-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fu Hao <fuhao@open-hieco.net>

[ Upstream commit 5beda8cadb1f072140e58b1edb7604444a42d955 ]

The SB IOAPIC is on the device 0xb from Hygon family 18h model 4h.

Signed-off-by: Fu Hao <fuhao@open-hieco.net>
Tested-by: Tingyin Duan <tingyin.duan@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `git log -S "No southbridge IOAPIC found"` search finished after
~8.7 minutes. The last hits were mostly unrelated merge commits; the
closest relevant one is `7d2fed1f3ce46` (irq merge for v6.17-rc1), but
pickaxe history here still doesn’t give a clean “introduced in” commit.

That doesn’t affect the backport call: the AMD-only IOAPIC check is
already in this **6.18.43** tree, and the Hygon quirk fix remains
**YES**.

 drivers/iommu/amd/init.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 69170146d4421..0de0791d46bef 100644
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
 			ret           = true;
 		}
-- 
2.53.0

