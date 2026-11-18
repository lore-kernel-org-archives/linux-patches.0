Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029038;
	b=bvyU1S/J84UVy2Ez/+QPsqLGAOgpwE0IqgMp++MvcyJmoCsvtzpYU2W/BpJVpWsLGaPb
	 6CsGHxsbU2CIOtQ5Mo+2dufwUeCQbSkhxWEivNO0y1B1UTkgv00LkzBfrIeWJRZCzhhse
	 KwND8tFH8NDVAwB1uhyBJFi0d4hiiQmRv2AL+7XynYqcYtaSezzbINhBuX7+NkRwnMd9e
	 ds9Hl9oSNZCpu4bF7I/iho273aC8mbJcY1X1u4rHXsB0wZg2vj0efYR1naUXyEZYBBnWE
	 d4wlDI+kzyrpiKwFHp7Xo4a8thAN2HpMstyYj5g9BTSNwgO9jzw7cxdADwYqNSSUx8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EeAIdeEikIpxWS/eb1wmb7riMLPC27QPula6uJOIrbc=;
	b=OHum7cqJaGf3EyB0Da0WsiAih3xwCYtSVXXkeiejzbomwW7vF5g06n2I6E+Qo5Kkk3Jx
	 x35pgRenZQEKv4fg/oUpZk1ngtjojKACuW+opvfgZOTDIDRf1ojcM+zjcPeXUJx6/VDF/
	 pf4fafC5ybmrFL/g3YTJ0sIIoK4toQO9F+QVkCP89PVbb9wqzOeZf+XaasTjrn5/8LWgG
	 /0qjj/HRYCu33DSEHbL6aGxvZ15KYxlDgvMZxgJZbSLjirrbnU1orXKnJt+18DgXCHToE
	 BlOxibdwhOxHsT5NazDRlW6jSWRFXuuarkZ9Wsx1+6oEmCvIvJ1E/IdMPUodeps5mOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTFIp0bM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF45606A330;
	Wed, 18 Nov 2026 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTFIp0bM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66CB1F000CB;
	Wed, 18 Nov 2026 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029038;
	bh=EeAIdeEikIpxWS/eb1wmb7riMLPC27QPula6uJOIrbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTFIp0bMfgWpccvEIDzFmhkj8cJfXkv72aVNtCBNoVrrK/AHeGT74z99S8rHWgYxc
	 OMQS+orJe/l3rXTbt1ANmnMZjg0Fk5s1dfuMtTHcl7c0dsiNn7b3X+R8mlQGzw2iiM
	 lKjTM6o4+UsbzmNb0Zf0Dq36fMsC+UX2J+CVvzu0=
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
Subject: [PATCH 6.12 0206/1756] remoteproc: imx_dsp_rproc: Drop extra space
Date: Wed, 18 Nov 2026 15:38:53 +0100
Message-ID: <20261118150016.559973024@linuxfoundation.org>
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
index af0b9d39a8eb3..2a999f0283142 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -690,7 +690,7 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
 	pm_runtime_get_sync(dev);
 
-	return  0;
+	return 0;
 }
 
 /* Unprepare function for rproc_ops */
@@ -698,7 +698,7 @@ static int imx_dsp_rproc_unprepare(struct rproc *rproc)
 {
 	pm_runtime_put_sync(rproc->dev.parent);
 
-	return  0;
+	return 0;
 }
 
 /* Kick function for rproc_ops */
-- 
2.53.0



