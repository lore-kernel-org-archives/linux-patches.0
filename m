Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE99305E28;
	Wed, 25 Feb 2026 06:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002634; cv=none; b=IFopE1jlAO9ibPyxR7nYcGRXMvqJNFf6AMZgpCLguKYkRzUjEWnuCLRNeYemDLnniFSG8VABHIHzmhH6sQR94OeYnoDrzFvaZmwe+BZhx3OKyQCVHrE7OwXWXo+DPe4/v+cFgPppzIIxNTVIXhDfWK/NMSrwgzPsRd+SHwVoGRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002634; c=relaxed/simple;
	bh=hjlBz/iTZzsnZIaxFNT+Nl1gl2EJ32VXJyEzyDJjFeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXxDr6QDyl2yOUN8mBfNdJAtsFiMTU8FPVPx2h2LhE9TeM8nMkiUoeilZ69NiObUHbLw3283FWDEbMI1kLf0igqB74oFqz+onoiha0veC7mIpYzZaBh5+K66RdpkNRJWQaIYsvxOBXgruMBcXlgeVsdcNytHTQ6I8Z89OkR41Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDEpXRvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDEpXRvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF7AC116D0;
	Wed, 25 Feb 2026 06:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002634;
	bh=hjlBz/iTZzsnZIaxFNT+Nl1gl2EJ32VXJyEzyDJjFeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDEpXRvWcSge5ud1hI/aT3xTLx//FfDiEnthM8WuoB3+CNER/RGrhmef2Hcl5V+cR
	 GahEzJNd1OzuWAsxDsUAYFJl92KydDgoz+IIXq/J0TDgCtyMHaO4OoBpBjPmROFqFE
	 kw7JjWDZaFZYZhvFCtP6P6vHLM9j/SwSW1Lo7hCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/641] remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state
Date: Tue, 24 Feb 2026 17:22:04 -0800
Message-ID: <20260225012358.216244080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit b490ddf27be28e64a39c08ae643d7b22561beaf6 ]

Do not reset memory at suspend and resume stage, because some
memory is used to save the software state for resume, if it is cleared,
the resume operation can fail.

Fixes: c4c432dfb00f ("remoteproc: imx_dsp_rproc: Add support of recovery and coredump process")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20251218071750.2692132-1-shengjiu.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index 6e78a01755c7b..e61a08df113e4 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -1026,9 +1026,11 @@ static int imx_dsp_rproc_load(struct rproc *rproc, const struct firmware *fw)
 	 * Clear buffers after pm rumtime for internal ocram is not
 	 * accessible if power and clock are not enabled.
 	 */
-	list_for_each_entry(carveout, &rproc->carveouts, node) {
-		if (carveout->va)
-			memset(carveout->va, 0, carveout->len);
+	if (rproc->state == RPROC_OFFLINE) {
+		list_for_each_entry(carveout, &rproc->carveouts, node) {
+			if (carveout->va)
+				memset(carveout->va, 0, carveout->len);
+		}
 	}
 
 	ret = imx_dsp_rproc_elf_load_segments(rproc, fw);
-- 
2.51.0



