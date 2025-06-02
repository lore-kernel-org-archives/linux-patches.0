Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECFA227EBB;
	Mon,  2 Jun 2025 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876167; cv=none; b=O9RY89Eaf5X+BtqgS3qasvl5Dl/rkH0YV6bLrVRZjnKv48HqJNuuOLL6UgMEmRukI8d8H0EMsLNuf2kvytRR77sA9KOOLSwV154nWb+qcrMXhI+jFaiQmM8u0r6MVXBSa5mC1kRyDmvTVp4vgWBdaPzu3DuRf4d3UThCKpO+JPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876167; c=relaxed/simple;
	bh=qCWF7bffn8DWRM74W13REtCTFJb8NtZmT05JCly/cBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQR46C4+2TXWgsX7iWCQImuhfAXv0kdJYdyjyu62CAU/wr2zW1FMjln7lLZobVbUtfodfYEEraxh5s85wIIvwB2/MuqJrVmk6TKJU0VHwNLymdQNWNgsJyCoj+rjV3aBzhOuIQrO5X3tjO2PhgZq04pNs90xfvyR1M8Mr7RK6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beE5EcVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beE5EcVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5DC4CEEB;
	Mon,  2 Jun 2025 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876167;
	bh=qCWF7bffn8DWRM74W13REtCTFJb8NtZmT05JCly/cBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beE5EcVDl0/H9kzhTqjX+cFN+bkq2ppeCZUQ425xN9kpWSYpwXPKJmNnqbizP1Qvq
	 zkgNKTqaSAO7cHzy7leQlobKaeqWAjCg5XEOqfMbwQ4yQXITpPLELTnhZ0GVmD4bOY
	 e/pdeyzdCO0pksS7KFKECe3G1vUmhF7HUhBw7K90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/207] PCI: brcmstb: Add a softdep to MIP MSI-X driver
Date: Mon,  2 Jun 2025 15:47:37 +0200
Message-ID: <20250602134302.066949251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 2294059118c550464dd8906286324d90c33b152b ]

Then the brcmstb PCIe driver and MIP MSI-X interrupt controller
drivers are built as modules there could be a race in probing.

To avoid this, add a softdep to MIP driver to guarantee that
MIP driver will be load first.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-5-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 7121270787899..e984b57dd0d89 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1352,3 +1352,4 @@ module_platform_driver(brcm_pcie_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom STB PCIe RC driver");
 MODULE_AUTHOR("Broadcom");
+MODULE_SOFTDEP("pre: irq_bcm2712_mip");
-- 
2.39.5



