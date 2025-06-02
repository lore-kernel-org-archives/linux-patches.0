Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352B12C327B;
	Mon,  2 Jun 2025 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873062; cv=none; b=CPbD3hMiLrxv343EUcdzFaLdhRYm8dUMbY//J1XQo0YblKYI6F1ajCKmzWeDEW8L4N5h+B6LUHVSSTU2ef744dGm1ZFZBmfLmkDpoQE1MLBIbLrPYTRG6jnvmhDeiplqBccyxGqWzg+S/qaaSCq22Ai0iwNyGFFe/wrF/VJH/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873062; c=relaxed/simple;
	bh=YYUC/ILxXjc9MAzbSkwiKpP7DajMRhk1+P8SMbj5p8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOSG7kaM13zwfW7u9t3vlxCpneUOzVA8eT+M4slr4hcEHfTommkt7MyaFgJZz4uYRFzEkyE5VHZxJSzUDnnS4GUID2Mrs8ilwOo8VaMQod6MNVaF3Ou5axEFaFY0+taEvJmrENbCZ7YzWRJGwJjqUefk2wQ7RXF5nrK9l5isWDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4wG0SOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4wG0SOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB63CC4CEEB;
	Mon,  2 Jun 2025 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873062;
	bh=YYUC/ILxXjc9MAzbSkwiKpP7DajMRhk1+P8SMbj5p8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4wG0SOH1oegC/qZYhJ1fHbbnYBLA0bCT46wr0LPzoTH/5mtihQdjVRPlTRq9Ogn0
	 WGa7kzQddSlYnJTxE2BqyA2MlrMH3Uhh5wdZlw3MTBlodVDx/zmmjPAe5YgD3LJVjU
	 Q91tbu/vSJPyGmCTjMMBbXYWC24HrCeA5Vm9DO5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/444] scsi: mpi3mr: Add level check to control event logging
Date: Mon,  2 Jun 2025 15:41:30 +0200
Message-ID: <20250602134341.984904119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d148c39ebcc9..60714a6c26375 100644
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



