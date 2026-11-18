Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027989;
	b=psweLeFMfjiJCxaJKP/WYn5V42Yb4MiUsDoaGjH6oQ09z0TpOtYrzGiGq05YkxTfScxS
	 n84rmEfLzE56y10sbW82L1X22T7Up40SXzPfekQIIVUtDvTFjS/+7vgXdpqfjcLZRMEm+
	 VzzriIhDKhByREHbffh8zHT8UAuTV4likkYXLH850lTO8A+K/DaHLCKaKnq/WRuRg1umy
	 lYdmcS+ui/bMjk/D/aY7Ue+JUtpb2LA1Vpn3WgUw+PkHlHk7HRvSiPzjsRmMWSo7YAPa0
	 YKYT4revvy5HeI7Hf7daMItnprUrZAfXg/1iTtyb/v1hynGv+Fmcl5nmKxwmJosin5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yjTqT+FlBidKvGmPGmozuiJus1uLZWcGsmKW+RA9U7M=;
	b=0vZw3bNyu0tf9l3EPVCtnc9qsmsru9HBz4J8d4EDUq/MnLPBEegN0XY2f7cEy66gn44V
	 DNGdr4iJ1w8Egm3BZa887jKEtg/ljcSj4T4M8uC92eU7J23uE0HkN5De8M/K5GSiBT7YD
	 zeS91Eg2iurZaUfe0xM0NH6zcMrPWZVCspa+Ir3JGPjysA/13WRN7Z/0zQx1K+UE6oP1q
	 iNEQFKPB1UOOF0roniS0IgrzZGTmsJEzkgmIRckn9HNPGhyopHh6o0VuEDVaXenSqa1Fr
	 G7rW7aQ/IXIGRG4OKhlErKQwkrQzI85hsJnCol4iInhaSE8tkGSilZQL44ZTKFvwK7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOFdAVeq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A844606A31C;
	Wed, 18 Nov 2026 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOFdAVeq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F021F000C4;
	Wed, 18 Nov 2026 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027989;
	bh=yjTqT+FlBidKvGmPGmozuiJus1uLZWcGsmKW+RA9U7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOFdAVeqwZXqNhpoPI2rPobXrCoC51WGT3erVJ4ZSyn39sT4+rVSQivtg8HPa0TIa
	 /5d7GqNauogu6s6PXprPoRjpNVYxfdyL4fGSP+I9o+Cs6qjSCeLZTgMapA6y3/C5Fv
	 s5GtFbROLJdIUL70CLIeG/NOH+lzoyOBx1i2tPRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1984/2151] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150234.004309535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 80bf71e1a9ce9..81a72bc160b0c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -343,9 +343,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
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



