Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA84196C89;
	Thu,  6 Jun 2024 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683476; cv=none; b=YsXNoCDtUH8W5x4/igrfCc000XOgI4/2Sq8q10ehxB6HL+FsaIS/tIBPHBpWvCP7V2D+B49UxooNJ101rBlWc9KYS703NBjxBfkxojYE9mgI1qX2DVmxJfXU7caoiJgNWz9IofgBR3R5ocQ928HxERp5RtRxYU+5UpWG8GUtlYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683476; c=relaxed/simple;
	bh=ShYC3OW5hF4FEjbXX55ElSyp3BYBTz9An0PMHK+ortE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dM183uGH2kZ2UN/RknxeGHKSZFVD5iK0YCVWpH2rJdsDTcFPdVSO3oVeKxk2M6OVNULEwG9E0EJzqS8cUy7oQSU1oZ4m3glhlBENlK/S5fLTO6FuSSvTh3VNGCTvgl4eomvZu7ItUJDBrmA9msgZG8biu1AuxiPLXNdQl66M8tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7IGR3I8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7IGR3I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F49C32782;
	Thu,  6 Jun 2024 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683476;
	bh=ShYC3OW5hF4FEjbXX55ElSyp3BYBTz9An0PMHK+ortE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7IGR3I8ES0QlUW4ZXVO/Z+pVAXN4OO50zO9DjScrwoQoH8pEeSYaDkWaJFHkdyVj
	 W3heIERz25hn41mGjN99I7E3+K5JFo8MdFKhvC/SJ+AV64B8z5528E/xkvy9ZGaG9b
	 FmwIrr+C7cml+QDipaLxBOixykLBpeX+m0+AaApo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 419/744] PCI: tegra194: Fix probe path for Endpoint mode
Date: Thu,  6 Jun 2024 16:01:31 +0200
Message-ID: <20240606131745.913664000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 19326006a21da26532d982254677c892dae8f29b ]

Tegra194 PCIe probe path is taking failure path in success case for
Endpoint mode. Return success from the switch case instead of going
into the failure path.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Link: https://lore.kernel.org/linux-pci/20240408093053.3948634-1-vidyas@nvidia.com
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 248cd9347e8fd..416d6b45d1fe8 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2272,11 +2272,14 @@ static int tegra_pcie_dw_probe(struct platform_device *pdev)
 		ret = tegra_pcie_config_ep(pcie, pdev);
 		if (ret < 0)
 			goto fail;
+		else
+			return 0;
 		break;
 
 	default:
 		dev_err(dev, "Invalid PCIe device type %d\n",
 			pcie->of_data->mode);
+		ret = -EINVAL;
 	}
 
 fail:
-- 
2.43.0



