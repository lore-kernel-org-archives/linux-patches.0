Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063947;
	b=TjC7Eh2Aa0RvuQFV5LLwimLSymuaCFSY4PmEjYdqNuO+3I0Simqwb9MnaXpAQis1F7HK
	 CMIZLLfQQj1jAmdWcv63fS0uPgLC/blgUV2Br+yL12HVUcm2jXPH8RQ3DVFF7m1MEbOg+
	 y5YTz/RpI1L3asiHnIpTInCS/4Z37DEM7lNsNrwaI37alt6aYZSTpbyobyTX/jUJDX60V
	 pCVPQ3JYVE+tcyqzEPSv/UyVlpe6sz09LbDOTMNfwiuxyGny8lJiQah10bv5Ocde4462e
	 QqgtI1g0BWD6zI3m7A+axqpjsg7Uu/e6NjuMeuiVvaDaxfgX6phD4w+dvjcgbPVG2/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEYDFSzMb7BSkOR1H1PwTNg0fsq1UavObxM2Wd3tKqc=;
	b=PdbHHNSfEbQ/IYjj1WrSO8Ea3DCaMeKsQuKpkYM9hFK8BKkc3D2mheHMaSwtCnwGg2Yo
	 Ac6oTf9tr1rpppAOR1rkToyAycMRs7l9E168xAUo4I4QIgZPPii5KG6cGJogRIYAgTto2
	 ctw3Ma4zDJHyAiDk1rUC8+sbi2JlfEW6U+/2Lt1UyDfXSTM7nfkr27dTiyNyobgk5ic/T
	 qKS5BkDUeEcIeb3/zkzHq39EC/gAIfguiwWiD4ipEbXzyAUipZ14aREOFqiTmstNkQBlJ
	 OJRrURgQqPeCP8GsZcM4waJFAQWLhJUIgB/RTIcCbiuItdjNZYjgLZSRkULXLyaNrfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFB9cJtc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4AB606D829;
	Sat,  7 Nov 2026 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFB9cJtc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4876C1F0089F;
	Sat,  7 Nov 2026 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063947;
	bh=XEYDFSzMb7BSkOR1H1PwTNg0fsq1UavObxM2Wd3tKqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFB9cJtcSjgkXYO5QeAyzizRbZFUfYDg4Tpz4aNVNJaokrt2GeXZRLXL/l6DRnnZX
	 m7haoJAbLwqEw7smJUWA7sxRifQq6f7oxuWgD6dCR8yEJ2i+k4Gd4vV6UrAcLkuHcw
	 ZW4+Z2pKU86QYDFi120+YhvAmZ3R0goFiUx0hqxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0139/1257] PCI: rzg3s: Disable refclk on probe failure
Date: Sat,  7 Nov 2026 08:40:35 -0500
Message-ID: <20261107134943.148865244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit f03f56f21ce0770f38f3251924a0ca98699c38ed ]

rzg3s_pcie_host_init_port() enables the PCIe reference clock using
clk_prepare_enable(), but if rzg3s_pcie_probe() subsequently fails, for
example because pci_host_probe() returns an error, the probe error path
only releases the clock handle with clk_put().

Balance clk_prepare_enable() by calling clk_disable_unprepare() in the
probe cleanup path before releasing the clock, ensuring the reference
clock is properly disabled on probe failure.

Fixes: 7ef502fb35b28 ("PCI: Add Renesas RZ/G3S host controller driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260811200013.185956-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index a1a78bdb7af11..01488660ab081 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -1897,6 +1897,7 @@ static int rzg3s_pcie_probe(struct platform_device *pdev)
 	return 0;
 
 host_probe_teardown:
+	clk_disable_unprepare(host->port.refclk);
 	rzg3s_pcie_teardown_irqdomain(host);
 	host->data->config_deinit(host);
 rpm_put:
-- 
2.53.0



