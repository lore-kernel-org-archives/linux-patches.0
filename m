Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062194;
	b=WuGhM/56MSRc+MgzkmH+pbiq/ZTGe31B+ywV+Koik6y8kkhgu0LXHSUJFyRtb/v8NsiN
	 ePRdo3HLprcbPA0P2D+aNkJ6OiBnwO+6vVq9E8U1cevBhbGfoS80fMrbenHs8UL4AVXLG
	 ufuYirAbmwFr+6/4ooeHD0PvpY1EkwPgRuZFdg3LCjqG9qI37vGegy1E0LLOCMHOtWVzc
	 qfoQEGCshNxcXTgCERxhULWsCRutZ3i2fdmz/IkmWB6P3pe9zZc07OuGyhKuPH2u8jN34
	 DvtD+Iaon22wzTqjfe4u7rnsgTYluSeMNFMzV8yQMorHuR9Yqyr2kCjeVSU94tg4Pzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utuEj1iEwGs0/eL1H1bVeJjtcDRBzz0pnDFVLQzLprU=;
	b=fQkRyZ74y9K9PTAjlmSTF1/ID5wpFVorobDCtnaYVKkNBvqZ3tt52RWhTq82LfhvnaRy
	 7W5QuPkNXNXTEMxQRyAzPrg9PKcVKgMM5di/+0o6/Gv6MIqeJBXkqFEV4zEoRTF5FvmBu
	 MWRZPXQ+m/rPsMNDRGpPK9U9n0bwgx4ZEb3TzYLWvsObQG7ZLVy2XakSpjvtjvVkr8a8N
	 ofeHgAuPr//uzc3/hPscBG1bb9TRPUd217f07mhKL1nR6K+yvt1ev6icNaqiIVIYH9ZNy
	 Iwjhl8a2RmvgxHL+N3VFC9hw+7gKzwtkVgskcsMnZtMz3mQLokh+LFHU9ttuKDyaAFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqeI+YJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147FB606A320;
	Thu, 19 Nov 2026 04:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqeI+YJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3003A1F000C5;
	Thu, 19 Nov 2026 04:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062193;
	bh=utuEj1iEwGs0/eL1H1bVeJjtcDRBzz0pnDFVLQzLprU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqeI+YJauaW3G9rcrLmxmdBQd+Kmuo6JsP+kGzwxcQMxsJ/l7qNy6WzvmX9/Svexk
	 3K/Z/nJN4AquGMW2VHpqonhfbgJH3NBg3dOZTczb2tAv7QVNnwrHBRAmG997RZi+P7
	 CZIFmQ82EtW29X99TfOGnrIuKbeDF/Ln7tpA5DPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1782/1848] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150033.942095246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 13b364c765e69db1f8446399d8db0b331c23b50c ]

aq_pci_remove() clears the driver's RXNFC rule list before unregistering
the netdevice.  Until unregister_netdev() returns, ethtool operations can
still call aq_get_rxnfc_rule(), aq_get_rxnfc_all_rules(),
aq_add_rxnfc_rule(), or aq_del_rxnfc_rule().  Those paths traverse the
same unlocked hlist that aq_clear_rxnfc_all_rules() is mutating and
freeing.

The race is reachable by issuing RXNFC ethtool commands concurrently with
PCI device removal or driver unbind.  A reader can dereference a node that
has just been freed, and two writers can corrupt the list or free the same
rule more than once, causing KASAN reports, list corruption, or a kernel
panic.

Reverse the removal order: unregister the netdevice first, then clear the
RXNFC rules.  After unregister_netdev() returns, ethtool can no longer
enter the driver, while the PCI device is still available for the
rule-clearing routine to issue hardware commands.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 8d0bcb012f57 ("net: aquantia: add infrastructure for ntuple rules")
Signed-off-by: Binbin Deng <18983559317@163.com>
Link: https://patch.msgid.link/20261020022630.515209-1-18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index f5080cc6266f9..d54940b393ac7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -352,9 +352,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
 	struct aq_nic_s *self = pci_get_drvdata(pdev);
 
 	if (self->ndev) {
-		aq_clear_rxnfc_all_rules(self);
 		if (self->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(self->ndev);
+		aq_clear_rxnfc_all_rules(self);
 
 #if IS_ENABLED(CONFIG_MACSEC)
 		aq_macsec_free(self);
-- 
2.53.0



