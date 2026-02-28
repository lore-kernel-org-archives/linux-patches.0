Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2AD38D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302168; cv=none; b=GZ1qEKQeQBF4CgR4zYC9n7n/5y3WA0vavcgYwnV2sgqueRnssX0Mcox4VcLCCpn4r8TKyx/023TxTemMAGxngBph7jrXNelnw/W+82sZL/h/MDOHn8t3+EC3SxJ4KcPRcifNnLxsme4iNXhN7GMlcGODWJOaUJqV3UkFAYu2/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302168; c=relaxed/simple;
	bh=ULPVU2D00xZ0CNxEWLzRWNoPJpR413weR/RillGL8E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqc6diwmbNE10vRgVZPwvY2/Cq1m8V740hGCTK/ni/kS4bmZLipv6fZti+qUy1nM6DLSgRXLmviwaItzWpCQgeDmfP1Y1LQ88vneH8jUJV+JCU0/puauXt7gflpRFzke+qXycnaQbjQAKunh0qqfKFmoB/nw5ZwSIuw/uhkb6io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQSm+cRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQSm+cRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF60AC19424;
	Sat, 28 Feb 2026 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302168;
	bh=ULPVU2D00xZ0CNxEWLzRWNoPJpR413weR/RillGL8E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQSm+cRD+PiakovnSg1KOrALhtx5+GN1inO9T0LCViiPTB6507nEeU1oX2EooPnBP
	 fHr4FXT7ceA/q61GKAJCbbJANaIiiNCdx70QrEbYhInpeZGXM354Ra6n4AoF6/ctRE
	 Gt9A83pNMi1QXRnrBLDUHcdThbe0qVqWPFQvAzgDxeSxI4VEEPA+usu4W4dTO7ms91
	 wwH+xzulQRj6Fw/hY5cuJd0ntv2fzwdF6BOY5XIi2fLjg+K4U1FSHRuNb8aI7DtQhh
	 hWaz69z+Nsqgk6bptsrjrTuf9wzSlDSnQss8keJq6XQ3Zfgs4m1vVb2unaTbZBf54K
	 zVk/zSG0P7jyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/283] octeontx2-pf: Unregister devlink on probe failure
Date: Sat, 28 Feb 2026 13:05:07 -0500
Message-ID: <20260228180709.1583486-165-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index b4194ec2a1f2d..784130b4b0865 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3097,6 +3097,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0

