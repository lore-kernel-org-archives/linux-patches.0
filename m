Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039407;
	b=sygRzaoHkTmrByr9GpxCMZqlNykQE/N/JFYYUBX+mplrS00IatBYjrjK2UI+njqJEz5l
	 H28kH0099AmAa4A9K503R4eZlU5X87TgYmWjszQmj6VCRC+KFRDO7SLexCpbtaDGiFFtj
	 5gs/XHo+0oOwGA94Zo4OyRmjTxURC5MV+OQPdjF6zYXukykx9H+uv+l2gyt62SgJhfF6C
	 fndvMsEQiCbRdEJtbJZFoiWBjMRt9Z3U5Eli4pZ8iU5Ns7OOBJU/AR7YIbghKEh/fHysG
	 we3qW5FDOmLEh3snWPY/k68bXpqYZ4HTzsX4v8VLAyWzjFm05GVbDwce43m+8z7eFqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0sIS6VlBVElARzeKy8Vmaxatfwrbe6AONASs1JwSZzo=;
	b=hCY2U6RcD3ZPAG3OJs1RzRMB5d0waBSWiQlfg60k4VVA49SURucxB4bSzHFZv+i6F+Q7
	 8M0QY2iyePTEcrSmHLlNqRxBqlQ41whKsyBztRkgxaXjjOfHZ9zf2MrkJBwUUpspDTuR1
	 sndntZXPtyuZLFeOyGsjCtDtfLZsMMYywTGrsIRZECNzbF7kO6yyRU4hc3zh29boTGgH+
	 fStC2BXm4LyAEEwhwszIIYs7MripAzagkTFo5rN0skVoae+1Y0DVU4/JstJRFub1tvQYT
	 0p7FmUthwms24jbjfZAg+rMP2znLUSwuoOKilpOz4+PUMBKQhKmuoPnLAgphBN8Cg0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FMcZb/V0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51015606A320;
	Wed, 18 Nov 2026 22:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMcZb/V0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB01F000C4;
	Wed, 18 Nov 2026 22:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039407;
	bh=0sIS6VlBVElARzeKy8Vmaxatfwrbe6AONASs1JwSZzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMcZb/V0+xAPpiz89stVPbxvxxoJlQJDTl3obWdswsA34CnR+7pkyAlk+r5+Ezd0f
	 od5eQ68i0802aVdiRoyrjmQ0xVOCW/fIQZa5GVlGAZetrdRvwCjhGO/fEuVSG7lW1D
	 BrV+s308lrFbc2oSQUrkP6Hsbprr7BvL90psoOmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanhua Wu <yanhua1.wu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2088/3318] EDAC/i10nm: Fix Granite Rapids ADXL MC mapping
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118150424.739231780@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ba71d9b4e9dd83c1614b3b5cec6c82a39d290f7e ]

ADXL reports memory errors using memory-controller physical indices,
while the EDAC driver identifies memory controllers using logical
indices. On Granite Rapids systems, BIOS may disable some memory
controllers, causing the physical and logical indices to differ.

As a result, ADXL memory errors may be associated with the wrong memory
controller, preventing EDAC from reporting errors for some DIMMs.

Maintain a physical-to-logical MC mapping so that ADXL memory errors are
decoded correctly regardless of the BIOS memory-controller
configuration.

Fixes: ba987eaaabf9 ("EDAC/i10nm: Add Intel Granite Rapids server support")
Reported-by: Yanhua Wu <yanhua1.wu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260819025259.266201-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index b388ca955b522..d7ef6624c901c 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -598,6 +598,7 @@ static struct pci_dev *get_gnr_mdev(struct skx_dev *d, int logical_idx, int *phy
 		if (mdev) {
 			if (logical == logical_idx) {
 				*physical_idx = i;
+				skx_set_mc_mapping(d, i, logical_idx);
 				return mdev;
 			}
 
-- 
2.53.0



