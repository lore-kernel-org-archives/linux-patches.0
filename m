Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029342;
	b=nxgbYhvYbFvNhT4YHqBh+ZuDlNkWT48+CfdcNJ2zwzqVuBycE0rkLaFY9FKsTHhrXvHh
	 fLeOSnvpYH9QFy++uQgPh+e/YNBZdauSiHz+SvzFPqYZrzAMdsx8DVvlC7JPdS+kJWPZk
	 t9NSxNY7zjrfIMXR93kA9MW1oR8zWmsn5X5CBFePmgGkR62tzKEXNEqcp3QYFHj5sQ7Ys
	 EpZFp1rIpwkvFRiH2RffG/isMcDoh9nzbkV6rRlsT2S62279whPrP1VzvUL8I0L2Clb39
	 SE/7D7GShMtHJj3LnuV2ZlhuINc62W5iNalaEyEo+wzXnfpQlSiCU9orOT9pJqdEHyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQ41KXf0KjdPsqxagr8b+Di3cPGg7i3bAkZE7Z59Kz8=;
	b=IfExsdgusyNvaFYBl36Zug/uSyne5OjVG33xOSDDZYevNqYh6XeQHWyOxiNXkOzleQTp
	 Juh3ZuCc952kqNZKMbNBeNZk9A9MtbR/uE/iLzHhbqULa99U97QZW5MX0De4iDQGWDt0p
	 f5evYDcez8juCG8LRk+Gi4HSmjTJMWA0iUZAQBZvfGKrCTJbv8PigMO1hJR4nxJXdrxgW
	 j5TCZtw7HSTmkK/IJk3lR3yI2QWgJY/Zxq0Cj4djbxYRntP6NqEyAe5b0StGd/VpRgPQB
	 uQJgWi0kdDXTla0Wy9JEwNZcMZ2BxE5bkDQBiV/rYlT8NAdSfRrOFSnkcRQP2oCJckQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3MOL2ww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668EB606A320;
	Wed, 18 Nov 2026 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q3MOL2ww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BF71F000C4;
	Wed, 18 Nov 2026 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029342;
	bh=AQ41KXf0KjdPsqxagr8b+Di3cPGg7i3bAkZE7Z59Kz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3MOL2ww8Sqerg0wYAjQBnviZyH9L6s+RuQvvC5mQU0zLzG2JPQSIpuctrnLR1o7d
	 0XfbwsfgDrjyFm2MCFTP2dGyToLJlAPZNcnSmort2vWrLDB69rNuLbmwbBUvsETxfw
	 bHN9Mohe/+ZXDZxPjd5pD0HE/QCfDQ6bCyzE+CxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0314/1756] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118150020.819313215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 0ce10b4bf0ffe..3bb0d96f58f8a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2667,12 +2667,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



