Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064578;
	b=jj8Za/0NPcWHv3n+yKFJnJpGD/XcQ1Lv0+DKHxwR3wboq+dHzspp/+QHRfA0ZtQ/8AkK
	 IvtVm+UQ+wULLXmhghHDeay3MSKX9UPhGdM49+mSdTXCMSw6RyiEOym86HHMaZr7c7r9C
	 dBDkeWJbBRNHdvZwVYVKUqS1GXQalhVLcMwquuL5CK4TKALIsJT3qPg1Bj97+cxTmfe1w
	 VLA15AubSrISgswDeIEDVRPiBCnJ9VdWOdjpQTqLKOZ+WGqWsesIX3oYadDGl5hVay9cB
	 J2cMGlTwGG7Ve0Jl9dnAmgD9GtzDAcQJXI27/1At1/VhjXpzt+v86xinkifMs218hPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbLugK9uVtd/K0G8ZxuHGP3wGPzA7IRj2I5Vop+4vuQ=;
	b=SzxlZUQIW74J9styno7SodaFudcwQczPVnBf4xFuZOHSK2sJEPdlCAHlz5d5bKQ4ps+z
	 yqcauBoJYcDrGNigorN0TbrIN0yv6P8O3oLV/Dsq6Vb5onW0Z+8lvV2+/YqDuM/b1ETTe
	 eeHzegDL7Y86BtdPMCq4w/D3V1Ja93eXYkxR3MEw3oweUAbymvQWZF6wckD2+izn+oW49
	 fidV9gDkedJbdDiXU1iPm9qyAOnR2aZ9xt+0tLg3Aw6YFtbH0GYI2sy3doIuJfN3bmdms
	 vkmyDMV8ibmJa5tNMLp7NWlcyq6GBPHwGva6AqZaG5JSfIKkoL0JgiNoFmZWH2xc+MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZJdMcTf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000C606D809;
	Sat,  7 Nov 2026 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZJdMcTf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D95F1F0089F;
	Sat,  7 Nov 2026 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064577;
	bh=wbLugK9uVtd/K0G8ZxuHGP3wGPzA7IRj2I5Vop+4vuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZJdMcTfvnibQQ0LbSUx0PddzDDwEI831VjnqNi0wkMpaLVvq0K5I7fqE3dk+PtgU
	 DubKwivnEK293X0ML14mRduqIVY2T4RqW/pZ+ELd8i7Cnn/lPsL3bP5gzbp42Ji91u
	 OFnDgJJchuPZ/HVY8168kSGJ18MAOL4vcEIahipY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0597/1257] iommu/dma: Catch scatterlist length overflows
Date: Sat,  7 Nov 2026 08:48:13 -0500
Message-ID: <20261107134955.813952460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 1c8f6308e557f32412e9d4678b3f029f47f6d9aa ]

It is possible, when a very large mapping uses only one
scatterlist, that padding overflows scatterlist's length field.
This results in:
 1) silently wrapping the value
 2) smaller than desired mappings produced by iommu_map_sg
 3) leaving mapped bytes in memory (no iommu_unmap)

Address this issue by adding overflow detection for scatterlist
length field.

Fixes: 809eac54cdd6 ("iommu/dma: Implement scatterlist segment merging")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 68ee57800fefc..795a0d6248ceb 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1477,6 +1477,11 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		sg_dma_len(s) = s_length;
 		s->offset -= s_iova_off;
 		s_length = iova_align(iovad, s_length + s_iova_off);
+		if (overflows_type(s_length, s->length)) {
+			ret = -EOVERFLOW;
+
+			goto out_restore_sg;
+		}
 		s->length = s_length;
 
 		/*
@@ -1493,7 +1498,20 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		 *   time through here (i.e. before it has a meaningful value).
 		 */
 		if (pad_len && pad_len < s_length - 1) {
-			prev->length += pad_len;
+			unsigned int new_prev_len;
+
+			/*
+			 * For large mappings spanning multiple GBs we
+			 * may not be able to fit all needed padding into
+			 * sg->length.
+			 */
+			if (check_add_overflow(prev->length, pad_len, &new_prev_len)) {
+				ret = -EOVERFLOW;
+
+				goto out_restore_sg;
+			}
+
+			prev->length = new_prev_len;
 			iova_len += pad_len;
 		}
 
-- 
2.53.0



