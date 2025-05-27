Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAC22798F8;
	Tue, 27 May 2025 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367247; cv=none; b=cCy97iZI5IKCo0JzL7HnrzMxuqmCHDi9ODlA0LIJXpqktMcZL6ZPkAGct72gWeWBUcH+RpMxfmNWccC4ozGvekbV0v3eNYEaryDvGC3Ui5piAwViLp+2GrUa5Rt+kSJpWc/c4gISm/4B4WJyR+R8K04bqt3L/pyokswX+84l3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367247; c=relaxed/simple;
	bh=r2Q9Z1Sd/RpYZNF1wni6iEVxqR4vOTIjqHlDJkU6IgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzT6XZMDZ+grwZeACHbc4Yj7UdcBzimoUnDPJAGzKn8wxvQhSIsf+GhN3wTw4I0RVQns3dh0ilBrUjfIqIzqtlDkpI2dlIQxe40qi/86dsHaP/fwydQT6IJEI7AJfst0bZFVlX1aBr5wt6Z9LfA3JGkpl6h+HudrZUx9Zh8QJVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0bMz93M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0bMz93M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD40C4CEE9;
	Tue, 27 May 2025 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367246;
	bh=r2Q9Z1Sd/RpYZNF1wni6iEVxqR4vOTIjqHlDJkU6IgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0bMz93M1QeqkzzrRLKeouQEqgfS803mxAI/8DZqvA1/6VJ8VQxHaLOlGFr7zc0QN
	 wuPuzPqNj5SdmkT7xB7QWos0BUK4Dkrii6fPDejE9ntoRJX0cDRLqJ7MAfOO6hkrB/
	 SiiMqrvkwS333DbpntVp80gSorHzZDMV2wBydSU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 326/783] PCI: brcmstb: Add a softdep to MIP MSI-X driver
Date: Tue, 27 May 2025 18:22:03 +0200
Message-ID: <20250527162526.338553452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index ff217a0b80ad3..bae226c779a50 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1947,3 +1947,4 @@ module_platform_driver(brcm_pcie_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom STB PCIe RC driver");
 MODULE_AUTHOR("Broadcom");
+MODULE_SOFTDEP("pre: irq_bcm2712_mip");
-- 
2.39.5



