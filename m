Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023121;
	b=459E/W+a3ea3U4LjaPPHfhshJss/ck6xhARznH6+OuB1TKb4fpFJeucaTZKywMOb6bwj
	 +l0I/mKOyRNEFVaD8NfC6GKBRtC3HVvTzk6MG6opWP0zlGK/NcZCjwL6pbUO22Iem5zAl
	 JgMK/ikesQe6701eAgeklQBLVJsR8AWikmXHNvD9rYma9SiKNL1BKMy9HXgCk+PClxsBQ
	 WLbCQg7VEgeCQPehZCu4Zg94jcZ+lKBPEz7wL+yzSUG1daxzTbvkl+Rxk+HoCB0S7c0nF
	 9gMWtL5Vgd44QI3sYJBwbJO7qSxliCk0ynTHnoDdqVjkSgu+eyWkx7ovbUfEgQ/y4Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KSRb0mQOeKJNNvK3PWb2P2LYFtHmEHICbVZvQ6SAuas=;
	b=LQIeJEe02NCrR2w/PKKk7i4VFKuXO0DXnviCPKk8380p48NOHV7qmryWh10XDzPWasep
	 lCitGaBrtqWJnz8RUrdrrcFvNy7bVEni2QSuoBIau7dJXP3kAjhdeKa8f22iQt0OufcNw
	 BpcgGrCPBwr0+QIVfGeJUH1oSLZiaYS2UTBNE8GKCClLxXiDYb3uLVPfHymLAkvIFRwmG
	 Ca9KaQ87RnwsGzxQXjzIG80DbuVhiSK4yQwXNJZE3htGV8xHFPS3XSCmSRSV/wrQlkXvj
	 VUdfaKlYLVEdCTJv4CaV4IZRlRPPBt2RWiAGnwMakPfhCl6gbTJTIKlOJ9kiBKjO5gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRutpycm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC09606A32F;
	Wed, 18 Nov 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRutpycm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EE11F000C4;
	Wed, 18 Nov 2026 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023120;
	bh=KSRb0mQOeKJNNvK3PWb2P2LYFtHmEHICbVZvQ6SAuas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRutpycmlF8n1HsxHzbik9emlSIcPKFo/r8VwtmUgm6DJ7zsP5te2Wq2WuQ5o4Bfn
	 62kJ1mhBuSuep6VgceXI++bd8DfVh4zJc6Yy4xsyT0CrsXuknEKpMqyq6mD8j778/B
	 VP//BVpYuxAouGy96Csm4GBPXdPkd5eH9AU7leDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hofmann <marcel.hofmann@ingenics-digital.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.18 0257/2151] remoteproc: imx_rproc: Allow mappings ending at region boundary
Date: Wed, 18 Nov 2026 15:33:12 +0100
Message-ID: <20261118150131.146029042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8fa81d3779849..d26930c83f7cd 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -397,6 +397,7 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
 	/* parse address translation table */
 	for (i = 0; i < dcfg->att_size; i++) {
 		const struct imx_rproc_att *att = &dcfg->att[i];
+		u64 offset;
 
 		/*
 		 * Ignore entries not belong to current core:
@@ -409,9 +410,11 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
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
@@ -442,9 +445,14 @@ static void *imx_rproc_da_to_va(struct rproc *rproc, u64 da, size_t len, bool *i
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



