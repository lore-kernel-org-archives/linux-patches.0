Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029322;
	b=bv7VGUeNB+B29H2hwEAKreVS3O29FyVSwmk+qUsXipeuAOM7u/pIp4Cjv1hYXTOuf4xW
	 T2y/T32j4n4126VaQUdgQohUnHNI3nBNbTiqatCsm161KuVgbUGLpI33AlKxguWVyI0fp
	 zActgCteU5rJ2+M7DQm9/w6A5ExDxvDeN+CMrlbxYJ7Qlh0hXufTSjn+VvM+2MXuhVDDg
	 p/KEdpWeQG0NNaRFlb4f+FCs4wiQlgkxAM05DEtk3oI0/9avGHjrBAd4OzcthZxtK4ltW
	 fZQSgU8HFJrr4GE3lLC6LPv+3pG48RCxMFWsOgn6ag/RLVMSvykJylmTGun+EMPq+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbrIdX+jUqHexXfVEoZDCJZjmkoNvQtIqvoO3bBcFaE=;
	b=S1Wd6lL/OOqaD+XTr5X7VgmiAvGhCgcy1dKVe/pSnQuAnnkjY3oVqgJj1b5KtuboeH9Z
	 V/3PkxL7fWbeadrtv4vNyCR5YPTKHl52RpRwYtfm14oI90cpHPXPz2ugLbGe7in4ndpUc
	 NqFveoktTEpTunE1q6ZNiNaxenLiyMkm4WM3CNpb06uAiXlUjK+DjTGG8fxaVqUbbAiSY
	 dDzZcbGLKEZNr8Hxts40KrkQGS2txvfhKxeCcB1eoyzv/TMufZqyuqlRspVU8y3GrSkXa
	 SDGKuxZMvG0+IVKsI6eHcfnwesoRqq5+SbVFQ/stl/qVmai6jfY+RhPrMrYFPWM8eyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRPiUejA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5398B606A333;
	Wed, 18 Nov 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRPiUejA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C271F000C5;
	Wed, 18 Nov 2026 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029322;
	bh=PbrIdX+jUqHexXfVEoZDCJZjmkoNvQtIqvoO3bBcFaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRPiUejA/Zs2lyQ2Mo8qWQSXTSID1+dItr6MHYqd3ouowmuLPVwxC1i3U6XXBkCA9
	 vb+6iz/SmHBF5BJrV0sYZDYMAT2JQcUkpnrQSWuq8UueofLLOuU6s3LLoL15IeiAxG
	 6146dDN4//y2Wvg8/XGsS20UExq0i237XvLkA94Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0307/1756] scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 18 Nov 2026 15:40:34 +0100
Message-ID: <20261118150020.565846869@linuxfoundation.org>
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
index b92026b350819..e1cb435a59eed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2713,12 +2713,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



