Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023404;
	b=uNUoiA80yMxDwmfHtwMnSqKwhdbz9/nZJAje66cjqDHqDeINLwpjgcpnlu96PITgjJA3
	 s/ldRCiWv77og+uOcIGM8gBIgfhOq4TS3p1lzMGfIiDEQfJZozSI2O3j7+9cxslRonRrN
	 bIw5e76snm05wJRkyn7b8SbjxkV6P81+R+i6pSTmEwa2YwSIpynExJS4TQp/Rvfc3G1uv
	 Yag3gIJBuV52lJ7dSPDMUaFmB8OH8tE8Y2NstoQWOETTJ/GHbF8xaSWXLPDWGODUKTz6S
	 GG3fh4p9PgiRyLB6CSOxbg2jBVSLgEAPBoW55SlJn3Bw4QsS0S6eukD1bjlXLx0EjDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYrJPMAtCll07VbZfelEQoMPqy4DxjH4OWu9OXRZB30=;
	b=xXGsB6eGbJX8tTstXVlKpvZyRhw1NIPeW1NOjy5Zz4y7phxOGZ5u3WjxWA0lTVcmDP1E
	 MXy8VlLANvoZogEAadq1d8d4uJqDcjGqzj77hvQ1UufZQzEGOkXgZG7PL6bADTdzRkFjm
	 kQTrYXVblUn8nlyizf2GgNKra+CGbcB/JH786RxjYPftMmqp9JLsxET6oT4wYWPbERqX7
	 Rqg7O9piPFMDb9GxGU05OFYqrDL3siWbmLbokizikCV7DH0nV89hW+RedWx6/TTrh8ing
	 hhZtgD932Af3Rq/I/m3oJwIBftwgXoSuXIruBuGi5pAJOC8AQCj0Z31UGlACOFntLWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhq2OoRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE84F606CA4D;
	Wed, 18 Nov 2026 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhq2OoRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1816E1F000C5;
	Wed, 18 Nov 2026 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023403;
	bh=sYrJPMAtCll07VbZfelEQoMPqy4DxjH4OWu9OXRZB30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vhq2OoRsS5fzESnFYzg7yhlLRbe4rJ3TC8+tA00cxf77yMOTQ0wHHk+qkmP0dMDs3
	 Tju3FAZa7UvxrRYWsVF601Ay+94Zm0TWHcYUAcO7LWaQT5XCmFbN0QCGK8bAzPZz0R
	 D7pFhAdu01kw4zFnee4s4nAQZY0WulFp+gOHAshM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0340/2151] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118150134.455120357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 7d572b4dc4ed0494e67097d4b7368666655f5c99 ]

The number of entries in a PCIe topology change event is used to walk the
entry array without being compared against the amount of event data that
was received.

Bound the entry count to the received event data before use.

Fixes: 8e653455547a ("scsi: mpi3mr: Add support for PCIe device event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-15-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8551aa47549e3..cb105c8fdbb18 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2675,12 +2675,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_pcie_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) {
+		ioc_err(mrioc, "PCIe topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) /
+		      sizeof(struct mpi3_event_pcie_topo_port_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.53.0



