Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A221ADFFE;
	Tue, 26 Aug 2025 13:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215212; cv=none; b=tyvrWaoHfaFo7dgK2h5jQEtcgY5iKmDBZYNFzuZzsyHtk/AKTiwtoY5IHDgzPY7+KFjnBaelZ3/QqR1gJJugm6uChzlOsqMLZv1wQKYogm1g8POoUSGjNg/kkxUtVa335xW6muD8Tw1JRhYEWdUCQMRg20ia7wqgLRC4wP3g4E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215212; c=relaxed/simple;
	bh=CNthKO4RpuRqLRQ0nbs3xVyFgBV00lI1iWhhsR/7Xtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBOUeuygD2ifqL4J/YkJiPGgtRokJKgallzfR+ldVhPOo7U55VsC1BGWLMzx/605cY9znaoAx8iRfgbB8YlMnubqnHWTJQWEv10sXU8VX1iwRiiNPWjTMChOQMcRKa8kZMdRwCdwD9HEB/4scptkijTZQPvLM2qV1V3v7GCPh58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+vnDV0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+vnDV0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE0DC4CEF1;
	Tue, 26 Aug 2025 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215212;
	bh=CNthKO4RpuRqLRQ0nbs3xVyFgBV00lI1iWhhsR/7Xtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+vnDV0eq95XXh/Qtp465CAQ+SjKzO1PTR05l0JfQRsmi9ND4VTfSsUnVTWKT8flt
	 8F3mzoRDpL8p7KBk/u+nCHpeQ74R7A6zW73CRcXTdYyLHJSZdbjAQmJ1Qu4TOJGnB5
	 pYh+0lSLcrJuA94LAZD3AtttiMqKviih6HMbG0A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/482] PCI: rockchip: Set Target Link Speed to 5.0 GT/s before retraining
Date: Tue, 26 Aug 2025 13:11:23 +0200
Message-ID: <20250826110941.453382356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 114b06ee108cabc82b995fbac6672230a9776936 ]

Rockchip controllers can support up to 5.0 GT/s link speed. But the driver
doesn't set the Target Link Speed currently. This may cause failure in
retraining the link to 5.0 GT/s if supported by the endpoint. So set the
Target Link Speed to 5.0 GT/s in the Link Control and Status Register 2.

Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
[mani: fixed whitespace warning, commit message rewording, added fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Robin Murphy <robin.murphy@arm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/0afa6bc47b7f50e2e81b0b47d51c66feb0fb565f.1751322015.git.geraldogabriel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-host.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -342,6 +342,10 @@ static int rockchip_pcie_host_init_port(
 		 * Enable retrain for gen2. This should be configured only after
 		 * gen1 finished.
 		 */
+		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL2);
+		status &= ~PCI_EXP_LNKCTL2_TLS;
+		status |= PCI_EXP_LNKCTL2_TLS_5_0GT;
+		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL2);
 		status = rockchip_pcie_read(rockchip, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL);
 		status |= PCI_EXP_LNKCTL_RL;
 		rockchip_pcie_write(rockchip, status, PCIE_RC_CONFIG_CR + PCI_EXP_LNKCTL);


