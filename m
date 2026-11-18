Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039266;
	b=P3qRJKIYUElm0XpQXJUd6ewNyGxViPLagedzsLt9IyP0ITK1wTuu4U21pqvB6qZKDv7n
	 Mb+LpIIfLrQrFU9V5ZNxV8RO8nEm0Bd6R9p46sd5oJ90wlw1r3NkEpKElSBLBa5Cry61l
	 80X7kGYUQKfjN3lpb3PFBYafpn8QDga5kybAb701Cvo2HKazh8wnFY+E4d4WhF1lKhQE/
	 brkYAuyvwMKIVdL/VZV88jeR+OTnuV9OiNPlt5e3jgQknhBDiFj/8cXMNfbtIfpFMSaG4
	 KvR3oS+6K54LxHyn8qU2gZ1Yji1hxD+eCj61jrmuNlwf+nQ2pHKbR+tzm8LHcX5XMXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QBEtNj4LgZQeenPOEQ8ZmOKj3K0GRSmw4lGUKLk6Rt0=;
	b=g0qp8VMgseEPw+MNI4yyLb610h5fPsXsVHtXNxqbn6TvwWeZk1dsgQLtTAyTFvtUyUAu
	 6ye0vHsgtpLEiIqoUjAHJ9WpvYWNqDVw2i0AHTNVV+oYNv62L/7CIqLiWD4jc2bNHy2W4
	 DzZoOdNh7qKKJmaDszp9h6Ad4BHRQehJ8/XHKNKNJE9NsvQtYzPgNvBXQOS9aSZCfb8hU
	 WSTL8/gG1h7OHjgimGJN6jNMinMTKEZyfqROP517OFvwNzESSAOxhSJCplpgL3fhw83tD
	 qlxRuIhBsG7mmyYPe7cLo6wV4ds2gDAs3Tga3O3OYq97NF66VO+RB1qaCDGqvDOVlDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zmbRuJpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55756606A32A;
	Wed, 18 Nov 2026 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zmbRuJpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C241F000C4;
	Wed, 18 Nov 2026 22:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039266;
	bh=QBEtNj4LgZQeenPOEQ8ZmOKj3K0GRSmw4lGUKLk6Rt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zmbRuJppKHy6uOcbLisz6PJW+qtLULjryTb4lD6Dpc2dt6mDzgxsU5xunWYKzpkHM
	 jnW9J2qz+NlSAipLxe6c40RgW8Md6m16fkhMRj5PnuXZWNb/E/W4Yw0KTxcwtPbkmG
	 yzbHKZJ5SJPFPVaHBpEunVc9w/E+BsafNnkvXu4Y=
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
Subject: [PATCH 6.6 2038/3318] remoteproc: imx_dsp_rproc: Drop extra space
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150423.182628368@linuxfoundation.org>
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
index 85a51b1ceb72a..491c5a48770f8 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -694,7 +694,7 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 
 	pm_runtime_get_sync(dev);
 
-	return  0;
+	return 0;
 }
 
 /* Unprepare function for rproc_ops */
@@ -702,7 +702,7 @@ static int imx_dsp_rproc_unprepare(struct rproc *rproc)
 {
 	pm_runtime_put_sync(rproc->dev.parent);
 
-	return  0;
+	return 0;
 }
 
 /* Kick function for rproc_ops */
-- 
2.53.0



