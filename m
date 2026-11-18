Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056844;
	b=SH1I0HT0TQ4XTRs0LE0q7+vvshs34WRJ2FSMASbWDaH0oHikvN53XLqO/tkGpavtklPW
	 qh1HI0DbPBrALGSmdfk0Ln2nTk1hQpLyqMyNX8x/3OMaWFNRt2GedgG4zEE4yfWCVqsSe
	 kBQwJkIIgkHFhWmx5eRBkiwxZEBtNmarNryXJPpORM9ce1XEQ6zHeWDaPS9ngqsXPEa7y
	 VhpkWUpX0euNB6JHdtJhqDaZbk4l7niJ4Q6OYWfkAA7rWTcUCxcHU06Bn2lYmgoYFbZpb
	 XEsiODV1y0awETDemYuiHeuwtFpHTVhkDDoLZhdf6M86C2fQ64wMwgq9v0c34N5/h5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rS/gCley1u12FotE2KoBCqT+CCCwbtUWP/pqUtzkYnE=;
	b=OEmZXfvyFSrykevDV//mIrU3q6Uw9Tg+4ogXdtPhvYtMo2RX2mBrBEX2492/jZIdE+C+
	 x/Si5LcNwEsQfeSaY57fRMKGJ0YZ1xYj/VZtWn0zDfAVLChUTBSWb0Nq1l8WVNKBkweFX
	 INBiPTOqZB7q+QPf1cH9hgcgP1Ob2tfIIpvMM3z2PTEBtPU9v22bjtOJM+0wQQ0OBaNWZ
	 2JjTtD3ZyEh+44xewhgM6/0bqVryjheOi6LH3ZafexqfsWoL56FhPY0qKSYoTSfSwl4rs
	 u4NY3EGgyziNWMhPY8PryXb1vnRSnOMEkYhx7dM8o5T2Cbjlhvwek9agMmfgzj2EtKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kK1wvxkV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35705606A33A;
	Thu, 19 Nov 2026 02:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kK1wvxkV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411981F000C4;
	Thu, 19 Nov 2026 02:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056843;
	bh=rS/gCley1u12FotE2KoBCqT+CCCwbtUWP/pqUtzkYnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK1wvxkV6AgWy5ytdfWxeIqQt6YQk+1ijuqGhg/HriwNIrS/N4dx8RIKhPzt7jtet
	 oFWrDjBimRofv2SxaV65RcGGAN2kdbfkG3nvp4QLi1ObSqsykZnni4jnGaMaqf+mWi
	 9QHkw9qG7VvPT/b4J9EnQDfdynY62EjyvwAmqpg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2133/2214] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150135.869609844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 4bb6a58d75a43..40cb0d336944e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -346,9 +346,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
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



