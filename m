Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0C2356908;
	Tue, 26 Aug 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217377; cv=none; b=oAv7SwD6igWFQyZwnJ1KA5qkLjOQWwTvj4FjRjoRWgkZ06iD4Ce/RyPFG2gc6XyCPcxFGmej/wbG1tvLucUHf5BdhLEe9SwNT6z+4aHawI7f83URbrXkELru+b7yF5SkM5MhC2CvhxjkBy8OgxNHNqFKhqOhx/I38qWELxlmzRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217377; c=relaxed/simple;
	bh=L9+4kEGMKrfkcJ5g4+rUUUMU6AgMpGkDkNxUIdoxhc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSjx8+5H/93K+8C/Wv8WF3C4LXa+18/6slHPX8Y0kqtl5hukojlFA6zU9RVkgq4uTzLhNfEdlG8rGrQwLOWNwZnv1/Ag537xgABXdOFa57PvCRl7FozeF22CNilHu4FRIMyvdf5B3E1kBsAh0JiU6ZtTq5nAihe/dFgqzvRJzHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4l0O3rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4l0O3rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5777EC116B1;
	Tue, 26 Aug 2025 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217377;
	bh=L9+4kEGMKrfkcJ5g4+rUUUMU6AgMpGkDkNxUIdoxhc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4l0O3rQ/v+sZxwoZ0tmLC6Xzi/ZwlBfOoRzdwmYgFE9XQqUWsqIKpKwprBqPnT/W
	 BF2tA2jq/9LstWAw7mrGbzQqcLuVyrJaxinKZa7LtFRgKJps2SuHmIb4zEdQbaO1gx
	 AgxLfo/XVByipO11XNz9ONtxnlXA81Vb1LS7XKXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/523] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 26 Aug 2025 13:05:30 +0200
Message-ID: <20250826110927.477561097@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d6df73bb918..86bb4f82048a 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -442,7 +442,7 @@ static irqreturn_t rockchip_pcie_subsys_irq_handler(int irq, void *arg)
 			dev_dbg(dev, "malformed TLP received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_UCR)
-			dev_dbg(dev, "malformed TLP received from the link\n");
+			dev_dbg(dev, "Unexpected Completion received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_FCE)
 			dev_dbg(dev, "an error was observed in the flow control advertisements from the other side\n");
-- 
2.39.5



