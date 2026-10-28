Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215928;
	b=SQhkeAf60pZJlWYZMATH3I9Ph+4GzyhrxbP8e9OAGlrmoesEk5FjjF22lUlPAT+KnaDs
	 DrAOYx8nS7J71mj8UyD5ac8U01vrmKmEWH7zrXU3T274mFx0bZ/xKoMiOMXboEL1dcCpc
	 YxXnxMN/EpMpskNnUqXCJqiCPUfPXKur61k4XIvxZfmImQHZGchClqmhDUNyKOUOpCfth
	 K5X30pVSU9SQ/84d2qqExZaJyBikM6LSShTLQhSzNNMnLwn/s+1Pr5StoX7/mR2/0zAf7
	 U8kNAZ3czL/ghE3R/RRoSUC7tzuOvmPFpFNmZAxc/pSdUB4XzBSq4Yv5c68x9YsHs8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QDKvTuOvQl2O/BLPUqB3nxFqddyasYR5LV4SKDbGJos=;
	b=Q+6XJWtMJl82zpSvm4pzRmXZRO8gKiHEsjG7mCe7rdJhJY3sd5R9dWGO2lClp/MIteCg
	 nlO5O7/s34mP0m2j2c169SYNNfxA1YJhxUtmMjQsjWcj5ONdECYzfyKp/VqBeZSIDSpLY
	 vLHjoPsCFIa2b+wLi1Pg2sD9Q9r9evkMhHGwGLnFjLpxosGztjPXfCJoIu0p0AIDHyIve
	 vOcBNFr6FbM+38ECMBsHLUyvzPeVuby5GWUuRjIqTTyTDYeYLOLi43qZy3KxP7qR2OZMg
	 X/ucuNJRFbK+KBhmirtVtAnIi3vgkWXAl/d8hw4u7L8w3txy8c0DMrR+qUFHNlshTlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vaR9U4mM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B216606A322;
	Wed, 28 Oct 2026 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vaR9U4mM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CADC1F01825;
	Wed, 28 Oct 2026 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215927;
	bh=QDKvTuOvQl2O/BLPUqB3nxFqddyasYR5LV4SKDbGJos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaR9U4mMhx4vSuZT23nBeYEdhh82qj5nXt8kxTdEnVl9nPo7LjkdOHbj2ecVD3JIP
	 fTFKpAzVkyMyLnAu575fDXeGr68xHjMBuMXZBw0Ug2+UmHDjd1UhiHNCHVi263EI7r
	 aCMxcWUNwiYecUdkqEVU/q7YSMhebjYqUfwOI9hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1382/1887] iommu/vt-d: Force requesting ACS when tboot is enabled
Date: Wed, 28 Oct 2026 17:57:58 +0100
Message-ID: <20261028170530.895911852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Tian <kevin.tian@intel.com>

[ Upstream commit 607432b2618b61df81134be0ef2562b8300c1216 ]

Currently the conditions of requesting ACS in detect_intel_iommu()
don't include tboot, leading to a possible misconfiguration with ACS
disabled (e.g. due to user opts) while iommu is later forced on by
tboot_force_iommu().

Fix it by checking tboot in detect_intel_iommu().

Fixes: 5d990b627537 ("PCI: add pci_request_acs")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c  | 15 +++++++++++++--
 drivers/iommu/intel/iommu.c |  2 +-
 drivers/iommu/intel/iommu.h |  2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 75eb4bd5ebb74..1d330852fb0bb 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -912,6 +912,18 @@ dmar_validate_one_drhd(struct acpi_dmar_header *entry, void *arg)
 	return 0;
 }
 
+static bool dmar_required(void)
+{
+	/* tboot supersedes any user/platform opt */
+	if (!intel_iommu_tboot_noforce && tboot_enabled())
+		return true;
+
+	if (!no_iommu && (!dmar_disabled || dmar_platform_optin()))
+		return true;
+
+	return false;
+}
+
 void __init detect_intel_iommu(void)
 {
 	int ret;
@@ -925,8 +937,7 @@ void __init detect_intel_iommu(void)
 	if (!ret)
 		ret = dmar_walk_dmar_table((struct acpi_table_dmar *)dmar_tbl,
 					   &validate_drhd_cb);
-	if (!ret && !no_iommu && !iommu_detected &&
-	    (!dmar_disabled || dmar_platform_optin())) {
+	if (!ret && !iommu_detected && dmar_required()) {
 		iommu_detected = 1;
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59c094bf9b3fe..48b9d5e4a3cd4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -138,7 +138,7 @@ static int rwbf_quirk;
  * (used when kernel is launched w/ TXT)
  */
 static int force_on = 0;
-static int intel_iommu_tboot_noforce;
+int intel_iommu_tboot_noforce;
 static int no_platform_optin;
 
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 5116105671727..080cbaafec434 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -802,6 +802,7 @@ extern int iommu_calculate_agaw(struct intel_iommu *iommu);
 extern int iommu_calculate_max_sagaw(struct intel_iommu *iommu);
 extern int dmar_disabled;
 extern int intel_iommu_enabled;
+extern int intel_iommu_tboot_noforce;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -814,6 +815,7 @@ static inline int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
 #define dmar_disabled	(1)
 #define intel_iommu_enabled (0)
 #define intel_iommu_sm (0)
+#define intel_iommu_tboot_noforce (0)
 #endif
 
 static inline const char *decode_prq_descriptor(char *str, size_t size,
-- 
2.53.0



