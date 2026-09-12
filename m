Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9499303A35;
	Sat, 12 Sep 2026 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226135; cv=none; b=M6oXfryb4Q9N044kX/OfrHWYRwODe0DFC15x8mqMHtU7rq+lyo6KhfNZRDgIvp5bqDqDr5ZvZfbzY5oUlG9JaQUJBev7GVV+9JKDG/byKTS6CZxQ55EIYHGI07ko2oCxfcYszjrwXqkY9stwlJVw+ZdGJXC64ruPM70E4fRinsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226135; c=relaxed/simple;
	bh=SVExNHeji/F5BrSUMp+Vu9GWVtiiDdgxV/FLxw1SwLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2VmnXeecfuNEOwt3dKZo1g3WopDhOb48owrtyeMGWxGzvsxjA9BBAfhvzt1c5AmchOeVNhHNgXbC1cUHjllBDNZC5GG+9g/zcOB60V4iwRU6zEBV9jI7CVm1RJLLlfpjS9O88G2LR4/c8baheECJg/Gx7iCp8f2XaZw6LAu9HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjtE591h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjtE591h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F481F000FF;
	Sat, 12 Sep 2026 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226134;
	bh=Lih+Bbh5Rz9lxB4ne4ZaOc5EJOMF3HTLRhyq5PapaRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjtE591hwHB745xvgSHoHt8YK0XxNX6dUqd953pdhCNyYi5vyfcbg2WodkkBfpaeL
	 uXYeod8kSqEL6cva6cw/NB0PbAFUiS23o3HO/CnjgyVfK5AxADPfmgyBrlnpiCegVv
	 ASA7VlD9ZGoCWPSrpK4ImkW7vjUDuniVpak0xlHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1340/1424] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 09:02:52 +0200
Message-ID: <20260912065637.266396832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



