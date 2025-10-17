Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EE32C92F;
	Fri, 17 Oct 2025 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715147; cv=none; b=MbchUsNr1JLd42afqDsuC+LP27Ft3cO50KOl+mG3nVxZTxf2gatur0Y6sGD+KuxTt0sV7J8PyvmL9KtEcn6W3M9DhWZB2xlyi9E9pJJvAFI/UC2SqTleJkDeMAVB7ik+RwNWeyhWIDWkkZreEMoIt2xQOCIBpXKr7C76EqE4Ly0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715147; c=relaxed/simple;
	bh=zOhXh2co1OyPz0ab8Hzo/orzDS4dOMFK88kZp0vsBw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU6Rt6mmelLTtdpo+v7f78ZdajD6lDqcuvrL7LNWkyrpYueDTOUcvlZ3hfvzqva956Xpn7H3KDZhBD/b8bPc4j6QI+C7c3CuAgbTTrWwYl7UEke6Xc0Z/TzIh95bJ5Fkh5pQ4N+66wq6Ik4RnqWXbMZ82vxbvTpAThu2XYAkIo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAEwRtCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAEwRtCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A231C19421;
	Fri, 17 Oct 2025 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715147;
	bh=zOhXh2co1OyPz0ab8Hzo/orzDS4dOMFK88kZp0vsBw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAEwRtCZ875SX7ae5SIUzoieMyZpR7/dc81sgim6WGe++NHtY+lpifaOfMFFr7apz
	 tvAW4eOj+ZQ7yhvHNFevFoBfPS606oltgROIbBC8Qu4PEWciC+uMwky6MshJq1Lm0B
	 CgrPj7w9Kx2TQdfXjhbHQJqv0Slf9CPH7P9oFZhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Wismer <thomas.wismer@scs.ch>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/371] net: pse-pd: tps23881: Fix current measurement scaling
Date: Fri, 17 Oct 2025 16:51:29 +0200
Message-ID: <20251017145206.061457266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Wismer <thomas.wismer@scs.ch>

[ Upstream commit 2c95a756e0cfc19af6d0b32b0c6cf3bada334998 ]

The TPS23881 improves on the TPS23880 with current sense resistors reduced
from 255 mOhm to 200 mOhm. This has a direct impact on the scaling of the
current measurement. However, the latest TPS23881 data sheet from May 2023
still shows the scaling of the TPS23880 model.

Fixes: 7f076ce3f1733 ("net: pse-pd: tps23881: Add support for power limit and measurement features")
Signed-off-by: Thomas Wismer <thomas.wismer@scs.ch>
Acked-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20251006204029.7169-2-thomas@wismer.xyz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/tps23881.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pse-pd/tps23881.c b/drivers/net/pse-pd/tps23881.c
index 63f8f43062bce..b724b222ab44c 100644
--- a/drivers/net/pse-pd/tps23881.c
+++ b/drivers/net/pse-pd/tps23881.c
@@ -62,7 +62,7 @@
 #define TPS23881_REG_SRAM_DATA	0x61
 
 #define TPS23881_UV_STEP	3662
-#define TPS23881_NA_STEP	70190
+#define TPS23881_NA_STEP	89500
 #define TPS23881_MW_STEP	500
 #define TPS23881_MIN_PI_PW_LIMIT_MW	2000
 
-- 
2.51.0



