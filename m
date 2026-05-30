Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4976621E098;
	Sat, 30 May 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163945; cv=none; b=k7lvu9CALPEPPylEAPgWvzpbr2H05IWp+lKVbbAe/6sUuMKdFX9MA3ap8wiNYpRIrUQH2GUdjSlj4xqU3U/mFhISG527tyyDpRp9bQBW/B9GwTgG2H4pqCv5l97frMWDckU3xgqwWFwM5HAHTP20iQsf2WBdd/fxvOcBCAC5GdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163945; c=relaxed/simple;
	bh=YQtiPbhujKNqUWSsh5GtmifLnEAXiThkqm50GFSijQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB3/+xHMQbm56XajUBId3yrbOfx3h6erytLbjw/q2bE3S040JtsUP7CiidTJXfTwtUGxWgYYRuRWGlKRj2Hzf3AYlEM81ifOY0KzLG3aCSHWy53mwAIduR8ghcfWrgzY2OUuaUCDd+XxZH1WYlJUb2CeKetLFT+dOD0NKHh3FBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv+kL6N1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv+kL6N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5015E1F00893;
	Sat, 30 May 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163943;
	bh=m8CzFJS/IbuZg4nadZ+zN6/JmWUbo2+sJ2NNqT/Nujk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv+kL6N1mpozuSzgY+r28f/l7ECynnAOSiEJCOaKkolLb/KoQz2t/S1CDEMat8dG1
	 zTWl9qpeLaSHI5ewnOrN6M1nODB63sBBcQTnrMME+O3E8cs/K+LOQOQrNbE/3kNt3o
	 NMgWt3qJ28sBegbwnDexXcf0iAO10iD3VYjvUJZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/776] wifi: brcmfmac: Fix error pointer dereference
Date: Sat, 30 May 2026 18:02:03 +0200
Message-ID: <20260530160251.062601748@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit dd8592fc6007a451c3e4b9025de365e39de8178a ]

The function brcmf_chip_add_core() can return an error pointer and is
not checked. Add checks for error pointer.

Detected by Smatch:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1010 brcmf_chip_recognition() error:
'core' dereferencing possible ERR_PTR()

drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1013 brcmf_chip_recognition() error:
'core' dereferencing possible ERR_PTR()

drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1016 brcmf_chip_recognition() error:
'core' dereferencing possible ERR_PTR()

drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1019 brcmf_chip_recognition() error:
'core' dereferencing possible ERR_PTR()

drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1022 brcmf_chip_recognition() error:
'core' dereferencing possible ERR_PTR()

Fixes: cb7cf7be9eba7 ("brcmfmac: make chip related functions host interface independent")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260217023043.73631-1-ethantidmore06@gmail.com
[add missing wifi: prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c   | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 1ee49f9e325db..d4a3992323796 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -986,18 +986,33 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
 					   SI_ENUM_BASE_DEFAULT, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
 					   BCM4329_CORE_BUS_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
 					   BCM4329_CORE_SOCRAM_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
 		brcmf_chip_sb_corerev(ci, core);
 		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
 					   BCM4329_CORE_ARM_BASE, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
 		brcmf_chip_sb_corerev(ci, core);
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
 		brcmf_chip_sb_corerev(ci, core);
 	} else if (socitype == SOCI_AI) {
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
-- 
2.53.0



