Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA33531F99C;
	Tue, 21 Jul 2026 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648871; cv=none; b=uFB3m3q7cAfJG+KOre2Kvb6wcySxNg5k4TUvaAj00UHi1r8E052gKeRsUzSZ8LMgHAb5qfKuGQQ/7v8kvfJpEYcAp0zZkEE/bpA/Hb4oN/QYlk6ATj6Fz1CHbz8pjb4qmSB5DmwIHLoAsBAbBfImwIUUUiZRk9QOrjWXGvjNymY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648871; c=relaxed/simple;
	bh=/KXRPsHQ/yiqvKiFkwc4l3LJ5IGPW3B0y1YP3iKlnOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndL8i3TDlnyZ/csid5ZEllNLzF6WFrR7m8T1+LhveztoIGTjOzhsEUgJ9pFahujJFXY44dVK2JjhC4XNVK4vOa/uU9YCdQADSCfD0osLfqcV9vo44Mzmeo2YMDFbcLuE0X5nC6zxkrtERquobYvKRAbg9DxDAJ2gbH3bpd3cuQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH76Ll0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH76Ll0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3991A1F00A3A;
	Tue, 21 Jul 2026 15:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648870;
	bh=bYKCg55S5jEbjENg9P8Nx3iVxC83RdTmX3AIVyGCw9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CH76Ll0CkFnD/JpoqhVmrkIAeMHZz4FfA9H+zRd3HF2FqGJTjj9+vLu9syj7qJzPm
	 lKoAmBKviuUN0P1EushkHKQhAj1i6K821o59JiIXh5qKAcAqyqdXr/O5xtju9QeVvb
	 TEN2fHikSgITBbRdA0AVnzWDNxSQsazkJoOd43gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ripan Deuri <ripan.deuri@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0319/2077] wifi: ath12k: fix error unwind on arch_init() failure in PCI probe
Date: Tue, 21 Jul 2026 16:59:52 +0200
Message-ID: <20260721152600.200520544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ripan Deuri <ripan.deuri@oss.qualcomm.com>

[ Upstream commit d5c336161088c588f85da64f48ba6deead194afd ]

When arch_init() fails in ath12k_pci_probe(), the code jumps to
err_pci_msi_free, leaking resources in teardown.

Redirect the failure path to err_free_irq so teardown matches the setup order.

Compile-tested only.

Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
Signed-off-by: Ripan Deuri <ripan.deuri@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260519192815.3911324-1-ripan.deuri@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 375277ca2b8921..d9a22d6afbb020 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1639,7 +1639,7 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 	ret = ab_pci->device_family_ops->arch_init(ab);
 	if (ret) {
 		ath12k_err(ab, "PCI arch_init failed %d\n", ret);
-		goto err_pci_msi_free;
+		goto err_free_irq;
 	}
 
 	ret = ath12k_core_init(ab);
-- 
2.53.0



