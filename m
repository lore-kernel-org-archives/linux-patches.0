Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211033;
	b=FIbHEmJsXY6yjcxBTez8TvQ7FXg6Do+ZTPQxfzNbhm5IOvRxJpMIe2dWA3PQaGvVg/MH
	 eyNYXkYyCkvZ92SnBiCNjptJybfJSbpUJpfKrUOM7p0mVvRT7gyMalIw5QAUfv+7Pw+TI
	 mFVDz0X1kJAkcrXjiw72U+jOtLHbh1qaJGhiN8T/KL3EyECA/49pA5giudKqHVVIcsmMX
	 R27K/3jXhxY5TcD6XGEdjT3hN8RQwd1QmeE8tj3uOthOnADIw+NXNC4RMa1FnFQf+oC1b
	 RfiTyNLsiwLRH+xNaUBpsPQuhcdWwpFmMdwDJHyqJ8i+4uA/Qzk84rk+zn6Bmuyoogw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2LrQJcWny4Xzrgy6+/7TR943Qok771AC5D+c+lzROWQ=;
	b=p7SUII5+DCkhbUtDDLUVCyd7gORyWyJIRt1AeRM7WBSC1HXEMO3cv//ffh2QXz6hiQ2A
	 SnV8jPdXVwHgjGJRkxPgBI0JBHR4mukWw5S53c/4r9Nhv3ejk1om/kFMuCth3xL2icgUJ
	 zpoPXTOZemduU+OK2qkawDJllrZRRnuM9RKpOULL7Sor5TfU6jose4TWIsHzcp32Cn3lE
	 we2r3qyZraJXr13jax98aaWXs2DNjSb2VWJITaY9zojqviYrIFUh4ToZfDspQt5zi/Teh
	 eSkfddEa3UB/tDgrEW0b9rXG3wezymaqtCEUGirD+yfRivlmL/5/Qu6VFsBbp8y20kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bysY39xO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF560A2603;
	Wed, 28 Oct 2026 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bysY39xO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371CA1F031E3;
	Wed, 28 Oct 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211032;
	bh=2LrQJcWny4Xzrgy6+/7TR943Qok771AC5D+c+lzROWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bysY39xO6hEi+OR1gDtFreHF3v4RPdbiuIARIKx+gRdnv9gbDS0N96ZNfmIkBkXKd
	 ObiXhAzTNHvm/+p5Aa7iWzCwNJZjDxH+hXdng7Nma7QfCrtGY0ZqcEMRJFjQBx9tOQ
	 Gi1ImNUYjV1v64VM4ffmLSaZmc2mVpI/z2MTgpVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 236/571] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Wed, 28 Oct 2026 17:56:23 +0100
Message-ID: <20261028170013.606191442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


