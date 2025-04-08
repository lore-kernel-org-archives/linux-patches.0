Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4A26B09F;
	Tue,  8 Apr 2025 12:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114354; cv=none; b=q+0jDH8F7ki598dBl6nut2HEIBKG0buqWsbZRF0DnJNUvKGM/N4c/kGMGo/N5T2sGdKJkUy8wAp8uPzteyGBx4EXpluQ5tU7wWa30sbwRrLNYY2E+Fp/LWtjJVq+x2JLlZ+XG4wHsBWv/u4S4cBjLCsKofHmnwlg/RZdaQg20gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114354; c=relaxed/simple;
	bh=Ood3PFxlcZlO5Y5X+iJPFt9DEAdJbzH8mOCzZofhmb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwAx+VHriH+g/neqKtr/Zo7Q6SQML/sbar0C+OcKLeDVJx3oGX82MVQlNe69xDmujSQrdVXS2Hmct65Rns0w6U+7xKkl2dJIJ6L7UHfEEyTQQVGT/UlRcyNVFizIxEpy5mM0SplccH0m+vLsGKJB1V+Hh0rt0q4uHqXFAtbH2lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rE9+xhpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rE9+xhpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8285DC4CEE5;
	Tue,  8 Apr 2025 12:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114354;
	bh=Ood3PFxlcZlO5Y5X+iJPFt9DEAdJbzH8mOCzZofhmb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rE9+xhpl70EOiWXANEA4fJMptoarT41+381B03OChf8TdYZFmboTN0bHPa/Q+5Mfj
	 qg9y1xrw3wXPF6fFD/a2OSyEwXjpcCo3eR50PBJye4nKNiQ/81f2APQs/thIn9IXS2
	 3RIpBgBXtiiWoisSfMeH+CPpoLPOh4ogdZ+2r99M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 074/499] PCI: Remove add_align overwrite unrelated to size0
Date: Tue,  8 Apr 2025 12:44:46 +0200
Message-ID: <20250408104853.070677581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3d876d493faf2..3a1fcaad142a4 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1149,7 +1149,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		min_align = 1ULL << (max_order + __ffs(SZ_1M));
 		min_align = max(min_align, win_align);
 		size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), win_align);
-		add_align = win_align;
 		pci_info(bus->self, "bridge window %pR to %pR requires relaxed alignment rules\n",
 			 b_res, &bus->busn_res);
 	}
-- 
2.39.5



