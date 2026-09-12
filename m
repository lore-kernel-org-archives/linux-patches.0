Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C925A3B7B6B;
	Sat, 12 Sep 2026 20:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243545; cv=none; b=jDEqNLFvN59xVHwuS5ffJ4fO/TQEDinmZO5sDU0uJJYirUUGHD7rp1Z/ntfexIs4J08PzZN9wreLO0UNnoqaDg01J1q1QoANkE8AsMeyvZdebqtxZndZ6VmClxTkyz9gjwFCJDOpwF4hNyaQ76KcCtxKNEQlhke8USFpZjapc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243545; c=relaxed/simple;
	bh=z99rUAjZM/4XaMrUpCxs/s1k9OWtxNrgRERLt/SOXJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omYMcz7yT609EvNQHIhnSjczv89VRBcqrXoQJtybdf8JgSlFh/lzhNv4CfYj+JwriJul/cxl0UjYjZ2CpR0A45TGL6PQNZlJSuxjN51m+cmsUfHIOqsbdrEb7EZbjvVQ0PU+Tni0P72W9t8Oqm4YB0RpNJNM4vq7+oNRG3S/H5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olJilfKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olJilfKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03A11F00893;
	Sat, 12 Sep 2026 20:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243538;
	bh=KimV+SWYWNkl+0BB7SbkEwiKbg3tcFgFRTA81NsuHf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olJilfKyeh4LQxDgZxibMMkpphBeEdSFJanjXWlnG04MmU0y4PqUF4xH9WiDLK2q5
	 z3zSnPrfyOniR4vf+hzJHRwduIYPGcPjFac52xg4BCGZ7FupDmuaYGFURqeDkQoeKV
	 D4lV8qNjN5Oq8MACfaKFwPGSUCpObdPJoCpFGPok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 747/798] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 09:06:15 +0200
Message-ID: <20260912065534.193711231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 01ccd45267074..c84d2ba38cef9 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3518,7 +3518,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_host *vha)
 		msleep(QLA8044_FLASH_STATUS_REG_POLL_DELAY);
 	}
 
-	if (!retries)
+	if (retries == -1)
 		ret_val = QLA_FUNCTION_FAILED;
 
 	return ret_val;
-- 
2.53.0



