Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC7BAD5A;
	Tue, 27 May 2025 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364346; cv=none; b=M4Hatqys02bhkdXXKjD4Iz+w/8akzTqpImXT8sD6+3iqzsnQD2WTFxEV9r8dHZF5WWt1R8wO5y2i/XOJ12RKXNRUEIs8eWttyAablszfZReeICnypAeRrxMVkiMmCX0y5h07zY8hOH5vNLCgBSDxPvHj7atH/rTBI/dtqxzNMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364346; c=relaxed/simple;
	bh=kWZkCs/eLO/dcgHAmLtYWyuYxx8hUHNCkytbfIC2bhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2nd5WWaJ1A0yVqON7EX6/Nduw3H3MQfnekWcGcKkPmlggX7HbNylJCrmafAWMz/p6yETyGwvRnR2D4P/U0IPZGhk3a+chud9Opg8fLg2Z8QdlccyhpEud/k/zMYFgjzYWd+JHF+TeU4V+2CbaRoTGbK0qVAbAQMRU9AR/8fOFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMC48+Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMC48+Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA4EC4CEE9;
	Tue, 27 May 2025 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364345;
	bh=kWZkCs/eLO/dcgHAmLtYWyuYxx8hUHNCkytbfIC2bhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMC48+OcinIV8vcL0bNK12m93x03NofRuMXdnrwaoiDN+ke97uqqp2gmfeanMREf3
	 sBOGt+mQTLqxo2Xnm8TywRDkPryiEAUhN5212KCgLLkpiFzYcKni7ZxdcB9pwQTqpA
	 4kPIZPr+R7L2KDupdxQsoxTe5Sk+xwFKToR9Mf/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/626] scsi: mpi3mr: Add level check to control event logging
Date: Tue, 27 May 2025 18:18:40 +0200
Message-ID: <20250527162446.171572726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



