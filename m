Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033730;
	b=2lR1aEGbZzs/MSFw8NxDoYyl70AH1eaAdP6NCg8MhJp5mIMT8sPTzOXwVwJTSAxrLio6
	 Y3pNeKNRZnnKsizvPaupHZAKl2QRhzVrrYfeKRLc1f/l4GQmLzYESya6pf+SlpZugU0BS
	 rWpY6zVR1CSN8EhT96Ueqwa6OA/Ffx89dBiJSzbTFJFuF1BvVG1jsRXaDu8lSmzwTPC8o
	 IsnNbkjaNfjMFA/quEdaJ+Sa9OLT/8AO/zmyXdUUnwUdnO9Vsbd+tfEnzHkZsK2zXmzzl
	 V1CfmtOpamWOcJ6b6AvbQ5rvjQp+1YVcj/SFe/R70HCdi+m5/S/QmUvm3cNRlGuA+aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKFlfXLfbWJHZlIQh6ITgur427AojBfkEdT19kc2xK8=;
	b=5YKspvZT9HgayAQv/pEE+ojUIFzxZnlnNJ1Pmfnm3YGDwsHVbP3uhH9TpwZdBBA1dvHO
	 Oo/kH84W2oMiJnW2oOOWO0vSmkkA/CKYcOgt3iC+69MjIytC5R+IX1Z2cCC3M4YmrI/BU
	 nPPjiRuKwSW5jN1YVMoUrna/39ggh/Km3SGfsZDZhkLqI9EaXqku38cFl/2g9qG/bWOFf
	 9W2RRba3FaXqfK5yauElJ83wCqNUDShXgojjWBJbBKUEGp2s2IAqwrTWdPprj1jOt4M9Z
	 Jmr6wV3cmARRJKpcoZ5228udLGXFAnQ6ilD7AvHVNwCEDY75CPrOA/OOSUGwbAZvDWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xff3b8wC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ACB606A31C;
	Wed, 18 Nov 2026 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xff3b8wC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F2D1F000C4;
	Wed, 18 Nov 2026 20:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033729;
	bh=RKFlfXLfbWJHZlIQh6ITgur427AojBfkEdT19kc2xK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xff3b8wCFGB6e8L2HPk0Ti2QHAvNpNJTmyurtiN3HDbAhk4dWUjhn4YCYAdFciOtt
	 A4t8soG/YJunUH/aa/tnKITLrhpF0CmXNQCnVNjN5wEgJVcqzlqDkAw7F9GPXccUUq
	 F3CyhvDBq28n9VGaE7YtXTgX55aMjoUt/RwJ1MWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0076/3318] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Wed, 18 Nov 2026 15:11:38 +0100
Message-ID: <20261118150316.347115633@linuxfoundation.org>
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
index ec8557810c210..604ff4b285963 100644
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



