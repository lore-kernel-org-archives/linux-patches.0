Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57EA18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B880C433C8;
	Wed, 20 Sep 2023 11:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210469;
	bh=GWgoAOXy2MQwAoHiOILd/l/lxveNfZyPapMQoW+//4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yX6k3AZnJeMmIMZ6wYNIPJtfU6LXxZW/aLfMB8uEOKeeFv25z33EIX/swi9cYFxTP
	 eRocugLy3bz5GhRKwwoO2eEXl/nM6tAVlCuo+Vsc32b+9SU4ANN+/R8qc5iCzECSld
	 fKwrut1YIJdcL0xWSGf5O/gKLZSfHJtpMUML6rv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 088/211] bus: ti-sysc: Configure uart quirks for k3 SoC
Date: Wed, 20 Sep 2023 13:28:52 +0200
Message-ID: <20230920112848.543317333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 03a711d3cb83692733f865312f49e665c49de6de ]

Enable the uart quirks similar to the earlier SoCs. Let's assume we are
likely going to need a k3 specific quirk mask separate from the earlier
SoCs, so let's not start changing the revision register mask at this point.

Note that SYSC_QUIRK_LEGACY_IDLE will be needed until we can remove the
need for pm_runtime_irq_safe() from 8250_omap driver.

Reviewed-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index c95fa4335fee2..9766dbf607f97 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1525,6 +1525,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47422e03, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47424e03, 0xffffffff,
+		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 
 	/* Quirks that need to be set based on the module address */
 	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -ENODEV, 0x50000800, 0xffffffff,
-- 
2.40.1



