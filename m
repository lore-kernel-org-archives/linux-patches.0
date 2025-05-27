Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7395271464;
	Tue, 27 May 2025 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366308; cv=none; b=bD8sE/XDx0bns3unHYU2MI5m3ap2GjSmljfEro+fHBxDqPM+tEWv/cm/4upOvrCo8Xt3LGuVxJ1YMr9G15sv9GO/lfiCVEXU8D6keUnqKs7R63v1Vm44ORR3+QkKAzT4ox9vksbt5OW3zJul+ADrrwmnobuCeJP5eG13RmwuvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366308; c=relaxed/simple;
	bh=4WhmMzODGqZEfslI67E+ZpEtxwsk1j1WYHC2tAS85Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reXhXGEBl/r3Zs9NZyAHmpVO6BmWrRFRhjnRTWU6yZIxMoUoxvh2gbLPD6wE2zRWBRBJuaoQDgkvXrt6V3csouKdBMPGO8l2GD5QaYkoDCdszIXOcRRrXaKCdDOOgGzOLTm+aXiCJavvZfPJOaJwGAihTV6Fq00LPzyDURu8Eo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVxKw5ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVxKw5ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23863C4CEE9;
	Tue, 27 May 2025 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366308;
	bh=4WhmMzODGqZEfslI67E+ZpEtxwsk1j1WYHC2tAS85Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVxKw5ihDaoj/HMfCsin4sJLyc5If3HMc3W33n6WXeMiU3xQYecIjHzZRVSwcLavF
	 Mb2SpLoBdoIcDGE/tp0Y+4xNyHjOGTzV3SC0HCu5DapHqq7t97rC+ohQ49LR6RSDhh
	 sZFoHQ7qY2DZ7YjxfIu1NK7qHyXf+MpgoLVOMAxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/783] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 27 May 2025 18:17:04 +0200
Message-ID: <20250527162514.221764009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index c0a372868e1d7..f6d3db3fd0d8e 100644
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



