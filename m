Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275432C11D9;
	Sat, 30 May 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164027; cv=none; b=L7TrVYcXwrcV4Ku+6bzfDaO0I/+ie1tIEsGjW/h7FWWq5sI3OUWyrwKeT6fx+uvaQulJIFAh7ygBZREfTla61ONNpuSGRv78yDzTvryV9CLx64LxggrIIeRYltCvuCG46tOVG5b4PcMI4AtQWd+f9O0KLE+6YvmckCNkMLB9GkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164027; c=relaxed/simple;
	bh=rvpy5uUk/y5XP6Lh8GcEFfP8yljhIcXpgOxfY2C95O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkHwR4p9/MnJP0XtMD1NopVrNWw7u+9r2haBDicuDiMW17LCrjyVoH5b15O2GD6AXyqkslGccdQvjKV1nudvBtN/M3bfJ2r4u2SwWlPRakrT+OLdiApi+5tzgpALtk9p7RP3fb1bb9Mb2QAUH/gNXja5ig+xJ5i7gF4VsCje6O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U8Y1fq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U8Y1fq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7051F00893;
	Sat, 30 May 2026 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164026;
	bh=yct4aGMCrbaZsfXniIkm+Y9Wx34qSRCkdEtvi7oltgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0U8Y1fq0gRQPgWV+yLyeXQLapah/HSkAPqmGGuqaB7BaCOJOfG/jt8gAfQ8bAZREb
	 C2SjBP3pb8zgIcOUWbW0W32veWuATlADwVDUwCeLO3jyrFNHxxuIeEMYvxwzlxwKNv
	 gm5BdK2C49rsSCzLbxh1QGjhv5mNq+yUgV4xE64g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/776] dpaa2: compile dpaa2 even CONFIG_FSL_DPAA2_ETH=n
Date: Sat, 30 May 2026 18:01:52 +0200
Message-ID: <20260530160250.789766905@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 97daf00745f7f9f261b0e91418de6e79d7826c36 ]

CONFIG_FSL_DPAA2_ETH and CONFIG_FSL_DPAA2_SWITCH are not
associated, but the compilation of FSL_DPAA2_SWITCH depends on
the compilation of the dpaa2 folder. The files controlled by
CONFIG_FSL_DPAA2_SWITCH in the dpaa2 folder are not controlled
by CONFIG_FSL_DPAA2_ETH, except for the files controlled by
CONFIG_FSL_DPAA2_SWITCH. Therefore, removing the restriction will
not affect the compilation of the files in the directory.

Fixes: f48298d3fbfaa ("staging: dpaa2-switch: move the driver out of staging")
Suggested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Link: https://patch.msgid.link/20260312065907.476663-3-caixinchen1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index de7b318422330..d0a259e47960f 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -22,6 +22,5 @@ ucc_geth_driver-objs := ucc_geth.o ucc_geth_ethtool.o
 obj-$(CONFIG_FSL_FMAN) += fman/
 obj-$(CONFIG_FSL_DPAA_ETH) += dpaa/
 
-obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
-
+obj-y += dpaa2/
 obj-y += enetc/
-- 
2.53.0



