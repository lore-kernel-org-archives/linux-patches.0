Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189671B87E9;
	Tue, 12 Aug 2025 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022429; cv=none; b=uvWZZDRVbEbmVT3zxVVMbdzeLiS2t3bzQ51E95AzPO+sugits4Xnny5vWIkN6b2U8b4pgmJbj5AW7jmGzIPm/f+1NpkDlD3/3Ldq7qgIDnzW5emQlqZ4knqxyf5cwUVqoRIJ97y2oixxJUzMtNEW1n9nFLtBHMf6GDo2U3uiJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022429; c=relaxed/simple;
	bh=0LZyK7JU5o1mOO432WqDZixl0xtnhzCz5sqpOSij9oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2s6O8dkMufMNIZOTuqWt/bmqIZqZOTrCmLdmtdFVIpYs+Bgdpdy3RueK9pAhUYU6Lcb76dJw9vlkIsBEETPGFc19kQQaEYPH/8JKboOZTSDB/w4RzmZrJFxb9o8kD7SCf3q9jWgS8LNbiDlwEwHHyk1KTjhyyxye4xpq4zo0RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2vgnlgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2vgnlgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D68AC4CEF1;
	Tue, 12 Aug 2025 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022428;
	bh=0LZyK7JU5o1mOO432WqDZixl0xtnhzCz5sqpOSij9oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2vgnlgmlk3k0Ob8Zqf6WJJZylh3u1CUebHeLwZAzqZQLR6aTAmiGRL9QT3c3v41P
	 9ums93dyruBgOLs4FAc/1C3B4Uf3H/9xiuakZKGolXSLr0M8PhoMUEPirGaRJU2lME
	 mp9HzPm+T7klttJI2zO+4/UBkTIAPh404aM5mNrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/369] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 12 Aug 2025 19:27:30 +0200
Message-ID: <20250812173020.534937839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit fcc5f586c4edbcc10de23fb9b8c0972a84e945cd ]

Fix the debug message for the PCIE_CORE_INT_UCR interrupt to clearly
indicate "Unexpected Completion" instead of a duplicate "malformed TLP"
message.

Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Signed-off-by: Hans Zhang <18255117159@163.com>
[mani: added fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/20250607160201.807043-2-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 481dcc476c55..18e65571c145 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -439,7 +439,7 @@ static irqreturn_t rockchip_pcie_subsys_irq_handler(int irq, void *arg)
 			dev_dbg(dev, "malformed TLP received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_UCR)
-			dev_dbg(dev, "malformed TLP received from the link\n");
+			dev_dbg(dev, "Unexpected Completion received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_FCE)
 			dev_dbg(dev, "an error was observed in the flow control advertisements from the other side\n");
-- 
2.39.5



