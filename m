Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022970;
	b=hRgX1gUy2cp9q59YPTk7JnMmyD2lfrqetQ6ZH0VQZTG0re4Hk28Y2vrSfF1U7cFWA/Jn
	 7pFp9KhMmx9J3JjqEK/d9FO1tcdha2nmLdYp1H6ECssLY0WzjwzuAsSnQehCBblAYK07g
	 zSBCRy6a22sQB3UWLQ+YGOfYYBxYWgBeXukfLU3cRMDFxbXyFZ709MaMY6c76ZuKfoIkM
	 SxUnYjp8sUc9NNBCY89UNOmllAl0YNmye6xcx+fiS2VQ2ZJxMydBviz1TvIu+qskOITsb
	 7lC2Qdi7ZVL9UgRTKoi1QT3oy5gdFRtl/pE/6zWJ4iHZU3bTsQ3IgmeyzwvTUGS1VlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2mIyg5iVSYh/IIG5Ww94nauwrTYUZSWL/xyC9RM9o5M=;
	b=3rUesWrQyGJbTIZR1EJL8qpfaOJKBysTZ32FeXu74deYIpp/1O2fWYryILGju/5jAczo
	 7uus8tEmZXag+Wotmud77rdjxVEnV6/X03u6e390lIGlp4CQ7ueoaiFYtpmCgq6BzgBTU
	 UEIUHB+3q2VfcBhdbqFLFZMLWV2MOS1KPBdYF8OD2495Eb2nkAZKuDaSyM7znaqZq4iXo
	 HgK/fQw3i5ayZUtXFmXX9byuFobE/KFO4kzIejpwCz0V0LRVXAZOnZ7J747qsDQicUBLq
	 BZJkgCzSOrxUKiIEr3ql0rlOPvYLeymRegAur0O6/j5emNM9FJ0NIm1PLHsp3Sc+CBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tijBE1tP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB6D606A320;
	Wed, 18 Nov 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tijBE1tP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537221F000C5;
	Wed, 18 Nov 2026 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022969;
	bh=2mIyg5iVSYh/IIG5Ww94nauwrTYUZSWL/xyC9RM9o5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tijBE1tPsrgRHwP4+r4/zVD4bXbN65hyIJqAwYiw700EMbqpcNlAzmJQ+qBw4Kr9D
	 tc5lFi2CnN3GBjqA1SoaL5POcYbvMbCLxr6n86vI6u5kypsqP2l0aMZGtdtQP9c8hs
	 LafT/eaCh2+MZr9KLrLarzZw8RXk5w0fqIEjhaRk=
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
Subject: [PATCH 6.18 0203/2151] remoteproc: imx_dsp_rproc: Drop extra space
Date: Wed, 18 Nov 2026 15:32:18 +0100
Message-ID: <20261118150129.169506740@linuxfoundation.org>
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
index c0c2bda4964a7..b66991008d6f1 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -784,7 +784,7 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
 	pm_runtime_get_sync(dev);
 
-	return  0;
+	return 0;
 }
 
 /* Unprepare function for rproc_ops */
@@ -792,7 +792,7 @@ static int imx_dsp_rproc_unprepare(struct rproc *rproc)
 {
 	pm_runtime_put_sync(rproc->dev.parent);
 
-	return  0;
+	return 0;
 }
 
 /* Kick function for rproc_ops */
-- 
2.53.0



