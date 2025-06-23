Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51B54315A;
	Mon, 23 Jun 2025 21:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714994; cv=none; b=BxOahdCaphSHqS4imZJtDabsgYz9L9BfBpqmE5g4Aewj8vMIuaflLS6dycQ1bhDptNs9Vqo1jbwwnb8Jy0eTjM4J95Ie7OMuqE7jU3mhmuENM2LbEMdo1WqvDvr7wqhA9xyK86cs1kAWYiVAZSiOzmj6fbqPPDIjQ20WWJHX+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714994; c=relaxed/simple;
	bh=AueGq5ua9ycGYfeY4pOnE+QGnALuHv4JMTGtFma5dN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3eA3I/4PmVVwwDYTVVtwIYDsemG7Ue1e1cQ36Evc1HFxlunwIOQPWsDvYipjn990MumIZwy0nafkw4WAdnUicG4FZdQvpkmFrwZmWVAtGJwolO4UHE9+MmL2mbrjUVfG6QAQx5zxCIBskUWHoGVYEX9y38+oQZIkNEEgvT+RAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zklpZA8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zklpZA8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBE4C4CEEA;
	Mon, 23 Jun 2025 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714994;
	bh=AueGq5ua9ycGYfeY4pOnE+QGnALuHv4JMTGtFma5dN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zklpZA8ELgE1qN1DIxPM2iLHh7ss/M/0a6O4lnDgW7++CWllGEbtRiFazkvn2AQrD
	 d2Jfin2DtCU3SpWBsNv7xTvcguZY59+Qj/BKTYRrHU5NXgsMynj9vXTeq2Xqh6dWHv
	 tuf+wvtSORKHcxnOlm2jubFEIffIxmr9GHKhv1Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?V=C3=ADctor=20Gonzalo?= <victor.gonzalo@anddroptable.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/290] wifi: iwlwifi: Add missing MODULE_FIRMWARE for Qu-c0-jf-b0
Date: Mon, 23 Jun 2025 15:07:14 +0200
Message-ID: <20250623130632.091305599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d594694206b33..906f2790f5619 100644
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
 
@@ -423,6 +425,7 @@ const struct iwl_cfg iwl_cfg_quz_a0_hr_b0 = {
 MODULE_FIRMWARE(IWL_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QU_C_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_CC_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-- 
2.39.5



