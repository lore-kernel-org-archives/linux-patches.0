Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238993D669E;
	Mon, 20 Apr 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691425; cv=none; b=pM5JTmsTIzr2k699iwQxg7kPWBbstdJgsjbxdH3nj+VhVGNBIIikhdmoo/7gZxR5Zk2LjoYr0+GMsyTLMsqjPZ9ebFE39nseb0cJAsx7nSUThaBIHegZ1wbMkXZYtC1jtBQSP37U4YyrfmgfKMQAzwVB10DXFhuwlr8ZT1mF6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691425; c=relaxed/simple;
	bh=7NqUKGXE19hNF+Qt8VkidOdJ7qbVfJTdFXD5V3iLhbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1alPRXveL42pVXZdpGOBRbRgGs3BGPBgWKRSWXKotXvC8awGou+ISE9Kd4rpFv4hQ2axc+zCCHA/Ma/6/YsVOSnnwPGX7SFYKQc7ANd+wFnFLX8+QKOZ2nsYnprM2qi4/yhoONtM+frMKd5jhSmDHtcLSJJqexQ+O0tp9nZxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YadxvAqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YadxvAqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C953AC2BCB4;
	Mon, 20 Apr 2026 13:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691424;
	bh=7NqUKGXE19hNF+Qt8VkidOdJ7qbVfJTdFXD5V3iLhbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YadxvAqiF9DeWwRcuOD5+8nKPeCffewkuGWAq4SkqecrkEcAuT4p0XyQ/ThzsEMvS
	 THfg66pcBV0Izb4lni11CSh8LTjck/boBvJj7cR29WBIinFTuslFLLx8W+bwSPVeCI
	 chM+hpApPO3d2lF0G7jRY5ar+XuvRo6eEP0nS3HgtT7KLv2xMJoNtCvalbAgb9qgqy
	 zIw37Qn928GQgL2+3WigCyd+ibg2MCdP6iE3NyfT72jDU0Ya6WgOA/dpTGFO98wEvc
	 eU4XbfLl21pcDOsEsCWYzoqRQvU5I4zV2jDLXmK5AbkIh3chcAFz5iECrikP0/lgPp
	 bg/750kntWGKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: brcmfmac: validate bsscfg indices in IF events
Date: Mon, 20 Apr 2026 09:16:53 -0400
Message-ID: <20260420132314.1023554-19-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 304950a467d83678bd0b0f46331882e2ac23b12d ]

brcmf_fweh_handle_if_event() validates the firmware-provided interface
index before it touches drvr->iflist[], but it still uses the raw
bsscfgidx field as an array index without a matching range check.

Reject IF events whose bsscfg index does not fit in drvr->iflist[]
before indexing the interface array.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260323074551.93530-1-pengpeng@iscas.ac.cn
[add missing wifi prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index c2d98ee6652f3..1d25dc9ebca8b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -153,6 +153,11 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		bphy_err(drvr, "invalid interface index: %u\n", ifevent->ifidx);
 		return;
 	}
+	if (ifevent->bsscfgidx >= BRCMF_MAX_IFS) {
+		bphy_err(drvr, "invalid bsscfg index: %u\n",
+			 ifevent->bsscfgidx);
+		return;
+	}
 
 	ifp = drvr->iflist[ifevent->bsscfgidx];
 
-- 
2.53.0

