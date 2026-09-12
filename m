Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BAE423EAD;
	Sat, 12 Sep 2026 10:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208768; cv=none; b=UQhj/PizLKf+sOyBbgtueCfmSsDgPJrvaNO92orNOYXPpQ8IsRMvG+6hSkHXDIcYrT999nMSNzuYuAAxppq2nOysBqTRsu/G3wGcT4NBQD7nuBX9Dk9mORziIq8070xDyHthF+M8O830zH6NkQesDn8Hp+7m1ekyiFvQk9aARUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208768; c=relaxed/simple;
	bh=DGUZF23YhsIcSuSNdg08KjeiqjMmhCXJzyiuEay1W9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvdhJrD3NiVEttQ2hA3Lh4676IAl2oLDTY4S7vJTzO4SvGGs1M5GZtioLDTAVaKgnSbHm56teKOn5a2j+7sustKs4qqh5oMaZcu+kcreZtCY00on/aYUz3o58NPtF3WrReXRv9ffo12SpZy9kUnSScOgRyTcCSIgE88uIuG1JzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A709OYv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A709OYv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18F51F00893;
	Sat, 12 Sep 2026 10:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208766;
	bh=TcJKZVfnFMEBjO3W+Ass3Bh8nLMpFaaSEOs/MVmYXwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A709OYv0z9nGjAWuEzRdjnerCvwXQVtjUVkREs/jvqrx4mCT5fxFwbSDG+BeBGFWc
	 BBqzyabkeLNmBGdSJcFHET8xOVb7kLZWJT2aOh+HDKnDwqPdWXgzifIq7X6vXlpWpo
	 QbpcyAtsv09YJ4ivn22I9Nn7ZwLcv1fLnFO7rRq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0647/1518] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Sat, 12 Sep 2026 08:46:56 +0200
Message-ID: <20260912065638.067592252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 3c2999d13eeb222ae56631aeb7ca248090f2b210 ]

In the last error path in rtl_pci_probe(), the cleanup functions are
skipped due to a wrong goto label. Moreover, the successful call to
rtl_init_rfkill(), ieee80211_register_hw(), rtl_debug_add_one() have to
be reverted. Fix this issue by updating the labels and adding the
relevant cleanup functions to the last error path.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260723120118.145383-1-nihaal@cse.iitm.ac.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f0010336e78c1..8fb9604c3c533 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2226,13 +2226,17 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
 			"%s: failed to register IRQ handler\n",
 			wiphy_name(hw->wiphy));
-		goto fail3;
+		goto fail6;
 	}
 	rtlpci->irq_alloc = 1;
 
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
+fail6:
+	rtl_deinit_rfkill(hw);
+	rtl_debug_remove_one(hw);
+	ieee80211_unregister_hw(hw);
 fail5:
 	rtl_pci_deinit(hw);
 fail4:
-- 
2.53.0



