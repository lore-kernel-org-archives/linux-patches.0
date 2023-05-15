Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F265FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB476C433D2;
	Mon, 15 May 2023 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172430;
	bh=dH3gZaElN7JUs6BTUoNgRwFU8t2AxyDypjCk+FQvRpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5zrbB3FoZWj8qie3rssQ/IjW4ugfCL1RxCrijmY0Lk6o0N9MWzsi7ypib1pfVCAG
	 TCOmRJanL93lqsan431o304CA08ueorqPZN8e9eEcCK0XHudcqJUWiUVJZBgjrCtX7
	 DXvGfI+oLstAdfgd7YQAj6wBBZhqScnUiYNh2sz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/381] scsi: megaraid: Fix mega_cmd_done() CMDID_INT_CMDS
Date: Mon, 15 May 2023 18:26:41 +0200
Message-Id: <20230515161743.614221085@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
index daffa36988aee..810d803406761 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1443,6 +1443,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		 */
 		if (cmdid == CMDID_INT_CMDS) {
 			scb = &adapter->int_scb;
+			cmd = scb->cmd;
 
 			list_del_init(&scb->list);
 			scb->state = SCB_FREE;
-- 
2.39.2



