Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016031;
	b=KJjWr5KqNvXADWwOLeX2xbwCspXUBEEF5LpY/j8KDMrgeUBnbMFzYtk85coqmfGbSi9m
	 jlL1WrHT015AQPNTDl7m5ZqNr9RvmFPWWyVDz++35yTwM2UFNwmZk+BXkIcB0WWmKO+op
	 xJ3VeGfW5IrgIo9yQ12grCZcSd3wiTZW++P6shwojXA3raPYHameERYdtL5+q96+79Rqw
	 8//Mur+erij+C35VP9d/BsySo139N7B+EL3x+gEsZ2Nmv1xzxbD8vV4jxicfV0JX5c2gA
	 j/5qEsrwg1OmIJh2CJ3BOZ+prWtPpTjGh/m4rOlReLK32pKw5Vpko40+0uLjdfsbAWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vj7fF1lqEudTL+mK9wtN/sR8sZBrlMsL5gfrMfHAx10=;
	b=Gk3q3yc66F3mTOGlycL8lIEIg3qTors5Wkpz61jaF8SHD384tIVKzJyhUm4D0PtcmiOt
	 x+E6vpW25irxQqs/RzrMJ6wpwtYxl+8lSjwpI9wy4ACOFN8w2NEVF1bEVEgm1pgyN0UI0
	 JgnCSF9Bs+EIoj8PmJ4AIkRftgSso4+CUT+HfUxWGYF1qEza0LDrJ2mWuMwHWlVqW9UQr
	 Ny2omOCO++tXfQfnOLjS6e9IWSSytlOYMmF/BMfY0S0Zg69lLdt9JgoL7/0pwMkSvB7Cw
	 OakHcAP8snPn6X0wBixzaPfRUgX1LJWIi3MXLtuXdwP1JAnUslMZPr8TVR/mlvvGpjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tADI0SZm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0E1606A332;
	Wed, 18 Nov 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tADI0SZm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6B11F000C4;
	Wed, 18 Nov 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016030;
	bh=Vj7fF1lqEudTL+mK9wtN/sR8sZBrlMsL5gfrMfHAx10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tADI0SZmHvJCW6kf5J2c5qBAL/Rrx57+oBaGhOxZRSkQRNPBLiKlhKszRMBOK3dJf
	 jB/5jgHc8KlPPT1jugVgGgB04UPMPHh3Y6kZQMuTpMNCA+VmXbdEwhf96SQUkZV6YC
	 lrGS+ltJVAGW3QP1CUHS6sg/a5NxpaKN0v1X11II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0343/2651] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:26:23 +0100
Message-ID: <20261118150300.193421504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 83ffd44ce938c..5a1cc6557e2eb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2786,12 +2786,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



