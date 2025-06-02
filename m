Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960B1C84DC;
	Mon,  2 Jun 2025 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876691; cv=none; b=mzrNKxSGw7VghjHoUdOWagrq0vNKKVSpFTw0YZPyePpQopZJ5J60dTxXcBEJyull0aDcEO3FdUV2gUdTwQWcPa8bt1AW7vnO1wEljz6RtLgHPVx1kblxQ53sHU7jXlshMau3TpmgV5y/k1rgQAzlu+S1lt6RxbgT3TtcDpe3GvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876691; c=relaxed/simple;
	bh=vlcMqxTbDheqApktbaRMLPFkpsByGYtiRDo8DF6c0gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5hljKVznkD2o0rJU1gf4yhTjNi0LndboHgIuNUVvepKssA4R1aheIgLXbd6rPHKcp3O2Qe/es0umktu0rb8ZxwRrUGxfxDsnUwtjejiEj5j14OvomURPAP8kLmyCd/8TH9NuCOWjzn0mzXnkL0ut0ILsBxEblSaDJpT2wNKFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfbP8Qb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfbP8Qb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EDAC4CEEB;
	Mon,  2 Jun 2025 15:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876691;
	bh=vlcMqxTbDheqApktbaRMLPFkpsByGYtiRDo8DF6c0gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfbP8Qb2qsJv+sSoS9iOr2u4i+MGqau50Q9h+8SL+ktr5VpA/m9yDsi9cnd48C/5G
	 SCjGDbs+F4SDt1vsDr61yKcslCKaZaTXvoutyn5xUMHauthoDCyTiS9oMCbk/wfYyc
	 WoN84FcwXJPO+oiScAnmngXjekdoTpKhoiOnSF9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/325] scsi: mpi3mr: Add level check to control event logging
Date: Mon,  2 Jun 2025 15:44:49 +0200
Message-ID: <20250602134320.279347458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit b0b7ee3b574a72283399b9232f6190be07f220c0 ]

Ensure event logs are only generated when the debug logging level
MPI3_DEBUG_EVENT is enabled. This prevents unnecessary logging.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250415101546.204018-1-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 41636c4c43af0..015a875a46a19 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -174,6 +174,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
 	char *desc = NULL;
 	u16 event;
 
+	if (!(mrioc->logging_level & MPI3_DEBUG_EVENT))
+		return;
+
 	event = event_reply->event;
 
 	switch (event) {
-- 
2.39.5



