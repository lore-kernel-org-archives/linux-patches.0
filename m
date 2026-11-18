Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034565;
	b=q6/82lMw/h6vivcnyAt8IYet+9+w9DiObG9T/XjXxtrbNOMjPw96NgKVq4lb45EbxNDP
	 416+2m3+D19ltNwuzYYvyBIBKpjFq3uKT59zsKcI/U+assXWVCkEKitT/zrUMiwNqiSNJ
	 ZVkIpLpxJbiqsl6SNqVVnH+Ojg5HY/2SyB0fA+PYbwi0jJkbVUhhFF1jh1HrXX2IYO6fc
	 gSNrIDUdmwL6gqrYTP5jK9gqf4xvn1ApqWNUXVvC5F86/hRaTuz1VKuv11cLxoh1nWZRl
	 jdYCjvlGAeBoafv6hKFWPPAx/VID/aQrTu2GBcqR//7QWlVy2yOWzGOPzakAEhRwaFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0N7+2oDvUsf9Db99c6xOGbSfbFU32hA6MdW3UvqRhqI=;
	b=YXUJAQ8TR3v/Hk+BC6wdFzMMveAY9cpkuzSqR5RggXLIVYCOOtyAoCP6uX5rf7wXTf0P
	 wo+2K1h9bvUF/3IENego2iod8LUMY2PzSmHEXn/kvw3DLvmRURB6no13fYkVeMwFPmxDT
	 luS3/Uilcy+7tHqvd13KvigtZFnk4Q80k62jJaWRkUdtAQQkSuLD3ZPkrQx7YY1GB/Fl/
	 3EidEXzLeXN5CjS0kk7eoM+ICu49CG3iLVUDuFUlENSw2sY29UMCeECWgCCXQ1I2cuDIy
	 uUBfH2pfBCBTLF10a0IVupsZp2qq/N+7rYll3OMIrbBKyTylqXfxunWdvh+ipIutkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcPtRwCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83751606A31C;
	Wed, 18 Nov 2026 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcPtRwCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21011F000C4;
	Wed, 18 Nov 2026 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034565;
	bh=0N7+2oDvUsf9Db99c6xOGbSfbFU32hA6MdW3UvqRhqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcPtRwCCM38qxVjyI0LEucZBZ0wcKdFVDfX6+b0UttVQHn4+sn39CKBtrNquj3Jli
	 q8Asc0R4ap0ghqMez0P7QB3AkgGZaMxhFPpY8uZHHYZpcVf9z60TNDiPFzGej5cruj
	 K/1A8fG7rXbthPM8s4tYlT9y52hfwaHPH59Ju6s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0414/3318] platform/x86: ISST: Process read/write blocked feature status
Date: Wed, 18 Nov 2026 15:17:16 +0100
Message-ID: <20261118150328.931366009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 8bed9ff7dbcce4d1a436f7839be48c6fd5fac0ce ]

When a feature is read blocked, don't continue to read SST information
and register with SST core.

When the feature is write blocked, continue to offer read interface for
SST parameters, but don't allow any operation to change state. A state
change results from SST level change, feature change or class of service
change.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231204221740.3645130-5-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Adapt to this tree: the TPMI core here only exposes a locked/disabled status
query, which does not report firmware read/write blocked state, so the
status query and the read-blocked early exit are dropped. The write_blocked
field and the checks that honor it are kept so that the following change
applies; the field stays false until the TPMI core can report it.
The existing max_level and feature mask checks are kept next to the new
write_blocked checks.

Stable-dep-of: 574b59bb4b6b ("platform/x86: ISST: Validate parameter for frequency and priority")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/speed_select_if/isst_tpmi_core.c   | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 30f4f047ef5a2..8ba207a3908dc 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -233,6 +233,7 @@ struct perf_level {
  * @saved_clos_configs:	Save SST-CP CLOS configuration to store restore for suspend/resume
  * @saved_clos_assocs:	Save SST-CP CLOS association to store restore for suspend/resume
  * @saved_pp_control:	Save SST-PP control information to store restore for suspend/resume
+ * @write_blocked:	Write operation is blocked, so can't change SST state
  *
  * This structure is used store complete SST information for a power_domain. This information
  * is used to read/write request for any SST IOCTL. Each physical CPU package can have multiple
@@ -258,6 +259,7 @@ struct tpmi_per_power_domain_info {
 	u64 saved_clos_configs[4];
 	u64 saved_clos_assocs[4];
 	u64 saved_pp_control;
+	bool write_blocked;
 };
 
 /**
@@ -522,6 +524,9 @@ static long isst_if_clos_param(void __user *argp)
 		return -EINVAL;
 
 	if (clos_param.get_set) {
+		if (power_domain_info->write_blocked)
+			return -EPERM;
+
 		_write_cp_info("clos.min_freq", clos_param.min_freq_mhz,
 			       (SST_CLOS_CONFIG_0_OFFSET + clos_param.clos * SST_REG_SIZE),
 			       SST_CLOS_CONFIG_MIN_START, SST_CLOS_CONFIG_MIN_WIDTH,
@@ -619,6 +624,9 @@ static long isst_if_clos_assoc(void __user *argp)
 
 		power_domain_info = &sst_inst->power_domain_info[punit_id];
 
+		if (assoc_cmds.get_set && power_domain_info->write_blocked)
+			return -EPERM;
+
 		offset = SST_CLOS_ASSOC_0_OFFSET +
 				(punit_cpu_no / SST_CLOS_ASSOC_CPUS_PER_REG) * SST_REG_SIZE;
 		shift = punit_cpu_no % SST_CLOS_ASSOC_CPUS_PER_REG;
@@ -773,6 +781,9 @@ static int isst_if_set_perf_level(void __user *argp)
 	if (perf_level.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (power_domain_info->write_blocked)
+		return -EPERM;
+
 	if (!(power_domain_info->pp_header.allowed_level_mask & BIT(perf_level.level)))
 		return -EINVAL;
 
@@ -833,6 +844,9 @@ static int isst_if_set_perf_feature(void __user *argp)
 	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)
 		return -EINVAL;
 
+	if (power_domain_info->write_blocked)
+		return -EPERM;
+
 	_write_pp_info("perf_feature", perf_feature.feature, SST_PP_CONTROL_OFFSET,
 		       SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH,
 		       SST_MUL_FACTOR_NONE)
@@ -1342,7 +1356,7 @@ int tpmi_sst_dev_add(struct auxiliary_device *auxdev)
 		tpmi_sst->power_domain_info[i].package_id = pkg;
 		tpmi_sst->power_domain_info[i].power_domain_id = i;
 		tpmi_sst->power_domain_info[i].auxdev = auxdev;
-		tpmi_sst->power_domain_info[i].sst_base = devm_ioremap_resource(&auxdev->dev, res);
+			tpmi_sst->power_domain_info[i].sst_base = devm_ioremap_resource(&auxdev->dev, res);
 		if (IS_ERR(tpmi_sst->power_domain_info[i].sst_base))
 			return PTR_ERR(tpmi_sst->power_domain_info[i].sst_base);
 
-- 
2.53.0



