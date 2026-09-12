Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9318B37A498;
	Sat, 12 Sep 2026 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212391; cv=none; b=uO4p6izfygU5a8Qv/LgBSA3MIgmdA0G2S+ePoo98ZekZvdZH4RRn/SlUiFpIRWc/0vDrpG6/zChindk4zRQkt7kRbic1GDhBmtLdX5xTCxoax1xfNjg2nMEAm+twofxtc7jwrGu4gGXkruUqT0W1X2xLhbQHgpBc2xtyBQjq8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212391; c=relaxed/simple;
	bh=iZUrWWv7xi4wd3ZWcMNy7mpV0xtPVyFR3FbZMOibFeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNxJG250AJbWSp7jFitf7RzdVXoIisnLszXUuzuiVRngR10U57nB9G/wLRqcfmE2723uIDButTMNXNTh1jZKpef7J0d9UdF4l9S0VRi3KwjYS/B9VVwgQdSIx5jnlR5rxaM4Mq2R0qKoSc/3NIUShEuJbGQSJWwpy9xhwPSSXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHrPaANj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHrPaANj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B4F1F00898;
	Sat, 12 Sep 2026 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212387;
	bh=wTVeP1CSkd6gDsgTtiyKRT/VCqb6Tf9hL56mjlPJGSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHrPaANjGOYWcxDwerzdyijgHaaEa5f5mJ6i1nA49kZNq6BrZ8ARkQoksIge+WAIO
	 d2q/MliazMPLWka7NJrJPzQoA7fBYjec1m68yEWrYOGJUzZDyBWyneeeIUu0rLhEOD
	 HplF7kzV4cH3rXYzAqBplIzKFAe+kFDUiPbwBM7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1383/1518] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065654.833387702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



