Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CAF57F735;
	Mon, 31 Aug 2026 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184189; cv=none; b=Aqj5HvWCBVB1d5X1EF9nEbzRa6ljH1jdaw+YGfGl4SnibFJrNJzs6yEeIpJSUX8cb4fLvKbeFxTSEcn7gvHIFHai+GziND7lkE5MLHkMpKNTe6ruQo+vpo3hWz2cVCNMu9dYirNjgiq0GuUz6e2jfRyScT6HPu7itKAJGePXToQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184189; c=relaxed/simple;
	bh=QyxtNts+UoqhKfu3fXd5olBl1D+PUYnz0yC6Lzh+CyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZD40AuGqsm8AbfFbLz9xvngahU0/lCd4VyL4rhzV2ffcXHMlnBuw5vld51X+Ig0nVj2BagSWoGvsWdIGe8ubauEhqcVyF9vgKmjE3TePyxq2GuDVs6Vpa7imMEjK7kmx4uIcj+PiGs6Q65EtkyntpVtQpiyu+YLlmv3n31g4l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsGn6ptD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsGn6ptD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3759F1F00ACA;
	Mon, 31 Aug 2026 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184188;
	bh=so+s9aG25OaVfSWLBK6duAK1BVk2DhvJG48V+ALmSkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsGn6ptDEDt9clwZ4TNre1QN7Z4E/nOCpbeRT37AoReaHdkypI6KGbDdAp2HGFwMk
	 4VKBXNNuLH4n1uiHSMjBpWiCHyOREiElzKlNW2RnNBJfq85AaNDExuTFZTOO6VTdKb
	 4kiNJnXUhzKoZU4Us77Efi50mmsSh3xPSAU1RZKI2MkEVPWOMsVA4Fny2J9wpV6C88
	 vTBUZoi2oCGM3gcr1P6KStMDLMnoPdF4B5Ct/YQ2CmsdnKjNof5VFLU4ZX3CZpH0dH
	 Hn5J8Tn+KP3oHzftCyOGad4S6n6wP36CHc4W9rreIfpgoykW7WZ/6JgaizsSHG3jCb
	 HwOSvXHHaoUbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Javier Achirica <jachirica@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	mani@kernel.org,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] bus: mhi: host: pci_generic: Round up nr_irqs to power of two
Date: Mon, 31 Aug 2026 09:29:32 -0400
Message-ID: <20260831133314.4125787-544-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Javier Achirica <jachirica@gmail.com>

[ Upstream commit 86f6dc05ea051fa03ebc03174bc00f734593465d ]

When an MHI device uses standard MSI, the PCI core requires the allocated
number of vectors to be a strict power of two. But devices will only ask
for the irqs they need, so they might not be properly aligned.

Make sure a power-of-2 number of vectors is requested.

Signed-off-by: Javier Achirica <jachirica@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/CACixm21q7b_diEx5COZxVZm9EhZ0hnakM_WBjEWcCsznfWeniw@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background history search finished, but it wasn’t useful: it used
`git log -S "mhi_pci_get_irqs" --all`, which is slow and returned
unrelated commits (mptcp, SMC, xfs), not the MHI driver introduction.

From the earlier analysis (without `--all`), `git blame` on the IRQ
allocation lines shows they’ve been in
`drivers/bus/mhi/host/pci_generic.c` since the `6bda50f4333fa` baseline
in this 6.18.43 tree — so the bug has been present since that code
landed here.

**Verdict for 6.18.y: YES** — real SDX55 modem failure on MSI,
maintainer-approved one-line fix, buggy code confirmed present in this
tree.

 drivers/bus/mhi/host/pci_generic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 646f3bcdc636a..a5b47728f9aba 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1139,7 +1139,8 @@ static int mhi_pci_get_irqs(struct mhi_controller *mhi_cntrl,
 	 */
 	mhi_cntrl->nr_irqs = 1 + mhi_cntrl_config->num_events;
 
-	nr_vectors = pci_alloc_irq_vectors(pdev, 1, mhi_cntrl->nr_irqs, PCI_IRQ_MSIX | PCI_IRQ_MSI);
+	nr_vectors = pci_alloc_irq_vectors(pdev, 1, roundup_pow_of_two(mhi_cntrl->nr_irqs),
+					   PCI_IRQ_MSIX | PCI_IRQ_MSI);
 	if (nr_vectors < 0) {
 		dev_err(&pdev->dev, "Error allocating MSI vectors %d\n",
 			nr_vectors);
-- 
2.53.0

