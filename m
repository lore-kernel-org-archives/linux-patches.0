Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012D924A06A;
	Mon, 13 Oct 2025 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369371; cv=none; b=DqfFBMBPqvMzBnEyCRtYK2NfpH5qHctpbkaxSrX3O8VxjqZRvAv92T56t0CGDUN9s1DITfhbdf4fjTXOtMZB2QEPD1fWk3mRbt+wu0hMvpnlq38kY6YuHHfLapDVmeQ5CSnrBPlxPyGKf2xRIB154DtjLgAQhn+G7WEk5AaaNq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369371; c=relaxed/simple;
	bh=Ww4tNlScWI5474GnrGR6yvwCN8d3SY8FxNDHcOYhluc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZWGIKBJbUA6fmjF5Mg+faOUhkjDwMy3A6udqRhsPRUu5ZrVeu/eJF7P3uQn+JmIETfV5dc23K70cZ93z5GGx4ce/jr6ctFd2Sk6DvfHopef0os6Nub4cVWXKgDSec6dHLHwDAsG1cjXlQl6DGtVj+8jooVo+kcnjKB2eZ5VAL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H68rGoBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H68rGoBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8256BC4CEE7;
	Mon, 13 Oct 2025 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369370;
	bh=Ww4tNlScWI5474GnrGR6yvwCN8d3SY8FxNDHcOYhluc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H68rGoBTZBBt0Uz+Jj+M7fWDFJeyGMBjWPI8mZpaW0sTUNVV2sPpfjaSS0CIjuX6B
	 kibylNcfS03IzAKTWM9fz8WNG4RntDkEWH6niCJoLILQ5R+bVpWoyqTzw5/fDVtYNZ
	 axKeNl2jFxutXtGT2ykKFSByMHzqiEeCflyc6KzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 222/563] PCI: xgene-msi: Return negative -EINVAL in xgene_msi_handler_setup()
Date: Mon, 13 Oct 2025 16:41:23 +0200
Message-ID: <20251013144419.324222661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit b26fc701a25195134ff0327709a0421767c4c7b2 ]

There is a typo so we accidentally return positive EINVAL instead of
negative -EINVAL. Add the missing '-' character.

Fixes: 6aceb36f17ab ("PCI: xgene-msi: Restructure handler setup/teardown")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/aIzCbVd93ivPinne@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-xgene-msi.c b/drivers/pci/controller/pci-xgene-msi.c
index 0a37a3f1809c5..654639bccd10e 100644
--- a/drivers/pci/controller/pci-xgene-msi.c
+++ b/drivers/pci/controller/pci-xgene-msi.c
@@ -311,7 +311,7 @@ static int xgene_msi_handler_setup(struct platform_device *pdev)
 		msi_val = xgene_msi_int_read(xgene_msi, i);
 		if (msi_val) {
 			dev_err(&pdev->dev, "Failed to clear spurious IRQ\n");
-			return EINVAL;
+			return -EINVAL;
 		}
 
 		irq = platform_get_irq(pdev, i);
-- 
2.51.0



