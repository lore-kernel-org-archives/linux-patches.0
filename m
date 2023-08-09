Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A776171CC
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E248C433C8;
	Wed,  9 Aug 2023 11:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579085;
	bh=1//W5IIneB/vINPgLYIP3uD7yur38aIpnuGU492LZRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLfhk5+Oc4MK+ZggR1RGP1ADh/TP9bY5BgnRM5cPg+EO2QdoSZh7QpccNdYFjJ2d8
	 RORTfi8lBMd2oXLVKeen7ydYHUkVX2GFLU2szDoDa35B1npLRzCPxJhDcbLYB+Jcin
	 vxJNf9vDV9OpAx7r1a45g5FI3B7hBFjxqPBSMGBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Heider <me@tobhe.de>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/204] Add MODULE_FIRMWARE() for FIRMWARE_TG357766.
Date: Wed,  9 Aug 2023 12:40:07 +0200
Message-ID: <20230809103644.950751855@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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
index e0eacfc46dd4a..bc046153edee4 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -228,6 +228,7 @@ MODULE_DESCRIPTION("Broadcom Tigon3 ethernet driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 MODULE_FIRMWARE(FIRMWARE_TG3);
+MODULE_FIRMWARE(FIRMWARE_TG357766);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO);
 MODULE_FIRMWARE(FIRMWARE_TG3TSO5);
 
-- 
2.39.2



