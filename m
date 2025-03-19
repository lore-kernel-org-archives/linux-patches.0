Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B721B2194;
	Wed, 19 Mar 2025 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394895; cv=none; b=gw+XnbZ1Qc6A7+PJm5HpzyIUpHIp9oiBSAvaK9rwk19ULJQoU/mxf1+cjs2brM9vefJbdvHWGrMod9ciEw+qSkgL/9b7wTX8cH4sMoYnkQHrJNuqgdFJ1tU4ZL6xr5V8yJNFnW2wANaFn5sNfenGAT+mjP1h5ElmmSM7xmc96UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394895; c=relaxed/simple;
	bh=OBmqaeN1LBQ2WoGPckuSCY1FH49t1MPA1UDNxuVk+AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXiPpXVKKXXQjcANERp63S0czBH55z7H6+myphae/1eGD907MsZJCD1PoeBlK88UwIvPWZaqfJ9IFs4apFe7pjDug2dZjwpzrsPKlxGX61pNfXRb6fjMV8BBR96czf9/8LDUXV54iBY2O+rTYuHziqm307cxBglWaoMLWnqo5jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnGPecUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnGPecUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8124C4CEE4;
	Wed, 19 Mar 2025 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394894;
	bh=OBmqaeN1LBQ2WoGPckuSCY1FH49t1MPA1UDNxuVk+AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnGPecUSvVPbG0lRT3qA5LJxOj8GE9l4/K1KF7HMlCzoQuEqDf5BSLOU2Oehu8+XD
	 ARdPYavTxV5y8BqBBgeHbkuT0kmWetCpSkYI/NVnFBBg7oH+gihrCW5yNsja8nFZD7
	 gRToAYvTJ+H6ng8kvSeFLK/NYOs7qxRyFRgI9mak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 099/241] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Date: Wed, 19 Mar 2025 07:29:29 -0700
Message-ID: <20250319143030.169848310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]

It's sole user (pci_xen_swiotlb_init()) is __init, too.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>

Message-ID: <e1198286-99ec-41c1-b5ad-e04e285836c9@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 26c62e0d34e98..1f65795cf5d7a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -113,7 +113,7 @@ static struct io_tlb_pool *xen_swiotlb_find_pool(struct device *dev,
 }
 
 #ifdef CONFIG_X86
-int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
+int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
 {
 	int rc;
 	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
-- 
2.39.5



