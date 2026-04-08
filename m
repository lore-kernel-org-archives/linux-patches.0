Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ECE3D9022;
	Wed,  8 Apr 2026 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672891; cv=none; b=m+iOg1CnclHQihP515xKXcJIvnYM9771N+6iBM+af0jfVZIa5h76nrdtUZ1XnrdxEWO2NatIlE4x2QHcrSI8vjd/87f74BNP3E9dOA4cfkPGBNjo1bUtlOcBkXuH1+Tn2N53Jig9lJWU0n+v96/jyIdbQ7t5egINfkKZCQmyNAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672891; c=relaxed/simple;
	bh=1zP0N7Nxlcv+osQjrv7aFzBzOugzU4F+vdfyqbi26XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEAtirZUXLGGu9vapY+92ur3TO15Fk71tTElwVNgKeMVhhuID9kcazVgG7wlPC60/YjOSp7z4c/cyt65mcGEVwVYIye4XdJRqxeUXOMJ+am+fGdRBMA2QWvE6/NMlwDVtTQwW0nS22wMjKqih7HvdAFZeMs/0EWd1wY9t7OsTF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb2oApBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb2oApBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5872DC19425;
	Wed,  8 Apr 2026 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672891;
	bh=1zP0N7Nxlcv+osQjrv7aFzBzOugzU4F+vdfyqbi26XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb2oApBte7HWIYAmjxXO7R/l1g5UuNaRdMJJWCyeV/cAMWrjmT0rqKFIBAKXOh4dy
	 O+WASH1xGwmkFXUkPqJgoD1lsQ9W7ggOz4pqh3UhpqenyBq3OJipCncIZ23b1ApQmQ
	 j0GqqCvNy7WCHh+qy14tpzswsrvcE2WItmE1dmTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/277] wifi: iwlwifi: cfg: add new device names
Date: Wed,  8 Apr 2026 20:00:06 +0200
Message-ID: <20260408175934.645313117@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 30d47d8fe781469ebd4e38240999767f139effb2 ]

Add a couple of device names so that these new devices will
be shown correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250915113137.1cbc0251532f.I6183a6a08a7998e598042a50c7d7a6b82f9fa58e@changeid
Stable-dep-of: 687a95d204e7 ("wifi: iwlwifi: mld: correctly set wifi generation data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c  | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
index 97735175cb0ea..b8c6b06e70991 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
@@ -13,3 +13,4 @@ const char iwl_killer_be1775i_name[] =
 
 const char iwl_be211_name[] = "Intel(R) Wi-Fi 7 BE211 320MHz";
 const char iwl_be213_name[] = "Intel(R) Wi-Fi 7 BE213 160MHz";
+const char iwl_ax221_name[] = "Intel(R) Wi-Fi 6E AX221 160MHz";
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 502c6a1cf4f86..0b34c9f90b3ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -688,6 +688,7 @@ extern const char iwl_killer_bn1850i_name[];
 extern const char iwl_bn201_name[];
 extern const char iwl_be221_name[];
 extern const char iwl_be223_name[];
+extern const char iwl_ax221_name[];
 #if IS_ENABLED(CONFIG_IWLDVM)
 extern const struct iwl_rf_cfg iwl5300_agn_cfg;
 extern const struct iwl_rf_cfg iwl5350_agn_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index b21a4d8eb1051..de04a84def0d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1061,11 +1061,14 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 
 /* WH RF */
 	IWL_DEV_INFO(iwl_rf_wh, iwl_be211_name, RF_TYPE(WH)),
+	IWL_DEV_INFO(iwl_rf_wh, iwl_ax221_name, RF_TYPE(WH), SUBDEV(0x0514)),
+	IWL_DEV_INFO(iwl_rf_wh, iwl_ax221_name, RF_TYPE(WH), SUBDEV(0x4514)),
 	IWL_DEV_INFO(iwl_rf_wh_160mhz, iwl_be213_name, RF_TYPE(WH), BW_LIMITED),
 
 /* PE RF */
 	IWL_DEV_INFO(iwl_rf_pe, iwl_bn201_name, RF_TYPE(PE)),
 	IWL_DEV_INFO(iwl_rf_pe, iwl_be223_name, RF_TYPE(PE), SUBDEV(0x0524)),
+	IWL_DEV_INFO(iwl_rf_pe, iwl_be223_name, RF_TYPE(PE), SUBDEV(0x4524)),
 	IWL_DEV_INFO(iwl_rf_pe, iwl_be221_name, RF_TYPE(PE), SUBDEV(0x0324)),
 
 /* Killer */
-- 
2.53.0



