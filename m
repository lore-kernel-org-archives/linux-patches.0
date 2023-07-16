Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF98F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360A1C433C8;
	Sun, 16 Jul 2023 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539052;
	bh=PVdffZlP8Rr2g7Lgv3eidZxuLO/ZIdMU7IqIJfKRMQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKPrTD8Z53PucOxcZfDxOBtHxNHwj8mB5XuclIxyXxS7ZePt9tEGdEDRHv+LAztyt
	 K+JGeSxEhxy9ojdVJ2CqQrm3gZdQZa0HOszhP5RsxJcV9sKHhs2jRapDuikSYDALp7
	 9Uln6AR/ukBeuOSKrFdh8zzRWjb+WNsd4E+qwghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Heider <me@tobhe.de>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 671/800] Add MODULE_FIRMWARE() for FIRMWARE_TG357766.
Date: Sun, 16 Jul 2023 21:48:44 +0200
Message-ID: <20230716195004.708831578@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 58747292521d8..a52cf9aae4988 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -224,6 +224,7 @@ MODULE_AUTHOR("David S. Miller (davem@redhat.com) and Jeff Garzik (jgarzik@pobox
 MODULE_DESCRIPTION("Broadcom Tigon3 ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FIRMWARE_TG3);
+MODULE_FIRMWARE(FIRMWARE_TG357766);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO5);
 
-- 
2.39.2



