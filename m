Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061281;
	b=E4MqwyoMLQtL8m4o5tqej/viiA67DAWnPjVjhg92UVcqMlvnpGOhjSNkiE+I72/wgAX0
	 0kRcUMan4XCUWfRHoJ0dOrl4Kheuqst23kLiIVM0u3/VI/Fyq3HOt6toWOU5wySFclSzx
	 vZ9ahTKRfFSLQCT3PhWdddSsAMthmrXRgj6+ZwZMl33lDi8l9Me1ib5WhCh3QsGkz1qjD
	 tt8scc/QJqGLH62p7plo8cjUYWxFl9V+eBqcDFsKzyTUVgMeAUVuDZAo+iPoo0IkGBjAJ
	 PzKdkRfzWRVePK6qog0BCFZyqZCpaSuz9jsekZIXq3XQHWBjer44ePVY2dYD4G2J9ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RMXAMrAkWYc054BC0WHxtPBF6Whx802uvnuTtFqozQk=;
	b=HsaL9r19k/j0AQZgjGechMcbnkSz2dYEDZVue6fmqCaJncrKaCydZO7DRd5HMBHhkBkj
	 5RgLc2qXQWOf/sGl/D2AoRqJZ7u+riLbwJHagG66USvW8Bb+hOkHekr5Qv0BsVpvzSfhl
	 dl4U42a229J/gmXe9Hfbib5NER8oVDtui9HhWLaBy/9hNgJYkEpOc940+9FcB8wB/bdA/
	 PsvAE0T/CbvkAn1w9AJ4Tgie+RskoALwUh956iE8S6+rBhB7CSNqU4WpMcqaNejHz7ESv
	 FswBSnGb9whapkAEknsdstwUiPqaEch7cNyZlUzLnBV/6WVzmh2liz40FGcJzvRT/kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqWh3M6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EB9606A325;
	Thu, 19 Nov 2026 04:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqWh3M6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1381F000C4;
	Thu, 19 Nov 2026 04:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061280;
	bh=RMXAMrAkWYc054BC0WHxtPBF6Whx802uvnuTtFqozQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqWh3M6WRo52c0TH3KrH6HvMP/MwziA9x+oQpG1EHsJYyRGiHjBpUpFRIY4q/S5sf
	 DmbTuw4+2xyelg5yqaByOLAlZunFhoRnqlibkqXuoFytHEJhi0eKh/bxzLwI5i/yro
	 XHzZrgh49Red40WDVlNjCHj7PJw/VuwOZJz+36Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1495/1848] dmaengine: stedma40: fix physical typo
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150021.823286713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit c281cde7a456aa9a56ced9175a4dead94048d3ba ]

Fix misspelling of "physical".

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20210126205906.2918099-1-helgaas@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f2baf04a695d ("dmaengine: ste_dma40: Fix memcpy channel parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b790c3c9285aa..e8a5574d1df00 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -107,7 +107,7 @@ static int dma40_memcpy_channels[] = {
 	DB8500_DMA_MEMCPY_EV_5,
 };
 
-/* Default configuration for physcial memcpy */
+/* Default configuration for physical memcpy */
 static const struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = DMA_MEM_TO_MEM,
-- 
2.53.0



