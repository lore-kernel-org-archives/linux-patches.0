Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCDD1EF36E;
	Mon, 13 Oct 2025 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368332; cv=none; b=KYBpaGWf2YepKcG679wsiwQVT8430tMP47Dj32ACq8WqVKPHS/VjV1j2X5z+QD9GZ2lA4qUu2eGDSwLu/vyVEm2MkZ9ThphDTETn2+KfyTEq6iXegBoU4NrH3mE5u7uIaTQXRiTwTmvArGUwxOkpCRxdwxrqNqMncABwANN4Ros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368332; c=relaxed/simple;
	bh=oJRzvEuCI2MmDviYOgxmMyxXTYrlmGwbB4MTOYj5YBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvFhWp0auY07CoE+CzVeWAYibWx8EvD/4XiKUBkLVx+9NWu8q2UqzRNRTegh5jp9kViZzlOKg4XqZo0g3xxUFw0LwhRWRF9UFYqE/7ssRwv7CN9jyA5tHpZGsAj08lJG4YlSkjKuvgr5+jrtMxT2X+5FVU/BzPwWk1uuSxgt6M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UevdTvEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UevdTvEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A968C4CEE7;
	Mon, 13 Oct 2025 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368331;
	bh=oJRzvEuCI2MmDviYOgxmMyxXTYrlmGwbB4MTOYj5YBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UevdTvEjeAsaB2yf/G7ORc46T/jXoKqG0B7J1Kkg81Da8Bj2jkAar54DUmnQMe75/
	 JrGJEa/xP6KiF78EXhHgjvYg/ZFE0AOlYxTRyiWGt9z0QccFx0LxF2fL2YBnHlph2m
	 +89mGgojTocxt8aGtMk7byi+Ac8W8l+dMh7clOE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/262] PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation
Date: Mon, 13 Oct 2025 16:44:26 +0200
Message-ID: <20251013144330.591152623@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e1a8805e5d263453ad76a4f50ab3b1c18ea07560 ]

Fix incorrect argument order in devm_kcalloc() when allocating port->phys.
The original call used sizeof(phy) as the number of elements and
port->lanes as the element size, which is reversed.  While this happens to
produce the correct total allocation size with current pointer size and
lane counts, the argument order is wrong.

Fixes: 6fe7c187e026 ("PCI: tegra: Support per-lane PHYs")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
[mani: added Fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250819150436.3105973-1-alok.a.tiwari@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index d7517c3976e7f..4f70b7f2ded9c 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1343,7 +1343,7 @@ static int tegra_pcie_port_get_phys(struct tegra_pcie_port *port)
 	unsigned int i;
 	int err;
 
-	port->phys = devm_kcalloc(dev, sizeof(phy), port->lanes, GFP_KERNEL);
+	port->phys = devm_kcalloc(dev, port->lanes, sizeof(phy), GFP_KERNEL);
 	if (!port->phys)
 		return -ENOMEM;
 
-- 
2.51.0



