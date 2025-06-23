Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA791EFFA6;
	Mon, 23 Jun 2025 21:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714118; cv=none; b=MpDI9snPaWTGBrM9PAu2dF+cyzfGYPOh7P2ocoU1R25yc2MA6KlfwG8IAFPEjCvyt7XoacBuSb7FpfKbmfREVaxt4tylFUJj64TlVjKkJujQ9V05r6NK2sY3PHkdhlYTtgVsUc7PbT/zU32EYQs0uJjqGJxNfv4pu9scGjMFGIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714118; c=relaxed/simple;
	bh=H7XXFwIe+XDDvkPGjRlhjTxa/wnc93V6pxlRqBwOIiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dbZNPWp9Jt0BKVkuLHclEjySg3y2tinpp/JVwsWIpt7Ngzs/a1MZ8R1HqzDFhKtwknCjZQ4trVicCqtcxtbcpgc5PUyl3DeaIjBWzvnR4NOHeTaXivp6UE57VJlc4wCjiui45X2DnrwWpZ5iprnYbu8mZui/VtmBIkeI/gITnQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrZTnISZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrZTnISZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AFAC4CEEA;
	Mon, 23 Jun 2025 21:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714118;
	bh=H7XXFwIe+XDDvkPGjRlhjTxa/wnc93V6pxlRqBwOIiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrZTnISZvEgfktz4PccwqwRV+y+/cxrBJ6A7cxhdSBhS04OB+ZYPx5Vm7r9XTg6O5
	 lDPN8Ih0ksj3PKxOrLZsQ2V03gPYP5DBTo9rdRVi63HMOmSopOly0JTlhXLAbuXlwx
	 k1Twdc/BMB22hRrDmBjnfbWoKXudtlSKFbwIn7jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?V=C3=ADctor=20Gonzalo?= <victor.gonzalo@anddroptable.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 391/592] wifi: iwlwifi: Add missing MODULE_FIRMWARE for Qu-c0-jf-b0
Date: Mon, 23 Jun 2025 15:05:49 +0200
Message-ID: <20250623130709.744770786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Víctor Gonzalo <victor.gonzalo@anddroptable.net>

[ Upstream commit 2b801487ac3be7bec561ae62d1a6c4d6f5283f8c ]

The module metadata for the firmware file iwlwifi-Qu-c0-jf-b0-* is missing.

Signed-off-by: Víctor Gonzalo <victor.gonzalo@anddroptable.net>
Link: https://patch.msgid.link/20240313180227.2224780-1-victor.gonzalo@anddroptable.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 130b9a8aa7ebe..67ee3b6e6d85c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -44,6 +44,8 @@
 	IWL_QU_C_HR_B_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_QU_C_JF_B_MODULE_FIRMWARE(api) \
+	IWL_QU_C_JF_B_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL_CC_A_MODULE_FIRMWARE(api)			\
 	IWL_CC_A_FW_PRE "-" __stringify(api) ".ucode"
 
@@ -422,6 +424,7 @@ const struct iwl_cfg iwl_cfg_quz_a0_hr_b0 = {
 MODULE_FIRMWARE(IWL_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QU_C_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_CC_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-- 
2.39.5



