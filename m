Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE4C32A3DA;
	Sat, 12 Sep 2026 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224134; cv=none; b=nIYk4p/Eh1PbNLqDHYcDFhgY7jm/8axCusiX+5FdsjCZ529T5le6JAYmM7piNFS8jUiYtWlJ0/6lI/xPQopEtDIFdvhoSIvMKfv4I26VNg3Ef3ZlaJ+LLSTkmEtQ8p1SrzNsRLyO/HrlBP72325wXrqGE2HJu4ERQhXIQuaFNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224134; c=relaxed/simple;
	bh=/rn60qXsrmocrNwwsT+roHVOf/5mLsVvPBs3AldSyk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR0SssjNvwIDtDPJENDKL31A7JcU0obS+ssHXUO1NhwxYgeFnyB8QCFLySgpI1qEl/oQpu9iEZAFJH10e5vyvb6GJ1mCLMKE/jD2sunqQTDeMJGESrw/Nfte2iqI5y3ZeebBH6eqmzjR1xywYC5ttsN/04nhCiihsCPFBC1sAdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FU0aJLnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FU0aJLnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E411F0089A;
	Sat, 12 Sep 2026 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224133;
	bh=jzcZGJ/stRtgvI2ZqfKknUXYODczhHqv51IVRsQMapU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FU0aJLnWe/gPm2pvB5FJxlV5QpIwzwFC7MXBYsapKPV2qzY6KmqjqM54EYmv/p0ZY
	 wo7ifS4TISqjbP8A1tPKZhwbMQdddXB3pRWA874mGtGXusiHiBXKwezlzB3PtBJj/h
	 b/mqsnwYXJ5GrVrJopPToShW1ZnxNziqhHj3zoWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0931/1424] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Sat, 12 Sep 2026 08:56:03 +0200
Message-ID: <20260912065628.172010416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b978d31e47ca9..7bd72cc1f6626 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2228,13 +2228,17 @@ int rtl_pci_probe(struct pci_dev *pdev,
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



