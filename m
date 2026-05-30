Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077A434104B;
	Sat, 30 May 2026 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160888; cv=none; b=LOVJBbThbwiI92u+TEVBc9YgTP0EFm5qeotK61OE19LwNSWoTooqiRF52TTDisThoRMkRDnww5vmauUBAmi8xfiXtE9DdCK18XEHkH2QVQEPsHYPjCa9EI0qJ5Q8+5zpQ6ky11azNWrAMM7R+cEzOhyx816ZsfHg/1IaRhVcAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160888; c=relaxed/simple;
	bh=3C8VvJDsuk8lBwc7E5ylQEmHRI2SiqEWVOYgu5aq1PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fud94reQJgmoE072XTfsDt1ZRkvBrnrWBu7YEUttUfmWgnSCrD1w/JQ8rdi1ErvaWd4sv/RLsyWZnHYdNzln547X7Y8+pj+4w+RDoncCr3bGB3lSKqI++MRniqOH2qDwZ9tn4sJp9koLHQpPLv+dAmJZti9m4fsHMw3OY+OyhwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx6DMWXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx6DMWXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533861F00893;
	Sat, 30 May 2026 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160886;
	bh=B2fh0MDD7bv6vlmDTMJhI2e2lyzkD/ag9QcKQOkgtTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kx6DMWXhdGjFmhvF3C6vtJvnyycTyu1zzCXV5+eIOPenl+fnNoIzaO6VvcHd2Q7XI
	 wyYXK5RB0L1mv3dkFjFjbmWO++yqFuz2bNneTtSMbEvyHgkHuwVwAnUE7qmCL1aPD1
	 clmz/ez3Bv1iMHGdUX6lc8lXxOOWG8VLn7ejQZDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 463/969] wifi: brcmfmac: Fix error pointer dereference
Date: Sat, 30 May 2026 17:59:47 +0200
Message-ID: <20260530160313.068849852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 121893bbaa1d7..1fbe5c721adf8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -992,18 +992,33 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
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



