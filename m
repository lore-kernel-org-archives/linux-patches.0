Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CB91EB5FD;
	Sat, 12 Sep 2026 08:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200291; cv=none; b=ZAqJznzv3tqmM0QpQleE2IGOVAVMmWIwLIiyDphE870OhFSstC3WKksT1Lg2uWEIzdMEInCaLFa1BU6eDgT5xRVjzD4J+6ZEr+zgACiB5U6AFEEONeo4K4VgttIIkb9M7h9jKdbRX3iZ08ZkjN8JnZbxpmGCOOpaY6eCtEDGzMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200291; c=relaxed/simple;
	bh=N3jExd7jysGKIH26V0d38NXboMVQPIa7OcZ1nd025/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNO1u1YiD/jZ6ahLhQuakTCu1Nmru34MzPuuft/No5Qv9+Lby+bnQRzZZxYBGouDBueTaFzHHRWt1GJul739soDT4x07Lx6x+1ufkHRCdO79vnemrPMySR7GRwNi+Mpo4wx+MQSJejxXb9i0wpYpoot59rLmYBUG/y8+R9boHWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAxwdyJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAxwdyJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294251F000FF;
	Sat, 12 Sep 2026 08:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200289;
	bh=R+rd/3YVKJoajWNn32DyxXzABIMtNtO8YU+exDVRPRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAxwdyJphlNfBjIwnudLoyJcNsxMbZkFRlObpB/m95Q0G+pI4xKCUUtjMo+OlDUgJ
	 PShtI1oSHzbAZL7A5+TSyXaDtP11FkqvMM/vvd3b2KJhMsXR4ECWCIdEumeTXRW8XO
	 Uyhn4PScoCDxWbyQ73dp3+ZR8CiRzulVlDQPTGn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0759/1815] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Sat, 12 Sep 2026 08:41:49 +0200
Message-ID: <20260912065706.726877107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 73018a0498b4b..de74ff8f6eee7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2227,13 +2227,17 @@ int rtl_pci_probe(struct pci_dev *pdev,
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



