Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156C352022;
	Sat, 12 Sep 2026 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231891; cv=none; b=Qs/2CJ2gfaGTDyQfAfeJZFa5HgAgX4yJMHPQiFDs3wMpZTddzoVpOAwyt98n8Oo5rMZXzO1awGOBzAYyBgd0atIqgHNt06b1RXcjrsCLpO0HAG1d6cYExvMvxF8fTrTMDf8VdLpUT3u0w+doQgs7OQZNvPM0wn+ILsQXkfwjn8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231891; c=relaxed/simple;
	bh=zk5kJHjDYzC0dIcI0u6IdeGk0TBSO53fo0XeEvjjKgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9uGDXL82S1aCee+Tyi9t4QbLxY6GL9SPl3X4WQ85nrDgX4u7wzQNzJbTzRwW1ByEfTHcKjtpiPoMLXMpLyI7X89sdtzNPbM73bupAaXIf8B3Fem8adilmjGAETyoPG0S3LQRNGbeVcL88rILdG179WLd/tdhS3pt+RZDbb4Goo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoG0qRFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoG0qRFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415231F000FF;
	Sat, 12 Sep 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231890;
	bh=Z4hrRF1vw/LgYtUaSjFGyy5jCz5w9+M225u3zAsCtyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoG0qRFSOt6rQ7SehYxLOxhXxRRuRhJbdShCk3O97cYpvaT6R7rD1ewFQjmqpzi8U
	 kV1ilOX0tKUGShBVB8C6BTOJZKDAOA0NpBN/LhKJWMyzntEDJ7h0qHouU+hiiFHqn5
	 4tcXIIgIJrSTPkR+84BShFoUi550vKTSg6zMTddc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1090/1191] scsi: qla2xxx: Fix an loop timeout test
Date: Sat, 12 Sep 2026 09:03:38 +0200
Message-ID: <20260912065612.647125618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



