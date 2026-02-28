Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0937644CF37;
	Sat, 28 Feb 2026 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301290; cv=none; b=GwPVPOd2jMYufpxbRbcku+OTERHN8XPMmqVstG1lcLFc7ulxZewHig20jvcW/MsWUd2cuIcLqT186Z52teC/9BdeQYQM4/FjM/iKtxrutzv0BsVwIV5fSQ1/Fx/UsoxbdbaFBr1Nj2oUivJVfayca0iWhtWw38UPg0zPYlaF4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301290; c=relaxed/simple;
	bh=8wqob71KtSgBqkTPWa2ap8XMqtUohvTofYWek2HBphw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nntZOpTpuApMC7EYPyzY5ogVR9GBv+QVaHFqBqMhXb/HSxz4a2drdcDUn0bJqzkO7Nz8oN6QUVVCn1NqkXUgc18j6OnhFl7BZ2wxbH1f+WfTjl4+mZwU0uXq5SRKv+UEetgVeXHoWyuLyxx54urQJCEwtOTuv3vC734FUNuc22U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jU4jkwJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU4jkwJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1DCC2BC9E;
	Sat, 28 Feb 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301289;
	bh=8wqob71KtSgBqkTPWa2ap8XMqtUohvTofYWek2HBphw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jU4jkwJQgVkcr8voUWYfTnYxhAj1M3gqPwb2FBV+sxfsdHIey/ex8X6ZqZvzaXwNs
	 BRQewo1k9th4qMbOZxt8dpw4OfaYNqYl1iBJYjGWKMPEsCB2f5Hyps9d19Vqk2GTjZ
	 8gHxP/AXG+JVn3fqEMKfFG678SaSL9q0Y5pzLJ5lg/a7FtBRraexbSMwrtJU3KfbA3
	 YQLSXYx57P6XnZ/5Ik20dzwRKCriejTcfs2JPSb20S95Z9iwtwp+yayalxGmXSFZcU
	 NhYA9bvzycb4J5iyZQTtLwjYXvwvCKEkw2zTVceH3/CGLNSzELVWc8B6CIwZhP+IbR
	 HFJrIoI/YcpkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/752] Revert "PCI: qcom: Enable MSI interrupts together with Link up if 'Global IRQ' is supported"
Date: Sat, 28 Feb 2026 12:43:05 -0500
Message-ID: <20260228174750.1542406-474-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 7ebdefb87942073679e56cfbc5a72e8fc5441bfc ]

This reverts commit ba4a2e2317b9faeca9193ed6d3193ddc3cf2aba3.

Since the Link up IRQ support is going away, revert the MSI logic that got
added for it too.

Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[mani: reworded the description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251222064207.3246632-12-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 2e9dffbda4bca..2779b09dfe3ec 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -136,7 +136,6 @@
 
 /* PARF_INT_ALL_{STATUS/CLEAR/MASK} register fields */
 #define PARF_INT_ALL_LINK_UP			BIT(13)
-#define PARF_INT_MSI_DEV_0_7			GENMASK(30, 23)
 
 /* PARF_NO_SNOOP_OVERRIDE register fields */
 #define WR_NO_SNOOP_OVERRIDE_EN			BIT(1)
@@ -1953,8 +1952,7 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 			goto err_host_deinit;
 		}
 
-		writel_relaxed(PARF_INT_ALL_LINK_UP | PARF_INT_MSI_DEV_0_7,
-			       pcie->parf + PARF_INT_ALL_MASK);
+		writel_relaxed(PARF_INT_ALL_LINK_UP, pcie->parf + PARF_INT_ALL_MASK);
 	}
 
 	qcom_pcie_icc_opp_update(pcie);
-- 
2.51.0

