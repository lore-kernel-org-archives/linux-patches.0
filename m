Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC7F47DD4B;
	Thu, 20 Aug 2026 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244143; cv=none; b=pgFuo6THlogZ5UTMp20RwkipfUCveqAOODQeo7ie1BE5YTcPGZYE5+k9yOX2nEJ27jjzgYR/RqkmwO7qcYb9gbYLuiRSiJvjjbp3NKn4QfmvplA5vQnBjm4CJUHst5Q5VDbqT0/o8gjS+Tf1MRDQLQW8LDCmK210YME0jCZGFWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244143; c=relaxed/simple;
	bh=MjNT7CbVC/7bT4OpNj6dDwxtlxEZ9KtfUW8Rj31HliY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvMvroHXXY8yVI/kl+fWkfI6iff7/TZ0U9vlsgs9M50myzhOJA9fCXJddELJRZxXkEYY57fYfQnGKwaLyrMikHbnDXICrbZI2RRrr72wypbeKFGeOB8H6VjIrctqmqHpvgwxtVHxVdsS0TWPsoApjy6rU0FsPVhA1lFDJULFvWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1X0+uIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1X0+uIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35211F000E9;
	Thu, 20 Aug 2026 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244142;
	bh=Bmw1nTEDnCJQ1DcEzk5edYaOwNMR9h9BrhlkGziUt9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1X0+uIpPzOZtmy3Sg17kdxBLLDWzFvRsyDDRhvzYJsrkfudpuSGHZBaJ7Y5vss1W
	 sDOGK7qxPwZ4U7NZwLRCmekuAgQ0Shb/Dyx6m3dzdDVxw70kmi9gyhijDVynqWAjDO
	 MMqaSiaxsCqa+yjUJm0DuOsb7qzKk3NHn29Wb2IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/235] octeontx2: Annotate mmio regions as __iomem
Date: Thu, 20 Aug 2026 16:55:03 +0200
Message-ID: <20260820145218.477449683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit d0976b43956ee8c8bd093223df9115bfcf63dfe5 ]

This patch removes unnecessary typecasts by marking the
mbox_regions array as __iomem since it is used to store
pointers to memory-mapped I/O (MMIO) regions. Also simplified
the call to readq() in PF driver by removing redundant type casts.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1749484309-3434-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f918554fb724 ("octeontx2-pf: clear stale mailbox IRQ state before request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -593,7 +593,7 @@ static int otx2_pfvf_mbox_init(struct ot
 	if (!pf->mbox_pfvf_wq)
 		return -ENOMEM;
 
-	base = readq((void __iomem *)((u64)pf->reg_base + RVU_PF_VF_BAR4_ADDR));
+	base = readq(pf->reg_base + RVU_PF_VF_BAR4_ADDR);
 	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
 
 	if (!hwbase) {


