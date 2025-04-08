Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F22E26F44C;
	Tue,  8 Apr 2025 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116217; cv=none; b=UxrcfKtzqoIwMrGk4pB4llmls41xjLS/vOxgYQpu5C5Gui3pvCDviadK7ffpw1SzOXrKATgEeRMYeZIuE5x7u06N3Y0mEeLAmim66kmdCzEV2Xl1burDptQf/Z54A2oW5ktUXesH2ToI7Tv8eBv61652qGCJXzNFT/g8MQ7Wppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116217; c=relaxed/simple;
	bh=MEFweAQzvIENn/p8ikouwPTY2xhtIxZ2lVciIzEyMV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVlW6qDjvZQPOKVBJyzv5TekwUe1sreAiH0pba+vfp9cA5HFsZffvk48xHVFyE2RN0dRK2dR8Oh9QOEEvMg/nwyk9u+gPdge8qAWXWn6mXXQI6hfJI+nftxbPydBVT4JGKbSyyDyk9UQU+KuvOEBcNYEMAjrugSeGEwt52Tbi7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XljHEJCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XljHEJCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2796C4CEEA;
	Tue,  8 Apr 2025 12:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116217;
	bh=MEFweAQzvIENn/p8ikouwPTY2xhtIxZ2lVciIzEyMV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XljHEJCtlIRzBRE/KKstB/RFr8eVdhMo3ZztqsrFRf1An7lzv0+JBnqESrpWo+kBq
	 GOpDpPlkxDlHJry+cbSX4mncy+08If1jad67vZRpkUZpWXuYGJN5NVRK/esd+j4aaj
	 OnBsHHIVXzpXJaihedGhoKcD1QSRViFGOG/jJpDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/423] PCI: Remove add_align overwrite unrelated to size0
Date: Tue,  8 Apr 2025 12:46:25 +0200
Message-ID: <20250408104847.122861387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d06cc1e3809040e8250f69a4c656e3717e6b963c ]

Commit 566f1dd52816 ("PCI: Relax bridge window tail sizing rules")
relaxed bridge window tail alignment rule for the non-optional part
(size0, no add_size/add_align). The change, however, also overwrote
add_align, which is only related to case where optional size1 related
entry is added into realloc head.

Correct this by removing the add_align overwrite.

Link: https://lore.kernel.org/r/20241216175632.4175-2-ilpo.jarvinen@linux.intel.com
Fixes: 566f1dd52816 ("PCI: Relax bridge window tail sizing rules")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index a6e653a4f5b1a..f16c7ce3bf3fc 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1150,7 +1150,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		min_align = 1ULL << (max_order + __ffs(SZ_1M));
 		min_align = max(min_align, win_align);
 		size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), win_align);
-		add_align = win_align;
 		pci_info(bus->self, "bridge window %pR to %pR requires relaxed alignment rules\n",
 			 b_res, &bus->busn_res);
 	}
-- 
2.39.5



