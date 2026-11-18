Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043125;
	b=Ub01O3/GSBRdqIPK5SP090N++3w/IRyy2hCpytuzvainXfJczaDdlEbDKHxvn5iAxxCe
	 G6QTvx16RhQPopuCmkAXUaVXKQQ/GBUnA+GwalPKOjmohEoxoPpjrf876303e30PtM4Dy
	 D69iflfJaCcUw0KS/0kCSTfubzUogLAH9pwernlScnOg1TShDzv+QKod0WTexq3IxamcO
	 TUXVu7eYg8iy+wKCKRcKdtEh8kjhb0qOnYnkqxML7MnLz5OBi6PrAxCryRt6VmkULNle+
	 7Yt6mgWpGGA4C8DQL+CLxnrmh0WChzraWORZJqhIV/XZW1FYv0LZPYhClqodhmoY8Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1NeLMNHyPTZUn1WMv8NnWU+Lxav7y51WgsOfu7hSiQ=;
	b=fhaLQNsD5KzqTvmFp5uRzTKKQYVLNeFKa5vDwPCzl/E+2XHKVMgha3U3a23T5B+i8B/3
	 xEBv5JkI7ycMMx7PglBFHTcu/VKjKB47/VOF8RF6DY3nIimNlo5Ip2oIcSXold7FgCCuh
	 gGrkmhufOITbhxn2o0Cvl7t2/JoJuyxN6y5s6Tj3x1AtRYm4eRy++MM2TJcHM0xRWgFVV
	 5YydpqKx29ZlKNnedUmJSm4Z+p/fW/NjS4gVuD0Do1V0cKVNrfKkQDKumv+c/CxquFvNF
	 5uw4JdZOuXrD4qeRVnsGxDhgapIGWn7eJKRLwpFF5liPxfQDTlGNfRDbA7sZvajBXCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRHWg14c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7F4606A31C;
	Wed, 18 Nov 2026 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRHWg14c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859F01F000C4;
	Wed, 18 Nov 2026 23:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043125;
	bh=u1NeLMNHyPTZUn1WMv8NnWU+Lxav7y51WgsOfu7hSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRHWg14cqykSRzV+8uaFimXVoB5gWe0qh9HIN/JcFA1mFaOeAQY4b88Eg62iWzjX3
	 BwugKQNkx731JRBnbgSfDvHN1M6UvSepgLJEoub4SgACGIy+E8+B1AAAtOqkep/YXx
	 uUIcOJLeAz6p7QqvlwZfmYX15K2KajWuto5YDYeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0062/2857] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Wed, 18 Nov 2026 15:18:16 +0100
Message-ID: <20261118150203.537184138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 12316ab51bda6..18cb12931af71 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -180,7 +180,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
@@ -190,6 +190,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -209,7 +212,8 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0



