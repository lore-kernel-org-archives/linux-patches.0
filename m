Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208725;
	b=rvSlnoUZRaycYFFQlRJ1CrwCWhNE4sn1xyo97vZgc3uV6z5kDnHR67RMs1Tn1yPx6PON
	 BJp/ut6ehRUSZsqFNe3tz6JJ/e6qN+7dJwYxo+TeAMcGNOoyfObTrmVR/rWCweZq1pK7y
	 QSbP49Wn0TVszxxcGtL064a5Vs9vQgRNTc2QEfgkClR37brppEjPAdththCYJJs7cLf5N
	 37OdJnJVm2rjwdBhddLPT2LzMG8PP/HRXRhMI9JBi2jbZ2myc5Y6VmKPfudBciolaQgAm
	 ca2WkTz71PR3qX3KPdiDrp/x+oVjZvb1pX9UVqPwGNEmDPJhw+2l/GmkMwfo8PXkqaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DZx8MJo1z26oiKaUxxdgvOarSwvsACzztCp0FxwpQQ8=;
	b=vOsOPQHWA5cNbI66AexSd3g5fR9s5jtJ60cemNiB0nxOQHDkfBRb7PfsJw8TC6spanyF
	 JhOlbqq2NyiXm15LUPSaHJM9KFmooNlf0P50ZYIYyc5EtI/zmCsOkJAFLh2Ga7I18mSFX
	 8huUck6cYfEQxdzPl5JjixQb3J2OTVfIQw9d7AdpvXaxyzdkDuporFuUFwlJ+8kvQBNem
	 sVgKk26tqLwAbeeHDSivbNcCQoxZOIicSEOdp5BJEB8hsp0maYQbyfrrtpnejSzYanFQD
	 9rgcmRy4t7PpCGSdv66VEaBUqh3id6/ZKpPWM1l6/Jki7xtHhKMcxAE5RgrADOMht1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3j6MQFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A48606A31A;
	Wed, 28 Oct 2026 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3j6MQFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B41F01825;
	Wed, 28 Oct 2026 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208724;
	bh=DZx8MJo1z26oiKaUxxdgvOarSwvsACzztCp0FxwpQQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3j6MQFle/4x++8XW38As4Dtl/siYgVcRhqFuUXZGcPnKmKwsepVXrlxhxfZLY/eR
	 T0TqXWPfQC/yvU4qmOcX7uEEB7jVo/YRclGwPuTlIm4hRO1lMkwdYhcpeV2Hut9MdR
	 RwaEiDTK2QIvvAoxQ+jpZg4notGQnncfNlKynZ8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 219/516] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Wed, 28 Oct 2026 17:56:11 +0100
Message-ID: <20261028170008.690052880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3849,6 +3849,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


