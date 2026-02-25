Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2123D7CF;
	Wed, 25 Feb 2026 01:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983383; cv=none; b=DganRZvfR36V3FQFfrhDUBvX92lZ3u5ohSzRneRYsyDGs2faqzJi3xmnldEWkUKRMlkzR+qwt7fipbvbmpraQpGjsv8ZLLkWYM86KHCHMmF24ZMYnwq2J6Q5VbLpjMblojUCY/QVEosKF/t2xeJTf+g7IvscnCO4hE1wCV38zWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983383; c=relaxed/simple;
	bh=8eIGOma6ryY5lbHFJqYvruv0dqu0WGEOEoqO/NOP2yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0L/dZsBt5zWYlaOF+TTlzcs8nYer0YBdFoKITMNhKSTYJjIGSZ0Rd/0s61GoOqaoeMTDwRk0YVURh46jfhdI+8JgWY0xGuJf55XLIs0CfRegkMYYOVFTV3ZuEMX7T7YZ7mCd8ZpCHEXKoYKS0W9C7eFjCifzHAIpVgzAuotHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0d9CXBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0d9CXBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51833C116D0;
	Wed, 25 Feb 2026 01:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983383;
	bh=8eIGOma6ryY5lbHFJqYvruv0dqu0WGEOEoqO/NOP2yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0d9CXBxKDejZqKL9DEq2h7W0AkDGu3DL/o09Q9c319QTrLwHc7x5NFDR4UZCIerv
	 FBUg/YLh+Ap2cxRAut7jNVSjtZdgGrK83JoIG6j0y8qaJMYSPNlo4IUDUpnb8vSmn3
	 OLTQV8QNCp5fQvO8VkRpNlpHQtapKyUfqPI9WkZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 507/781] remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state
Date: Tue, 24 Feb 2026 17:20:16 -0800
Message-ID: <20260225012412.238581291@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 83468558e634e..5a9a8fa031f6d 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -1000,9 +1000,11 @@ static int imx_dsp_rproc_load(struct rproc *rproc, const struct firmware *fw)
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



