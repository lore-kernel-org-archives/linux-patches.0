Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F31D0E23;
	Tue,  8 Oct 2024 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389861; cv=none; b=jt/gj2YGCHyji/q7tfMoLl/hOGxUXJv5OoyM2hlzcVK0EO/TP6cZGwwzp1aEp6i1AI8ciyWz4X325eWAZeXldOaa/AqaBF3BythKOxBC6Bh0HMZ5TlCWscB8OOx791zZkPaJxz/sxN2hnOCOioMiUXSbyWBX5tmziEV+BBy+rRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389861; c=relaxed/simple;
	bh=qIv5J9UyfgZ9aexiSmsJJWTWkGkcqsUUPuK0Grt8RM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtqAWxG64XkbpwjguFx2Xx34DXVLqRti7Fv9Z3S2BssmjaQ9hz4jjq+oDbzSRf97fgnV3P8JRzNsXxXRIYllK2jEjNiN71TR2eTNkotzABNg20IRB7wyCf6R4KFrg7ndAJHOhCtHXIqXdHOwtA8TrY+Y0Fkn0Y1ToeUrGLvELgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh8uheBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh8uheBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C413C4CEC7;
	Tue,  8 Oct 2024 12:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389861;
	bh=qIv5J9UyfgZ9aexiSmsJJWTWkGkcqsUUPuK0Grt8RM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh8uheBZrkcGVLSzSLupK2GEVl+Imw6YRF8DTn0Vn1lc5gdsVeeONUzOAwa7RbQvv
	 e5gfW9birssYqjH34cKcZfZW5HVlwxwV+A289Okn4RcS01vLj+/SPaN/mC4iTtnFwK
	 oI5AWLuu8UR9EIdhQHGUCJ1CsY+M4PpBLh0ajZ0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 117/482] wifi: iwlwifi: allow only CN mcc from WRDD
Date: Tue,  8 Oct 2024 14:03:00 +0200
Message-ID: <20241008115652.912116720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit ff5aabe7c2a4a4b089a9ced0cb3d0e284963a7dd ]

Block other mcc expect CN from WRDD ACPI.

Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240808232017.fe6ea7aa4b39.I86004687a2963fe26f990770aca103e2f5cb1628@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       | 5 +++++
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       | 2 --
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index ba9e656037a20..9b3d3405fb83d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -356,6 +356,11 @@ int iwl_acpi_get_mcc(struct iwl_fw_runtime *fwrt, char *mcc)
 	}
 
 	mcc_val = wifi_pkg->package.elements[1].integer.value;
+	if (mcc_val != BIOS_MCC_CHINA) {
+		ret = -EINVAL;
+		IWL_DEBUG_RADIO(fwrt, "ACPI WRDD is supported only for CN\n");
+		goto out_free;
+	}
 
 	mcc[0] = (mcc_val >> 8) & 0xff;
 	mcc[1] = mcc_val & 0xff;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index 633c9ad9af841..ecf482647617c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -45,6 +45,8 @@
 #define IWL_WTAS_ENABLE_IEC_MSK	0x4
 #define IWL_WTAS_USA_UHB_MSK		BIT(16)
 
+#define BIOS_MCC_CHINA 0x434e
+
 /*
  * The profile for revision 2 is a superset of revision 1, which is in
  * turn a superset of revision 0.  So we can store all revisions
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index fb982d4fe8510..2cf878f237ac6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -638,7 +638,7 @@ int iwl_uefi_get_mcc(struct iwl_fw_runtime *fwrt, char *mcc)
 		goto out;
 	}
 
-	if (data->mcc != UEFI_MCC_CHINA) {
+	if (data->mcc != BIOS_MCC_CHINA) {
 		ret = -EINVAL;
 		IWL_DEBUG_RADIO(fwrt, "UEFI WRDD is supported only for CN\n");
 		goto out;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 1f8884ca8997c..e0ef981cd8f28 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -149,8 +149,6 @@ struct uefi_cnv_var_splc {
 	u32 default_pwr_limit;
 } __packed;
 
-#define UEFI_MCC_CHINA 0x434e
-
 /* struct uefi_cnv_var_wrdd - WRDD table as defined in UEFI
  * @revision: the revision of the table
  * @mcc: country identifier as defined in ISO/IEC 3166-1 Alpha 2 code
-- 
2.43.0



