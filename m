Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015981;
	b=nGzfjOPTnjtDoZ6luOOdtI+fgI3lSLDLTeVMTX4YpkNjVoTfXcBs+VECWxJ2VHhUaW34
	 dUK+iZDw4Bu7aJLAdMy85uaU45slX+EZcivWmAupln/IEV+mc3d4/Jn8jQC7i0lB7tOZ8
	 SyRKhqZ2iEc3C0dA2HvyEH5agOxspT4sCh0jXhQgiohi8+SI7j50aICryzgVhhe5VrMKT
	 Fm4RcLvnGvDAQfu5Ys22/27QEGTxtmdXrwLkR51xUCd6idOkDIB/jSaBp9I4NiYgAVek5
	 c7FHCzZKS81irvdPUCeuQz1YN4hNRvTuGiJKV5PnEqMGx3xqX63Gl+nByOLUg8bii3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l92YDFp/Bw9a4O6yT4NhwKiLTBeUtT6M9aOKQ6/2ilw=;
	b=AalbEKNIs2rA4F+Zy6bmQdwX2cxrkq97FF3wzxf4j0w3PT8JptaFH0lreVtsEs1OlcbO
	 1Nrywt+WBtgxYAWjDCscpifDn7ZMDUOZRgpN5Cf0zDrX51Ti+RiBxVUGt8Ob809ghX2+1
	 vjZiZTg+PisoPElR9O+2ZMaQLioGA9QLKPZl+e18zEsNHXrBiP+mCYmdAbAuSBwa1lBpU
	 5xcd3ds7GHjA3lCTjxZRiu3VdZnHE7NT8dwSk2v9V1NDwaSgGfHxzHggJ1Y912p/G/4xk
	 F/OKOqmHupIWK3hK6EoRaOj8jm9Vv+3Wd+iugNBjtgvf9hjQGLcvwKL7K52lMyjMKAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ABp5gy2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35DE60A261D;
	Wed, 18 Nov 2026 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ABp5gy2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC71F000C4;
	Wed, 18 Nov 2026 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015980;
	bh=l92YDFp/Bw9a4O6yT4NhwKiLTBeUtT6M9aOKQ6/2ilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABp5gy2Af/N+twDKjAJ7YYzLcQCC0b1ocC7O4RzwxGj7b/MuwsToy2au8VbIAYZCQ
	 c9szO0ovlkOsnehfQ5SxDx6VkKAOweeswVqM0ZDD9+DlIyawSJDWAzfZLz4S+8IF1y
	 bpLhqSJMfQA/7/V2m+kWWCpBKQFgcJU9L2NEnGyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0339/2651] scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 18 Nov 2026 15:26:19 +0100
Message-ID: <20261118150300.053410627@linuxfoundation.org>
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

[ Upstream commit 9e220ce4bd0468e47cc9eea07e40799ebae6eda8 ]

The number of entries in a SAS topology change event is used to walk the
entry array without being compared against the amount of event data that
was received, so the walk can run past the end of the buffer.

Work out how many entries the payload can hold and skip the event if it
claims more.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-11-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6cfec6ae82f22..6677f39b8c8f0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2852,12 +2852,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_sas_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_sas_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) {
+		ioc_err(mrioc, "SAS topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) /
+		      sizeof(struct mpi3_event_sas_topo_phy_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.53.0



