Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E17A1AC8BB;
	Thu, 15 Aug 2024 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731672; cv=none; b=nRdVMJIws+Z2OAmVEIAP+14bpJMWvjLmSXea3lq/NTwI/5oyGt/qsLydALemDoXEvR5QCLDq9R2zfdKo+Vm0xvj9afUT9N+D4KmHpGQ334R2NbGDxjYB7eJzRBk/eS1XJPUPxIpdQx2UYB3kZRFwDGlu7WZf0DcyDIFQNbwI1PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731672; c=relaxed/simple;
	bh=S+6xZkbpntIQHOqOwL7fVnucWCzIgiYAmxDNhr1igKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xyj6sfVWgUjCETeML4CybyIvJjnNGVj0kJtcPcKazQQ6/8VoGJy4JG4VuTelG81D+AS+gfrBqlG98xcvINyNin47YigpsADxRaIZhdwyizM4itE/OchI/o3RBfrqJ7hJLXoA0AraMnPrfSAf4Sonndzt+uElmJBYYbItCdU+iLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSnmNX7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSnmNX7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C06C32786;
	Thu, 15 Aug 2024 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731672;
	bh=S+6xZkbpntIQHOqOwL7fVnucWCzIgiYAmxDNhr1igKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSnmNX7n/2QlwYVIM1gnbY9ZzCgKLrd0v0kZElsFXphaRFsYjpULNc4rbUIeTTHOr
	 fDKoJUFX8/TXQYeMEB6rYw/yBOr0/UA155lMXz/E3r1wQHxwMwD2OWu10F0G5RMOkT
	 eiO+jVuD2kpVhMzW1P8MxivAQZiSP2KjJZx9H1Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/259] remoteproc: imx_rproc: ignore mapping vdev regions
Date: Thu, 15 Aug 2024 15:25:03 +0200
Message-ID: <20240815131909.345570897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3e72b6f38d4bc..05b724fdca591 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -286,6 +286,9 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
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



