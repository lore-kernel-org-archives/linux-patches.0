Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212894;
	b=NyNsO+jPCk/gZsNgHgDtt8VQ8+GcaFPpLqivI+QIbRgXAv0A5XyesirrC37ImktqprE+
	 AVMBJSd+gw2rsosWQz1Pl3VhiuCcQsvh/JHbJIU1iu48vzy9ohKE2iIQDRVrtnJjXO+1Z
	 dADEE9nKUnXPJasxE8FnlezxgIpoEVKvrrVEUwCino3/OZUpO6AGqAUqrAN9qpzrr6z1a
	 v6x5PD1++WkcFuY0lo4WWTTp5hPa8m7ej3Tew8fJH1jey5tw1tGaCChyXeYMIMyFHAass
	 HpF8Nhw0YUvHVYp4aGeML8h/3POBFd3s4rDyYEe4zB5Qimd2G0Qdlb5/4gKLpY6B8zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=leR0d2+VWQBAlj5FKkhaDY0ZR3MstCMudAmjp4y0PfA=;
	b=LbBYjnNnajtHt20V1BX85yCwhBM7rl8/noBa4lBoRWdMuZjNYGwqEs/8/U+beN7KgyBj
	 OsvKkB7B2gVK59zHdcsfdq+YIqzXhvNFA+w2t+5qkx0IT6Qk1QRNdve3ofK9Cqs3kMzov
	 MSwvQ14UzvKMcwnS1TNtMJe2BKw8mPbLIDVt9kYOcLDGMkPAINpZJh1mAQi+g0yeC3IIu
	 2gEAraQN4veZceDfH3iPY97ahuYL07UyDt62Y6+JyBtYsfor43pPoGAO9jJS1BPhg5BJM
	 J3WH86zauDGmpAsit/u5cr1FbJbclTI3sP0GuWCL7KRPK8Wl6xB5FqIilWJVkVCwExw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmoQ8ZF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4757F606A31A;
	Wed, 28 Oct 2026 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmoQ8ZF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC7B1F01825;
	Wed, 28 Oct 2026 18:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212893;
	bh=leR0d2+VWQBAlj5FKkhaDY0ZR3MstCMudAmjp4y0PfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmoQ8ZF1BxRDLiA9dFAdl9fmxT2slaoUi47DXlbbtQqsybfyXIf1uQ+ORQfd+gd88
	 2IrT10kuOXqrAO5IjbrkcaaU1nDjYvSBNfVQlUYtJiMulV3RPSwxK4uovF9CWYVN9+
	 Iv88i51Cmpl5lLfjCTG1JnL2cq5Z3LQLjeLc0gJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0314/1887] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Wed, 28 Oct 2026 17:40:10 +0100
Message-ID: <20261028170506.373615971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f8ebe286394c0bbb4a6dbacb182a34ab6376922d upstream.

il3945_pci_probe() calls il_eeprom_init(), which allocates memory for
the EEPROM data. The probe failure paths release this allocation with
il_eeprom_free(), but the remove path does not free it after a
successful probe.

As a result, the EEPROM data is leaked when the PCI device is removed.

Free the EEPROM data in il3945_pci_remove() before releasing the
mac80211 hardware structure.

This issue was found by manual code inspection.

Fixes: 073d3f5f1b3b ("iwlwifi: changing EEPROM layout handling")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260916073736.2952028-1-lgs201920130244@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3845,6 +3845,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


