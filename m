Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015462;
	b=Soi0XyDLN8Z+/wQCZsLoGmJrIY7y78ePcXxPmgcX1MNtxzL2g1EyULCF8tbUzbPxlyVH
	 AkI+ih9Blbf5XzstFO3F9Wbx0h6hcZivQqfFx77184lZEmzZ3Ljc2PhnBHK54AUJE48Ow
	 ivJYewK1h5Dirgi5uID4Ekg2eRMkYLeVH0YEGSGflLTo4W7EVXLlh5USh6JoKPOuOmTKc
	 ET2qbYYpt+wTV5/CiT4hj5UZx1oupoL7h2Y5wna8tC8dOvE2+B7cqG8/Y+k8qOv1g4TMH
	 sJNU4pH2YDpUZHnIMcU00Yu8GsimMiCJi1Rbl6NTz/hT5O515hkPU7a/CRb+neutTyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K6lGDEYwi4iyqoGgiWrzNHILt4K5ylKxi0azYFkNnEo=;
	b=Y0k55PD6vsU1/2EKQOBSDAMHRXrzee7T9HhEg3SGgkEP3jlb/N20hd2n3UiPniz5KnDi
	 Wd88O6tozHh8mJHFQf2uQHC61e+ws1iXLiVVjr9Qmp6bYhZBTDy+xdU5Ht3bx+mNWvxcQ
	 pTeoscPRil8J4MyuuMb7l08eaNFvWDhdBp/0yU7khljq6mo6YR28RTQmQIzu/7cgXUEUZ
	 7Nxixk/UOXB+pllPyJF0OSjs1xyor4m50F7oeUPYdhxf0QA5KDQSfmlt59SaqYhsNuzni
	 bPToAosmOB4fx7q+riRl/5hm3YLPzehUcSHio6XYrTbhdyTZVHNU618vhDK0JWWivXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDtFXa02;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAEC606A32C;
	Wed, 18 Nov 2026 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDtFXa02
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8F81F000C4;
	Wed, 18 Nov 2026 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015462;
	bh=K6lGDEYwi4iyqoGgiWrzNHILt4K5ylKxi0azYFkNnEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDtFXa028LRhT+AT70KDxVWsn0zHjH6gA2g1xJ51xqhgvRV6zpEeEjgY+tZzSAhew
	 W8JV/HCS/IeML3+eauJkLmViq2l5fKP4r8GpNOsIUmRcv6iC7AywCCVe9D0T/u72QX
	 re8uxTdE38OHV+ke8EF4J+HLXQZZ/qBcMnCQrvUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0182/2651] PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming
Date: Wed, 18 Nov 2026 15:23:42 +0100
Message-ID: <20261118150254.414900036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit afe2aa9dc93d904730bab63f5ccb514a318e6464 ]

vntb_epf_mw_set_trans() programs the memory-window BAR through
pci_epc_set_bar() with hardcoded function numbers (0, 0), so the BAR
lands on the wrong function whenever the vNTB EPF is bound to anything
but PF0. The other BAR programming sites in the vNTB driver already pass
the EPF's own numbers.

Pass the EPF's own func_no/vfunc_no here as well.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260728172306.2751813-2-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 8ae50779452a9..b6139e8e09a23 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1438,7 +1438,8 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	epf_bar->barno = barno;
 	epf_bar->size = size;
 
-	ret = pci_epc_set_bar(ntb->epf->epc, 0, 0, epf_bar);
+	ret = pci_epc_set_bar(ntb->epf->epc, ntb->epf->func_no,
+			      ntb->epf->vfunc_no, epf_bar);
 	if (ret) {
 		dev_err(dev, "failure set mw trans\n");
 		return ret;
-- 
2.53.0



