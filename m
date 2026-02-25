Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EFF18B0A;
	Wed, 25 Feb 2026 01:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983381; cv=none; b=S85bc9Ugm6mnV6as0m0avuDr+eOKBZGtMPd2M/ytpC5xMlp3SSaUdnACoxU8pA1fC8SAz08YpdMCnQQCwLJpxngqDqJ3VukTTjReFznploMCd57cNCN6zsCgUxxN1c56ElOcCGEp+Il1CZuIbufk63eDYUL2U/5RsGB1VnJLPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983381; c=relaxed/simple;
	bh=7+1XSN3rX1s5pBtvAhWwI0iCXcOH1B73fuqNJQyLhf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPN6KjoWrUcIgAhaDp9dK7HOPW6aOINK5DOkqeKUPLaK0EiozwMemw14b1vclxYEImkHM0ZSfFxfgqMUlDKjxkQwO5zz55mFIltepdDPYMGn4sIyAzk+WZEOal98OTCbl/w70WZDtxUUIsQXhUdonUEckCpw/IWIpSNfHmX0PNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3lZZdzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3lZZdzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56130C116D0;
	Wed, 25 Feb 2026 01:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983381;
	bh=7+1XSN3rX1s5pBtvAhWwI0iCXcOH1B73fuqNJQyLhf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3lZZdzrYPCSdrs1c7hlhCq4UvNvGgMgVd9vsf5i3rkJEGdJ+RjNgRPCt5mPNyt3C
	 JDChoVqH16o3doSc0fh5KnMhYC0UMAunGlIZsz8zwoLCPwsKJb20nZKqhq/TvM+q84
	 Q2XirZPDQneQpypb2Sd4P6wG0UXLIGeqNQqKMp3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 505/781] remoteproc: imx_rproc: Use strstarts for "rsc-table" check
Date: Tue, 24 Feb 2026 17:20:14 -0800
Message-ID: <20260225012412.189965997@linuxfoundation.org>
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

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 93f51b9182a107cf5f5e8a7802cd90df0c9a7154 ]

The resource name may include an address suffix, for example:
rsc-table@1fff8000.

To handle such cases, use strstarts() instead of strcmp() when checking
for "rsc-table".

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Fixes: 67a7bc7f0358 ("remoteproc: Use of_reserved_mem_region_* functions for "memory-region"")
Link: https://lore.kernel.org/r/20251208233302.684139-1-shenwei.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 3be8790c14a2c..33f21ab24c921 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -694,7 +694,7 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		}
 		priv->mem[b].sys_addr = res.start;
 		priv->mem[b].size = resource_size(&res);
-		if (!strcmp(res.name, "rsc-table"))
+		if (strstarts(res.name, "rsc-table"))
 			priv->rsc_table = priv->mem[b].cpu_addr;
 		b++;
 	}
-- 
2.51.0



