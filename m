Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF2364038;
	Sat, 12 Sep 2026 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204892; cv=none; b=oWB7FIOJhTctEYwPKKg1X3k/ZJX1x30pZV/o2x60Ynglptx/TlRiH7lDrwlWVC3BZp39cq/auL1e6HyAb6ObWbph0KoqnY7vXydtd6IEmZ+63tR3/qLHJuau8r84ElNehXC7Gjmn0dnoHUT+DcyFe76nmfj9hzxk8O0f+6jh5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204892; c=relaxed/simple;
	bh=JbogbmxFnCJ6sbUS8tLy3Co2XTk5dgzwqPhq5/2JTBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICDhgkUjJlOg3JW71YBXGGruqw/zJ2KQIh9wphQdhejm4jP00x50AZol8p4rizN13V7bQCzyrWfNfrBAXvowey6lyWt8yAo1yqc8WIWVkW168xwxHYuGcClHl/MQBxMrBAO0pIKLR9p2e88PTalBI51KDtzBRAh2Y5uXo74ZWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geTCASlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geTCASlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A641F00899;
	Sat, 12 Sep 2026 09:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204890;
	bh=2WROlxcIuYn+vmCMEfdMQtE6tRIwN9qrn9td2QqAjQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geTCASlzj+zCObkqiQsQ6BSWT6jDYxboTE9ayIH2aCedrvtXYg9/m1nSflx6UOd4+
	 xaVmSd68PoUUgU66YbHd6QcB1u5lp8ec/R7JG+FONgafUPp55QgTgMLAdXN4I0vSqM
	 4pe1NU8admZa4gFfgdyobh8QnLQbRnzgTujIhr5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1707/1815] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 08:57:37 +0200
Message-ID: <20260912065729.051983373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 41ff6fbdb9333..04d7ab6ad037a 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3507,7 +3507,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_host *vha)
 		msleep(QLA8044_FLASH_STATUS_REG_POLL_DELAY);
 	}
 
-	if (!retries)
+	if (retries == -1)
 		ret_val = QLA_FUNCTION_FAILED;
 
 	return ret_val;
-- 
2.53.0



