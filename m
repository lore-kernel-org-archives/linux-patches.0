Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44923168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0A3C433EF;
	Mon,  8 May 2023 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544310;
	bh=o1QqK/1hVeCP5ino5z2TFM2sRjZ97XnycTGzsTaU678=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+yz0J4XwRa+lra9DUNxiUiX1/eDAukOgkz0J76B/OmGZzm76WBJPxTuY7LvWl+sF
	 hSFJ2px9k/7JDPvuNpegJzTbbj3RpAa6CDyaPmRwUxgyzQr7t88nkDSmcwThSVgX3w
	 Ah38CrnbqR0KJB/UJ7sAsch/SdchnXCszv3gk4J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 368/694] scsi: megaraid: Fix mega_cmd_done() CMDID_INT_CMDS
Date: Mon,  8 May 2023 11:43:23 +0200
Message-Id: <20230508094444.712200690@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 75cb113cd43f06aaf4f1bda0069cfd5b98e909eb ]

When cmdid == CMDID_INT_CMDS, the 'cmds' pointer is NULL but is
dereferenced below.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0f2bb84d2a68 ("[SCSI] megaraid: simplify internal command handling")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Link: https://lore.kernel.org/r/20230317175109.18585-1-listdansp@mail.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bf491af9f0d65..16e2cf848c6ef 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1441,6 +1441,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		 */
 		if (cmdid == CMDID_INT_CMDS) {
 			scb = &adapter->int_scb;
+			cmd = scb->cmd;
 
 			list_del_init(&scb->list);
 			scb->state = SCB_FREE;
-- 
2.39.2



