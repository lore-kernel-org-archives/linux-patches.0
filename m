Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C51773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13427C433C8;
	Wed,  9 Aug 2023 11:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579856;
	bh=XKMvlpQiebUz0raSIgkFdwC0+CISbZxE/4eU6syaOuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU2/UwtydjslpoVXhsh1tQhVH8XKjoxz4Q595THhPyHJfBsJXEMEaV1StWfIMmHGO
	 d5749Fg3OOwc/1VkzY3fcr4QaurkAWVD+9uqMdhBKs5AlXzzV168/r1hMG0QHN6JwK
	 M3Oz+jXx2795Zw1E3TWWGG8Bl+MKrIw8s5+NZAU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Heider <me@tobhe.de>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/323] Add MODULE_FIRMWARE() for FIRMWARE_TG357766.
Date: Wed,  9 Aug 2023 12:38:59 +0200
Message-ID: <20230809103702.686779861@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Heider <me@tobhe.de>

[ Upstream commit 046f753da6143ee16452966915087ec8b0de3c70 ]

Fixes a bug where on the M1 mac mini initramfs-tools fails to
include the necessary firmware into the initrd.

Fixes: c4dab50697ff ("tg3: Download 57766 EEE service patch firmware")
Signed-off-by: Tobias Heider <me@tobhe.de>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/ZJt7LKzjdz8+dClx@tobhe.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 2cf144bbef3ee..43b83a3a28049 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -235,6 +235,7 @@ MODULE_DESCRIPTION("Broadcom Tigon3 ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 MODULE_FIRMWARE(FIRMWARE_TG3);
+MODULE_FIRMWARE(FIRMWARE_TG357766);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO5);
 
-- 
2.39.2



