Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84D33ADB9;
	Wed, 20 May 2026 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294741; cv=none; b=LLoDVhVNacHE+rkVf6qcz3iYiJlG5PFrtxrcP8gJDYrTcqfc+YvdF6KEh7d5Ibvxl1oVPyTvjKLBYfWIO3xonwUhOi4FnMwfgPscppvuPcnT+ddcvJrWNrjo9Qy517vQJHU50a7dBmpFkAUhQK9paLlZJTFkEWijhWNMjD1MW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294741; c=relaxed/simple;
	bh=8LYJDvDy5EO32gmDv69cG9UYpQBGRdA+znuEps3v7RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDMvdP67HrXEiRVSefr2R2yYpcufaGNLHFJo8tmJgNFyc6NlEcL7a6K66ORygLeST6LRF1ENduRJA98wKtflg5qgBne9il2+U2Uze0kS51TyxoEu/MG3NxSdLEabLOzrrTPJUhG/QwbP+aWAEjr6C9fKpzc985pZJRNuxF7Quoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8+IrOyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8+IrOyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A152D1F000E9;
	Wed, 20 May 2026 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294740;
	bh=Xmof3vPyqtLcJsLaM91EHKGUnNS7+l/oli5iqEiEzPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8+IrOyClkxXKBTGHaFqFPbJk1QVjTS2RlD7gekcHx41ato5Xdxt8ZfhgXXGzU/C0
	 c4Hoc+Y+pYhy/vh1Y2ssVY6upSPr2C2O83cHt11S16Ke2PvgF5wVtFOmifxh3c9r2+
	 LbZX5347aDr85NtFv7zmrLZ+mSKUdrCNjgNYtJCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0153/1146] wifi: brcmfmac: Fix error pointer dereference
Date: Wed, 20 May 2026 18:06:43 +0200
Message-ID: <20260520162151.766590918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a790f1693b82e..4adc0d0e4251b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1007,18 +1007,33 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
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



