Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057337;
	b=5GXs8ajvicD5iPJe9es912j47pKUAxufFCBmyDArwL15XKndqqG6ho6XG8pSP20XHv70
	 44vas/Ckz6y6sEZIZ2cgazifZRo5bBk6P5TdmpqjuR9u8f2H0wNwLrTFPllcnKCBIhpNf
	 k1NHTfRiss9G3/u0Z1Bu3NP/XNEkmoWrE99PC8OfKWt1KHYpnAzhg0dBbC4MPgsG0wL3T
	 broptTy3Gt7M5lPxPg1cSSV6uLUSgoSLR7zvNEp2N0TiBziPT2sSGBjULV7rDbbYh6IqB
	 TferfhQB+2AQswn6gYTLE/p8Utl9Kl87FgGF8IiieCZ+qQn10Ua4JpGyOo5jf0e/bzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wdz6Vz2N10HmTMLUcceYiiw0wSGDaZfpUVhJ0c6IZGA=;
	b=YywlyfeTuIzIFjhZuXwA121FNHRSh2XkvIravcOqWCttneHI4kPeB+EuP5JuO5dmLzw6
	 3pTzpS+bJ+9wmR0tG8t2NeQWvzMZmY4Qt5+rt/ljH6KTL8T2m321D93bBz0wENL1uSirs
	 40pwfk0hLCFfPKS2pKiWjpWNHa5JZNbodngvBGdf4Sg+FosAghaViGtNXbO4t69bpuloq
	 Oj0BIVMIvo0Ef4QOYwAWY1ABaTaKOdshCZTu1Ll2O29GR2S0iEJcS7DHpjzj1bp1rK6Q9
	 M5o7J91380v0zSFQeJyP18UgfRjRSAEj/kiexKBsX5MrnyPI43NSzaz0vFGjXXYHFsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RF/Jo5Om";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C9E60A262A;
	Thu, 19 Nov 2026 03:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RF/Jo5Om
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018311F000C4;
	Thu, 19 Nov 2026 03:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057337;
	bh=Wdz6Vz2N10HmTMLUcceYiiw0wSGDaZfpUVhJ0c6IZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RF/Jo5OmHStAWGFvKKECoDl/xc6REIHFKQV/BTMi0zZc5NxmmIf86nrhgsWBOt8tX
	 OdvHIuqjF5iWZBc1MrNVPiqLtHEyC56z2zik8B24e7yhCvxdyxGjG7ahRf0s2VIm+l
	 RnTYsejzHcEOojvG72PtI4k1HRva42OZHFsHS5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0054/1848] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Wed, 18 Nov 2026 15:34:52 +0100
Message-ID: <20261118145913.386023406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 67e87e9f306f1..ddf73f675f399 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -172,13 +172,16 @@ static int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	report = nvme_zns_alloc_report_buffer(ns, nr_zones, &buflen);
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -198,7 +201,8 @@ static int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0



