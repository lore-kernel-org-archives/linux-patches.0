Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0B91494A8;
	Fri,  6 Dec 2024 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497670; cv=none; b=Awf8vBn/IP3cPlLS9uxCGN1PIUGpcvcVOc5Kdt/Q3XHDqrLPROta4if8Q75cgLkNrYjlB7qRFUrex+rSTzqN5GJLbzVstS7MMWLdJDYAETXXzqHfyBdZzVmtP/rhHjxaC93AgOMPC+cmGN1rFE0mETUX/vxaGsh3eyrGP0o4csw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497670; c=relaxed/simple;
	bh=XSkFWBmMoiv/2fImnniJoTgIt31vClKPo/RfmwigCME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RtKZYPCq1wlpVMXzLowsJYnPaREkfI7oFQjHfnbuBqrF3zlEl5x+DIdDGehEF6H+AmpENFrMYSJdxebtpzR9FMCuiv0+LOVnQgsnzqPrkTq+XBLPdlrNmlCgCAK8MW6Ds9QytY0G0WCrVIHAoauVbHkeNfiDMCNKo2FcvVJ7HqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTAE96uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTAE96uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DDCC4CEDE;
	Fri,  6 Dec 2024 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497669;
	bh=XSkFWBmMoiv/2fImnniJoTgIt31vClKPo/RfmwigCME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTAE96uP90Az1APKNKIZibZ0NTF5V1Tcv8lka7S2t2AknPrL10SpHEtphaVtKYjfW
	 JegRC5qHUYkH/sZbrj8BofSLMaqu7350xlHpbDPyoLb2ATsdiq+tYpgmi3hpsC+BAP
	 V6ZztVz5cOiIIGpL2ZTm8nzJjjIsgdPeoBKJH6T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 358/676] PCI: Add T_PVPERL macro
Date: Fri,  6 Dec 2024 15:32:57 +0100
Message-ID: <20241206143707.331366347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 164f66be0c2523e65df41b755c41b7c9ff58035a ]

According to the PCIe CEM r5.0, sec 2.9.2, Power stable to PERST#
inactive interval is 100 ms as minimum. Add a macro so that the PCIe
controller drivers can make use of it.

Link: https://lore.kernel.org/linux-pci/20231018085631.1121289-2-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d5e9010a135a1..67ec4cf2fdb4c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -13,6 +13,9 @@
 
 #define PCIE_LINK_RETRAIN_TIMEOUT_MS	1000
 
+/* Power stable to PERST# inactive from PCIe card Electromechanical Spec */
+#define PCIE_T_PVPERL_MS		100
+
 /*
  * PCIe r6.0, sec 5.3.3.2.1 <PME Synchronization>
  * Recommends 1ms to 10ms timeout to check L2 ready.
-- 
2.43.0



