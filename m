Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829408;
	b=R3HA6sJf8kdoAncqGVu+CuVebIde8BssdXsYJawUI4pLboHIPjp37M4BIR14R+sUS9FB
	 2JdsJm5vFq5QO35Elp3/8PSmPK3bPxgjI1OA3MwvBK61pym0HEkiX2vRDF8xf8HakJWHg
	 8WH3pi60LU+vV/1cvG0KHs0simztRZsC+CpOwPrnAqMqo879yU+qrF+/7xpoOCzOr7iEq
	 eD3QrYavBSMCxwhcFY+8PTZgyR22GRJZssXOMYtfHEfsvlvGITRJHBzqSIjcz4RxYHwNm
	 +g5WkcGRDycKTFd+LAExqEKzGvGS2chI+a27LbvirGhzl/p2ZyfjxHfzdF7rweoKq5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2xzXWmxgXEAZjng7f4WVTFpxe+yq+8ib3al177K93a0=;
	b=sbfs+ajbdZfAarn46cF2ZfxDd+jXZRT/t+w4AjK76JEIPMMqnvwcZrI62SyKcjl2bnpR
	 rT7RibeEJAev3zKuTOw6Ub9fw6sWKAE6/PBy0fAY6hBGOVnEmDc6mMJyw4ZIydBDX9nez
	 RNY9t4XKARpu1aTSrFpEvaTLyMp4peZNekqkxRN9d8ghsUYmIf++f6kStr8DtDfzZ08GH
	 aD2/UpK8ZthemfPNcanrJUSexXvF1lh01guKM2M03QXEGt7/t++qaOf7osS7eF4eLysmm
	 a5yfDuoOLNneGe2TZdJ6iLSuyy0FSKv5eSNEXiHIYlEAFnHl3e20rvy77P+U/UlN5ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlJiz7Da;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD210606A865;
	Wed,  4 Nov 2026 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlJiz7Da
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A2B1F00919;
	Wed,  4 Nov 2026 21:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829407;
	bh=2xzXWmxgXEAZjng7f4WVTFpxe+yq+8ib3al177K93a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlJiz7DajeENwlCFmYPsYq6rAFbt26J3XPfi2GV4+beg7Ab20II3yx7Ri87akLUOK
	 8nzTDDHNqvT7hHgsLG8jjnp6EAiL33rS9Of3qFYePgSyBXfFPON+XUHFY4R7iY3Si5
	 C6UODLxovaXOrQM2kqdw4c9KCawkRpszlVYUKmG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0108/1005] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Wed,  4 Nov 2026 15:57:21 -0500
Message-ID: <20261104211046.677228639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 09c9062d4f62199a634a45e2bb9e6e8e572cc78c ]

With Partial Report (PR=1), the Number of Zones (NZ) field in the report
header must equal the number of zone descriptors fully transferred in the
DMA buffer (ZNS Command Set Specification Rev 1.2, section 3.4.2).

nvme_ns_report_zones() does not cap the parse loop by max_in_buf derived
from buflen.  Cap nz with min3() over the device-reported count, nr_zones -
zone_idx, and max_in_buf.

Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/zns.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index cce4c5b55aa9c..f067185920451 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -178,7 +178,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
@@ -188,6 +188,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -207,7 +210,8 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0



