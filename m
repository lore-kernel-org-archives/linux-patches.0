Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86A53214;
	Thu, 15 Aug 2024 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732604; cv=none; b=mjw8gr/mxQpMcQ4wJJ9k4pEUhh3uQ5w4VWKhPgm6DqMAvWTvWRJJlFSbzcDPE/iyXgzgTxJ2++tqbQtkx3Ym8VhhgdoX6EbYkUCqVE+CCVk6UNBJWr3dS7ti+/XWDALCu5zA4/xALVSie98oGmHd7IKH7N1NyHs8YHNCCzRM3vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732604; c=relaxed/simple;
	bh=sRwReKQaqk5cQIfD+508qfJigfSJd/95tZrVBjBBdhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um0ueOE26lS88mKcB69beO/RhDZ/gZbbYHv6CxhRPK+lcBgESjG+JAj9rkxHO5f15cnRT/K8kd5CYmaaPsPXOpI13w6rLItiVZp9AadcCd8cS1kTam3NNTtGP2GG/vtf+i4WHmp3r+9RZiEoPUxBvU1nY6Ccdm6GT2vXOc9i20I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEIJo4wX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEIJo4wX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3237CC32786;
	Thu, 15 Aug 2024 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732604;
	bh=sRwReKQaqk5cQIfD+508qfJigfSJd/95tZrVBjBBdhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEIJo4wXRo6nqhB3KqM71sZg014lGPZrXHkIAvKE2iCdll6v2vWf/OE5v/Au6Aq5m
	 uDzcwFP4cQ11OsQzeJDnsmfO8bIOc6JK2+7o6pOnHJCz5/u0S9YqZNWeXIp4fSmuq6
	 rBM9nBNWWJ/P5s/PjuEYEFZtMEPlDpixExN0DmXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/352] remoteproc: imx_rproc: Fix ignoring mapping vdev regions
Date: Thu, 15 Aug 2024 15:24:57 +0200
Message-ID: <20240815131928.360780550@linuxfoundation.org>
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

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit afe670e23af91d8a74a8d7049f6e0984bbf6ea11 ]

vdev regions are typically named vdev0buffer, vdev0ring0, vdev0ring1 and
etc. Change to strncmp to cover them all.

Fixes: 8f2d8961640f ("remoteproc: imx_rproc: ignore mapping vdev regions")
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-5-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 2fa26ca8b786 ("remoteproc: imx_rproc: Skip over memory region when node value is NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 6e233f6289200..517d1b5733288 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -287,8 +287,8 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
-		/* Not map vdev region */
-		if (!strcmp(node->name, "vdev"))
+		/* Not map vdevbuffer, vdevring region */
+		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
 		err = of_address_to_resource(node, 0, &res);
 		if (err) {
-- 
2.43.0



