Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047848;
	b=4JFaf/Q5T94jaVMrSBRFc2Go98BQQrIyuWnnPb4pS5eumTzV4pVoZ/iM8mDCxM1I6uU3
	 TSjYfqLe9Q2og30L7PL/lbzo9WFieiCsfX+0oQ0OMkxhA9K5Udwft3TckSg/wb+/U332C
	 OPch5cdmUd6UwTT3YLfbeSinc6yQBphp/nWYSpU/X5kD7Swh9vgwJ2dFdJEmvAp0MtlM+
	 Jf1SDg5oKAJU9YyLYgIwNrrfoY0yfFr+kT+l+wfd3qFWDUEkjQD0dTwZV+rHIve9Fpv5/
	 TdIB1NldoeA8ow3u9rtKcSwsF88mvUuZjGSED3BhzMfbdfY+yL6cOta60APU5F6kBYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GI3+mHVTHCiGYtwBcdjfTzP0HQa8zI9DergkdaEMmf0=;
	b=1osvt/GbV4bEm7cE8YkMHW7r2VJXb63dQvKNUchdXXCL/TMbFLUqEXjSMwnA29i1NXns
	 DY8eDl6p9pCufM03RW+y7fNpN7KgAlpgjlASGVDmQ6CqZjOhaaFcE8R/Gm4sqVtBNC3E8
	 vy6Ixe94rEJs/HjocJz298ilr89FGAWxYE+7A0lGY3YRTky4+o9bn0DB4wptS2Z+/BNem
	 TlzSfgi6uVerQuUKCcBGDfadPSONaC7iGFJa73u9qQqeh3iNxXg3Y7u2GqrPdLs4pingj
	 GGJZWR7pgnedRBhunlxpkzeyYpL5Q1dWKzjLKIQywQAU7WXu3RE1mdMQw6CHYlBhyFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yuiB7UDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9303A606A31C;
	Thu, 19 Nov 2026 00:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yuiB7UDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A121F000C4;
	Thu, 19 Nov 2026 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047848;
	bh=GI3+mHVTHCiGYtwBcdjfTzP0HQa8zI9DergkdaEMmf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuiB7UDU+rSWqNrUpOPuZSHq9141uk6c2Ea1xBxmobdoaWD3H5xjoa7JWfR7B5rFM
	 sUjLK180uOqrXWphspu4fNzUyqJp7uMdtzAJmP5D4lKc/v7S3Xr+Gc1Lejp76K6TnT
	 w5IY2l08gZsRdVQtRj8l3i7KoCewbMSCCzrDwT3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1786/2857] remoteproc: imx_dsp_rproc: Drop extra space
Date: Wed, 18 Nov 2026 15:47:00 +0100
Message-ID: <20261118150305.578485550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 8049dc7b631e33a42d8413fe48b043113afa914c ]

Drop extra space between return and zero.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20251119-imx-dsp-2025-11-19-v4-5-adafd342d07b@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 13df1fa4f1a3 ("remoteproc: imx_dsp: Acquire runtime PM before adding carveouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index c8abd2f0b188b..fd0e75e326979 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -676,7 +676,7 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
 	pm_runtime_get_sync(dev);
 
-	return  0;
+	return 0;
 }
 
 /* Unprepare function for rproc_ops */
@@ -684,7 +684,7 @@ static int imx_dsp_rproc_unprepare(struct rproc *rproc)
 {
 	pm_runtime_put_sync(rproc->dev.parent);
 
-	return  0;
+	return 0;
 }
 
 /* Kick function for rproc_ops */
-- 
2.53.0



