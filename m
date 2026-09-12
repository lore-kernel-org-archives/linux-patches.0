Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E894138837C;
	Sat, 12 Sep 2026 19:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240479; cv=none; b=D3St2kTYMRFIqujtHLEe3uhDairLsrI7NmYUw/eqm1ElmFFxN/Ofje+io2GTQuUDrUZK+XFI4Bv/VjvC5IQYWDDfJi27TPTtynhPv54ayecRNIJgy/LMFZ1xqkykus4yY6HqE39Yu0MgEPe9EYl+mULXFCWDW/dE2CKEULz+xoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240479; c=relaxed/simple;
	bh=wMNKyPAq5GA2kpyhfaCcrPd7BnRB/4bP1b5ULEefu00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv8CNf5PdKJE4sD6gviMjK+07AsUmyVffzOgovxjmIYXFsP6+woeqeQK+D11Pd2yEkYUpL6uX7pv6n7vAg+a3GREDIb6RipsL57SRRYFJ9Mp1LfyaCUjVWWy2j4Er7jaoKPvdP+y0kzp+2MqFq5yHPxX8+w3frRxUhBUOFlnRRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cb1V7PST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cb1V7PST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5571F000FF;
	Sat, 12 Sep 2026 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240478;
	bh=Yn+DC7zIBq9+Ibk9VzqLLqw9TGw/mbVE3yc6pPRAx7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cb1V7PSTdyBybAubwpIZftBaQdjZ2I6x9hwtq8S0rflBX1EKmVZqZriQ/ZMmNN5bs
	 WhVao/id+z1GULbtOwJfGYBLW78QTcWhUwTZpgfQzccV/aZd75bK9X9tyVscQbCSxC
	 ICt6qYSNIRhxNF+1+4wmu9czgNVHTJVAnY0mpPjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 877/935] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 09:05:07 +0200
Message-ID: <20260912065546.931575369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 11e48f5201fd86ffa038809dd9c41144d43ee2e4 ]

This loop timeout with "retries" set to -1, not 0.  Fix the test for
failure.

Fixes: 7ec0effd30bb ("[SCSI] qla2xxx: Add support for ISP8044.")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/an1twcxTYSFkkUTA@stanley.mountain
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 5ceecc9642fce..7f4861d72d36c 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3510,7 +3510,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_host *vha)
 		msleep(QLA8044_FLASH_STATUS_REG_POLL_DELAY);
 	}
 
-	if (!retries)
+	if (retries == -1)
 		ret_val = QLA_FUNCTION_FAILED;
 
 	return ret_val;
-- 
2.53.0



