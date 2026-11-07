Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060652;
	b=kJ140J9hR4u3ymMVjj31sWXbNcvrMPkhkFI3BEBeba1eoqpi/pJSxjjyircMw5RxQ/C1
	 SNSciowWkcIEC8kYVfqGSonNVUXMhJ0XNtMHwtIPZ3qODhLu5qIAZg8WSTKaUxYmArUGV
	 lLI+DeG83LZTWK/r/+48LA+aeZlBjVpIzug6Uci7BZHaGKqAPi6VHMtkfYdMnMb3YVHaT
	 Jxuyp582JVLewbhoamevAlybpapCn4wXH3F/3Z0kgBQl1Q38rKbJM/AynG6LbpAmtjSlJ
	 UlFUi3Ow6pJ21OoZWM3R8EiAv2Wo9S+eX/fZveZWW62iIwtyNrI2dP7VIBexFDPD+1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Os46eE3MpP63mh3sgj8HX6RGlQrUgQQCIholYJzkoko=;
	b=f6RaNvKghwuC1URb9wh5NWOGw5+xADtXjS8t2BUuERuhwe5xltt9mRzizjgQUXM+8f5M
	 9Kwp8k+jnntCzzNfxsCtpBnyQuegJEIKA57oMDK/rVrnKGz7mgjIp0WAm5uA9h41wGCYX
	 K+QQwAyAXVh0Fjg2mkWvFayrGSrqBBtI55DYlARf/yyFytrDMbAQXhH6NLyNG9zT0TGk7
	 T+dkcPRPmQBFDG7pe3INcv/yKrpPe5pX7aECVks8cW/ToCuJUIurVwyV/lcGOoDUSezjn
	 DSfQ6Kx6TN12i6y5BK2M5pHa4vu20od2qLM/mK+zR5rot/Gb73MAJU8LSC6+RRYDZ5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsjSbfsL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D5E606A326;
	Sat,  7 Nov 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsjSbfsL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238AE1F0089F;
	Sat,  7 Nov 2026 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060652;
	bh=Os46eE3MpP63mh3sgj8HX6RGlQrUgQQCIholYJzkoko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsjSbfsLe/rjYSyZGj3gFcaApV/FShY70MYxKoGngkaK2BOii2Jvy28SfGybivxVA
	 b4iWLqViSqbnX+cMGJ7d5IxIQLHdDQA03ov7zLMHVf/cGWkM5tuJyWKG3l56B8q7N2
	 3FHutRgS8vXLkfp2nZc9KC/EbkaaOOSQ6++1q12Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0093/1536] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Sat,  7 Nov 2026 08:35:09 -0500
Message-ID: <20261107135000.276342402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 9a06f9d98cd68..06a32d3a93ffa 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -179,7 +179,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
@@ -189,6 +189,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -208,7 +211,8 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0



