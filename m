Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039327;
	b=2eud1FhuR3Yn+qVxiGgkYP1CT1p3WdM0Tb8Ydc4wrzlEFFUdkVc6RtnEqvcjYAnpm8Fi
	 FAv8yGr+7UAkJoAlDoFs2QGecEdhEyMOuY7hGRQYNTk8eDImVNfGcc9HYqrT+sZsDo9EL
	 YChPPsSdji6NsuMJMnW7AV30hLtqg0taWBE1rTaIS+rcT1T9ImYoQBXV0xEDnpAi7flQ3
	 m9deXCcrEkzFeuH4ud/UA4CxglWC3pE1KsPyoBHx70nUUiLBLr1y6dvQ0HBCkHIntF4bE
	 aZkX0fgpRieUkuKxF71Y707TCe1oW5/7xM76frVzSRpEmkTZNTwU24OlkAV+RdH7BUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VxWiA/IAQlLM+ToOa0Y00hbAP4NKk9I/VoVRwdPPfgg=;
	b=O8IW2fkP+9T0lry2EmzpJKiXXiYn0WRpfHp4mFXo0HqhkU6NhvIzgWTftlMIkVu5z+H3
	 dRgisZv4hma/APoq/79zswCyPh/MbK6i1FNld8Y9tTeiCHGs7q3gpi59YuBkUr9WEqGu6
	 oVtQilZFu3wJfrJ69KbkMEp5WwPh/SdvN39NZNCL4CgbKUYvlA2O6qyT0jbA+oVIqZFl1
	 zUY3UyqLFWlUiDv8Tf7uVXhp/XFs3im3pAHsnWkmjJaPL+5afjjU6l2hOOH6VJNjSmg/p
	 18l1qGuQ61BrM2GiVSC+dnoIyvyZRye49Cq794jJqZt6pjJANzL6jaTvOvK9ndxGaHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iQRzA/LZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110D606A334;
	Wed, 18 Nov 2026 22:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQRzA/LZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA621F000C4;
	Wed, 18 Nov 2026 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039327;
	bh=VxWiA/IAQlLM+ToOa0Y00hbAP4NKk9I/VoVRwdPPfgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQRzA/LZjaXBuNKpgl2wwbcTNDVyNjg2pDYLwjJ21L3xkhRQNDKSV6kTK2dOmwMnE
	 2bpQneYuJf6lzrw3hvNgE8lCgr7bxXUIlAYCqXjhPkYwpK08QS6qUIFyMVDOvq8II/
	 zSharV6AKUvZq8JdSNdO5sK2tCx2nphdnusm8/fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hofmann <marcel.hofmann@ingenics-digital.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.6 2062/3318] remoteproc: imx_rproc: Allow mappings ending at region boundary
Date: Wed, 18 Nov 2026 15:44:44 +0100
Message-ID: <20261118150423.929948696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Hofmann <marcel.hofmann@ingenics-digital.com>

[ Upstream commit 749eed0c7178c8d53ce4c9acdda4a545721c494b ]

The address range checks in imx_rproc_da_to_sys() and
imx_rproc_da_to_va() use a strict comparison for the exclusive end
address of the requested range.

As a result, a valid request that ends exactly at the end of an address
translation or mapped memory region is rejected. For a region
[start, start + size), a request [addr, addr + len) is contained when:

    addr >= start && addr + len <= start + size

This occurs when a loadable ELF segment fills an entire mapped memory
region. This can be produced by a linker script that extends the
resource table section to the end of its designated region:

    .resource_table :
    {
      . = ALIGN(8);
      KEEP(*(.resource_table)) /* Resource table */
      . = ALIGN(8);
      . = ORIGIN(m_rsc_tbl) + LENGTH(m_rsc_tbl);
    } > m_rsc_tbl =0x00

This produces a ELF program header like:

    LOAD  0x010000 0xa4220000 0xa4220000 0x01000 0x01000 R   0x1000

In this case, the segment size matches the mapped region size exactly,
causing the address translation to fail with:

    bad phdr da 0xa4220000 mem 0x1000

Rework the upper-bound checks to allow ranges ending exactly at the region
boundary while guarding against integer overflow.

Fixes: a0ff4aa6f010 ("remoteproc: imx_rproc: add a NXP/Freescale imx_rproc driver")
Signed-off-by: Marcel Hofmann <marcel.hofmann@ingenics-digital.com>
Tested-by: Peng Fan <peng.fan@nxp.com>  #i.MX95-19x19-EVK
Link: https://lore.kernel.org/r/20260827123136.438798-1-marcel@hofmania.de
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index fda0e644f3106..9f24f8034c1eb 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -463,6 +463,7 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
 	/* parse address translation table */
 	for (i = 0; i < dcfg->att_size; i++) {
 		const struct imx_rproc_att *att = &dcfg->att[i];
+		u64 offset;
 
 		/*
 		 * Ignore entries not belong to current core:
@@ -475,9 +476,11 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
 				continue;
 		}
 
-		if (da >= att->da && da + len < att->da + att->size) {
-			unsigned int offset = da - att->da;
+		if (da < att->da)
+			continue;
 
+		offset = da - att->da;
+		if (offset <= att->size && len <= att->size - offset) {
 			*sys = att->sa + offset;
 			if (is_iomem)
 				*is_iomem = att->flags & ATT_IOMEM;
@@ -508,9 +511,14 @@ static void *imx_rproc_da_to_va(struct rproc *rproc, u64 da, size_t len, bool *i
 		return NULL;
 
 	for (i = 0; i < IMX_RPROC_MEM_MAX; i++) {
-		if (sys >= priv->mem[i].sys_addr && sys + len <
-		    priv->mem[i].sys_addr +  priv->mem[i].size) {
-			unsigned int offset = sys - priv->mem[i].sys_addr;
+		u64 offset;
+
+		if (sys < priv->mem[i].sys_addr)
+			continue;
+
+		offset = sys - priv->mem[i].sys_addr;
+		if (offset <= priv->mem[i].size &&
+		    len <= priv->mem[i].size - offset) {
 			/* __force to make sparse happy with type conversion */
 			va = (__force void *)(priv->mem[i].cpu_addr + offset);
 			break;
-- 
2.53.0



