Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4CD3214;
	Thu, 15 Aug 2024 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732601; cv=none; b=Cc0W+Le7413fWi9jHb3FtRGYD27td5uD5uQEap+lHM2OCCGGrq2oNLWiiGxIvPMOxCdvHdF3JLj1I2zvB6+E7XXJgZOsjIZtnS1fbOIvpzT8bs7UwEQFdL0N9f898mK1A9Tsi3xqqVkChJJXwsBFlk7KBNjFjjbP1vUG2s/hoVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732601; c=relaxed/simple;
	bh=hrc3VkOhn3lj37N2lKSJofaqNQKDErG3Tf94bVyuWwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jc8c0IXDcq+P4WN3nfq8D9zPqu75/vqQXX1NjSGLVW7+ku56KvX4cuuKE/M93paUtT6U2zbZU0ACYZ5zEsR0nvcnhJ3binx2FHFTlWlnC8EgOw923IXRADqLXjJY90V54PeK+M3+/SlpjB3Rtsg1IeTiELVyYXGxJTyFrfP2Zsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/+WSVxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/+WSVxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C507C32786;
	Thu, 15 Aug 2024 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732601;
	bh=hrc3VkOhn3lj37N2lKSJofaqNQKDErG3Tf94bVyuWwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/+WSVxYdacNj9MM9gQYCuwscV3fiIx9SW3a46VVHWYYcCwLj3rTrhwkrAdY0XNSJ
	 3EKn8YjrUvS6EMt7NNXQA5MqBq96dHRe9XnT7Db7OqARafd1J1hTqJcALe5/su8/fH
	 G+JBgqBCvFuABrz6NyKM9DXUfmKgr3z0VCkD+KqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/352] remoteproc: imx_rproc: ignore mapping vdev regions
Date: Thu, 15 Aug 2024 15:24:56 +0200
Message-ID: <20240815131928.321016747@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 8f2d8961640f0346cbe892273c3260a0d30c1931 ]

vdev regions are vdev0vring0, vdev0vring1, vdevbuffer and similar.
They are handled by remoteproc common code, no need to map in imx
rproc driver.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/1615029865-23312-10-git-send-email-peng.fan@oss.nxp.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 2fa26ca8b786 ("remoteproc: imx_rproc: Skip over memory region when node value is NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 8957ed271d209..6e233f6289200 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -287,6 +287,9 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
+		/* Not map vdev region */
+		if (!strcmp(node->name, "vdev"))
+			continue;
 		err = of_address_to_resource(node, 0, &res);
 		if (err) {
 			dev_err(dev, "unable to resolve memory region\n");
-- 
2.43.0



