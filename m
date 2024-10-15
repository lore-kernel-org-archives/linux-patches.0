Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9E19B3FF;
	Tue, 15 Oct 2024 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992813; cv=none; b=aFsr5cYI30IEyxdgYeQIEPdz+jUMMPUpoInmPdk9cUy985mbF3b3voRm34PpB28ArEJ2WYu6BYReALoo6bffwURDxk3qwY5fP0Q6qNpClDvYbG+fFss+fLzWSKnlXMptv7qDFJiikPyzCx/Po5e+E+Y3ZvFL9V4bA1Pe+oV+KCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992813; c=relaxed/simple;
	bh=Qow0G2PNoVQKFFpuRZ+TT3IKcCwahOJmiaDcuogXK04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld6GT4ejmFscPKAZfx4HsYfzbdUmbj9PzYFnLRU1PUV9IGkNhWLWw5WQBxLfF8bxPAwMRPiyMneOER/tQoTyoUf/lPo6gpEFU0ULCH98vZkFooUysFLbNPJZpgXe6bm0zxVYc+OgUDpP2rdxgIcaQXHG9RGwA6Ncrpz6A9JO/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMWFRDk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMWFRDk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDCCC4CEC6;
	Tue, 15 Oct 2024 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992813;
	bh=Qow0G2PNoVQKFFpuRZ+TT3IKcCwahOJmiaDcuogXK04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMWFRDk1qSfoXubkdrwDD4xVnfxmPFjiC6CYMw+1BF+424244VmFeasdD79+JUr91
	 dzsBq44lca2mMhbTbrUKphPlRViN5ASYg4BtnJvd4dLB5vFkEF6zGh4fxFNYsNDMXD
	 GWN3mF3004gxuhuiSkwbpKso4FyognuhB40YWH5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Lv <terry.lv@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/691] remoteproc: imx_rproc: Correct ddr alias for i.MX8M
Date: Tue, 15 Oct 2024 13:22:54 +0200
Message-ID: <20241015112449.328442673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c901f817792822eda9cec23814a4621fa3e66695 ]

The DDR Alias address should be 0x40000000 according to RM, so correct
it.

Fixes: 4ab8f9607aad ("remoteproc: imx_rproc: support i.MX8MQ/M")
Reported-by: Terry Lv <terry.lv@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20240719-imx_rproc-v2-1-10d0268c7eb1@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index d5ce97e75f027..fec093b3f5e10 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -158,7 +158,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
 	/* QSPI Code - alias */
 	{ 0x08000000, 0x08000000, 0x08000000, 0 },
 	/* DDR (Code) - alias */
-	{ 0x10000000, 0x80000000, 0x0FFE0000, 0 },
+	{ 0x10000000, 0x40000000, 0x0FFE0000, 0 },
 	/* TCML */
 	{ 0x1FFE0000, 0x007E0000, 0x00020000, ATT_OWN  | ATT_IOMEM},
 	/* TCMU */
-- 
2.43.0



