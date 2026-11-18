Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029145;
	b=4ugRie1Wy+d6Yg/NjOPmksejl3MHRH3DiDQ15htDwGk23UnvJ9PkIZVATkJO19kog3xX
	 PJs38pjQpGT2vZHwNBzz+TorNqMsGsDoG7J7RVNLKZD/U5jgBI2s2kmlOGIXCSyhesEiV
	 M3A1jcmJEEl49rA0BHWqcFLX2EvtWxv93S3fAOLapGZHawVYsNry0Usf513Xg3vcsaslq
	 TrbaDFV4S8q09mGGR5HafATWBFeflJEhZu9p0a/7Cah1qUhhrpSsU3yYbrdoLyEkHt027
	 vpmzDs8k3LIRJJIU6jG50IMrC6OI4q4V7Griwc+IYrHyf1HJgJM0zGgdmjHkRQemuUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7y1rxYDakV3bOGt0l5Uqs5Hj03QU63R6juxm09dP8w=;
	b=2hFDVPEQefhpKD2mdYTmc+fQolAy/qAHqq/LwNJVIEMsjED2MZ3x68hQZtwspdx6OfT6
	 ExYlamstTOGtp+DHnkHlWnCYk04a3T8zNlmASB4KNVcwooV3zDX71j7A7M/AdENBO15Ec
	 zfHTG8W8B9l6bl3z8HX0+S9UnJRJbniMk7cU/ZPoglFBr9gj/8ilMc1rzTJ4TAfC/gKrE
	 zqAdqX3YOe7FWX/+ij9tn17WR8TuJsccIwDp1ib2t1scmZ3ckYTyBRqcTA/oulBVULoO7
	 XE0DqVKd+xbN/TlvgZPOlmkcJLPoQPamPHATa/mw06jbhUzFXp405mCWzAzm+8OiiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMexyJrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83291606A31C;
	Wed, 18 Nov 2026 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMexyJrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34911F000C5;
	Wed, 18 Nov 2026 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029145;
	bh=t7y1rxYDakV3bOGt0l5Uqs5Hj03QU63R6juxm09dP8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMexyJrhv4QKltHbT97tz9w5x/zkCGCeXGOVkPenvJ/sx4/4ec4GLs6pV0lB7og+q
	 iY2Go9ggHgNPUSaRgzzPt/vQZjERXH0rXvFN1gJsrN28qgFSfoevihmlXBOZdKX96R
	 wc/aLnxPFMcYruUaq2zn4hUW2w+xlnhTMCo1k5R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hofmann <marcel.hofmann@ingenics-digital.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 6.12 0245/1756] remoteproc: imx_rproc: Allow mappings ending at region boundary
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118150018.141431332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4f73b1ea05ffb..8b2afa8242f91 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -456,6 +456,7 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
 	/* parse address translation table */
 	for (i = 0; i < dcfg->att_size; i++) {
 		const struct imx_rproc_att *att = &dcfg->att[i];
+		u64 offset;
 
 		/*
 		 * Ignore entries not belong to current core:
@@ -468,9 +469,11 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
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
@@ -501,9 +504,14 @@ static void *imx_rproc_da_to_va(struct rproc *rproc, u64 da, size_t len, bool *i
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



