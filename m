Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CA23644B3;
	Tue, 21 Jul 2026 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662569; cv=none; b=V7KH9R85gSKJ0hD2JNodKwhAoEeMmEwpA2pz1zKgfc9N/6t8ieoi0j2pSh+Pk3ZtNX9JdKP9WvMd+K+mvcVc5dmP+b3Y+1WnacF8FeJOj8ym2MJf1rjaKrQsS2Yt+OnVJaEuVFQ5WnGH1XEuLcfY/AXAJAGbuGinvMB3Ea54zas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662569; c=relaxed/simple;
	bh=fR2N5Pn+M/jKRZtIhDbp9RtLkKfOMdMr53gvWNIfiXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIW1tJ4Pi61mG/y3ng4JRUCukSp0cyoAe+bDEU33N6Fycc2vOFizUfiNuh83iRRiw4dQgRmxDCpWY6LcUv98UDhWBO6dph9L7nln/tV/2+tLIQ5Q4mlv3/W1WmmaMTXCvrN8uhSsvtji0W8AsUGhsYSKGCfiqcJzsOpGMRldcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4nfB5vY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4nfB5vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950EA1F000E9;
	Tue, 21 Jul 2026 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662568;
	bh=lXFETn5mO2m4KONs2n3VekTazSLoS2lgIPIovUPNh8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4nfB5vYsge4Gs8FM6s2xjBwnjBvW8SiTQrTVi1I8NMxRuNGEjiBBgAAGYsLCmt60
	 8p0YM1k3vHm/lY2mKztgZIYMY77vqiY6vtdYW+d2aE7skrLGKR0Iu1Fe58YCrzvuqp
	 COewEIjNqMFsDy5a3bB4CunHVkSN/pVH2e3hGrLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0493/1276] PCI: mediatek: Fix operator precedence in PCIE_FTS_NUM_L0 macro
Date: Tue, 21 Jul 2026 17:15:36 +0200
Message-ID: <20260721152457.133840193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 282305d7e9c0e27fd8b4df34b7cd5506a1eccdd6 ]

The original PCIE_FTS_NUM_L0(x) macro was buggy due to improper operator
precedence, where ((x) & 0xff << 8) was evaluated as ((x) & 0xff00).

Instead of just fixing the parentheses, use the standard FIELD_PREP()
macro. This makes the code more robust by automatically handling masks
and shifts, while also adding compile-time type and range checking to
ensure the value fits within PCIE_FTS_NUM_MASK.

Fixes: 637cfacae96f ("PCI: mediatek: Add MediaTek PCIe host controller support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
[mani: added the bitfield header include spotted by Sashiko]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://patch.msgid.link/20260515005552.2343-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index c4cc9d76b42a09..f63a5c7a59e682 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -7,6 +7,7 @@
  *	   Honghui Zhang <honghui.zhang@mediatek.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/iopoll.h>
@@ -60,7 +61,7 @@
 /* MediaTek specific configuration registers */
 #define PCIE_FTS_NUM		0x70c
 #define PCIE_FTS_NUM_MASK	GENMASK(15, 8)
-#define PCIE_FTS_NUM_L0(x)	((x) & 0xff << 8)
+#define PCIE_FTS_NUM_L0(x)	FIELD_PREP(PCIE_FTS_NUM_MASK, x)
 
 #define PCIE_FC_CREDIT		0x73c
 #define PCIE_FC_CREDIT_MASK	(GENMASK(31, 31) | GENMASK(28, 16))
-- 
2.53.0



