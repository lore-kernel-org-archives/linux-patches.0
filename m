Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD70207E14;
	Tue,  8 Apr 2025 11:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111312; cv=none; b=jB7qxClTkKCgwrXbCdvKsczcwrMy/2HdG5oRRU23jmIs4Fu6UqTOdJt11VrkngXftduiIWjO1s+iuoivdD2GD2rcH4nbW2AFELlgBPB8OYyTaUtQCZMRATYqs1etJ7DmKDuWpsciEDBFU7GK1eO0kl1zchXYvZygU73SbsSkp3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111312; c=relaxed/simple;
	bh=5TwQyz4C0nyJJsZ8yHBsAsXlv+Q7Wv2ZRsSCvcQm7Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mk8zlRRoImNtiASePW7dw2uyH/EL/kLhtszBE3MmHwVjv+/zycUDdAphge4rKUDcAiES1BNAcJWgkibdZxovY5AQEG7bDxHL/ULdw7ozHYiZgwM+mpf4kULZt+D7mr5VXGdvhAmeRdutVmuuMRq6dJ6OqwuOyLErH+HU5UhLZGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz6NB1Lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz6NB1Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D62C4CEE7;
	Tue,  8 Apr 2025 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111312;
	bh=5TwQyz4C0nyJJsZ8yHBsAsXlv+Q7Wv2ZRsSCvcQm7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tz6NB1LfkIUZwycCrQYkFMq/q3GqKfimUSSpiSMrbVU0fKFwC0W70yl7daiQ1QhP6
	 El5l48Q8/LdxKV2WTsbgh2SvsIcPfEYii1fCSvClh2HVd1Ccs82jB54TqUIiCNdoAH
	 knhCohLK3Q/9dFlwpqvSDxAKr8srH+uAQusUToZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 336/731] PCI: dwc: ep: Return -ENOMEM for allocation failures
Date: Tue,  8 Apr 2025 12:43:53 +0200
Message-ID: <20250408104922.091469704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8189aa56dbed0bfb46b7b30d4d231f57ab17b3f4 ]

If the bitmap or memory allocations fail, then dw_pcie_ep_init_registers()
will incorrectly return a success.

Return -ENOMEM instead.

Fixes: 869bc5253406 ("PCI: dwc: ep: Fix DBI access failure for drivers requiring refclk from host")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/36dcb6fc-f292-4dd5-bd45-a8c6f9dc3df7@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 8e07d432e74f2..e41479a9ca027 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -773,6 +773,7 @@ int dw_pcie_ep_init_registers(struct dw_pcie_ep *ep)
 	if (ret)
 		return ret;
 
+	ret = -ENOMEM;
 	if (!ep->ib_window_map) {
 		ep->ib_window_map = devm_bitmap_zalloc(dev, pci->num_ib_windows,
 						       GFP_KERNEL);
-- 
2.39.5



