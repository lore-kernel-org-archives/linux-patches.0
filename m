Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164CF61FC4;
	Tue,  5 Dec 2023 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQCLrElW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D50C433C8;
	Tue,  5 Dec 2023 20:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701807226;
	bh=dIROEkvo2Gg0VYeHSqM2xywwQJJxQH5RhW1JkLyvtWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JQCLrElWpENPuaglK0pVPSbbFIJ0pOeO16T9QAE1VwuFVEbpVcqPj4hwaSKkLsb+V
	 T7MN2D2V22KXDI8UUu91p1I6eDSOPwaPFkAgvMG9yUGcIPKHf4Zby0Moa8/lNa4s3H
	 ZSt62UwqKjv7xF56lXZKMZPdEb+5rHRmqpVmT3JQvlrueq4/T960ctl3eRftok89HJ
	 8FF7Mjzn2Sd0D+92Uap16Nek1LihQVhYITLtZ1sC26I8BVg7obDUTp3UTI06o/u8Ai
	 h7eFcIRz85wb0m+Q8w9ivO1xKoRkeFTfqWuvZt8JPQzksiI+74HydRzmd7DVtb834H
	 Y46JmPyKRtlkg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 05 Dec 2023 13:13:36 -0700
Subject: [PATCH 3/3] drm/bridge: Return NULL instead of plain 0 in
 drm_dp_hpd_bridge_register() stub
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231205-drm_aux_bridge-fixes-v1-3-d242a0ae9df4@kernel.org>
References: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
In-Reply-To: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
To: dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, 
 linux@roeck-us.net, neil.armstrong@linaro.org, bryan.odonoghue@linaro.org, 
 linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1151; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dIROEkvo2Gg0VYeHSqM2xywwQJJxQH5RhW1JkLyvtWA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5LeVpGnVr72+cF7xbef/BhYHuWU6J3Gwthed+rXc3F
 C0wOafVUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYSKsTIsGOtzpY2/rxVV3LO
 1G79Vq8mV+XoHFt9es+FO5k3FWq+1TIyPJ17Pl37quq+9Qu8A67PufrJ4mpJ3Tm7nw5d73QcvH8
 HcwAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

sparse complains:

  drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c: note: in included file:
  include/drm/bridge/aux-bridge.h:29:16: sparse: sparse: Using plain integer as NULL pointer

Return NULL to clear up the warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312060025.BdeqZrWx-lkp@intel.com/
Fixes: e560518a6c2e ("drm/bridge: implement generic DP HPD bridge")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/drm/bridge/aux-bridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/bridge/aux-bridge.h b/include/drm/bridge/aux-bridge.h
index 66249ff0858e..c4c423e97f06 100644
--- a/include/drm/bridge/aux-bridge.h
+++ b/include/drm/bridge/aux-bridge.h
@@ -26,7 +26,7 @@ void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status sta
 static inline struct device *drm_dp_hpd_bridge_register(struct device *parent,
 							struct device_node *np)
 {
-	return 0;
+	return NULL;
 }
 
 static inline void drm_aux_hpd_bridge_notify(struct device *dev, enum drm_connector_status status)

-- 
2.43.0

