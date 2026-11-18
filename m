Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051020;
	b=bqLRblYPpE1xwO9bFa6iWXzBbCZm7eizapH0Y5vgzESHZSn/T4GBVXhxUOnDzhRw95Dm
	 GDa6OAivvy6idjmRb9qFAcCo5Q+XIw/DJQ316ufWSzYlESeBu4hbk/eB053g2mJy/jjyo
	 SixUiCHpLTYLKEoI2EMCB8y0rLMNiAXSvpTPHAJf+mY5y+n1eeSRcbdgSkCTPaeoV/SdP
	 cV7nFSrmpXNaTYi6Wwu/Rp7KKXH8wxSQDIuLqXYPXJwPojiF0NeLnV3UvLYiSvmDoKRFS
	 RCAMR9nVwJt6FzOsGmJgQyfikbaAOi5ummwh8nM00gOKfvFKVukII/dD64NZV6z1ySA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FhBfMHkKgXk97gJbb4V5XuSNnz4F9vEdj3wQya1ftaE=;
	b=fXDFe7THV/pP1DJjshHcZgI+UftvsV33bQahyXin7mOT+L938AO3KOOWPiSn69uIgzPp
	 4YbdCYYilzPyEopHGfsT+UstBuHSFaU1MITHr7Tvfz35TxIL317gbydVxqdlbbjbeaiNc
	 lfoYEcv+PxjdwhMHnJkVPNWBUvJKV2rdmWviepGrKJMb09BLolX3373DYn9o2nLvJQ1PQ
	 coTLXKW5d6rZHdJMBUQQOV09nWyCNCF1zzV5Mx89JIhm/qtZDYpJl8Cnscio/ScYN1MSb
	 xUbBgQJgcQd78ZqBK9MpJ9E/OhamMcVNXJNae7VYWAHf4vGHyYVAis5Or319uCjR7sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jk4dFkNo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2662B606A325;
	Thu, 19 Nov 2026 01:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jk4dFkNo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5091F000C4;
	Thu, 19 Nov 2026 01:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051019;
	bh=FhBfMHkKgXk97gJbb4V5XuSNnz4F9vEdj3wQya1ftaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jk4dFkNoia9Xa5b2PzerfhfcBCfjRBGg/tbuOEnVyhsEkDtQ9t5xqC1Ox5jxyPk7j
	 xeJMuzpzRiAn7QkZUKRU2sDoK5bsWxh9oX0IYESW54ESft1prRk81WCGVFdkrsjrPS
	 aNYdVOrKwmZ3apOtN7klpkQDRf0S9/6ltErqwmwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0060/2214] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Wed, 18 Nov 2026 15:28:56 +0100
Message-ID: <20261118150012.422611399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d95010481fce0..aff269e1c5398 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -177,7 +177,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
@@ -187,6 +187,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -206,7 +209,8 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0



