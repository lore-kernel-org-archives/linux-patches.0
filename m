Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82AA1865F
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFF9C433C9;
	Wed, 20 Sep 2023 12:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213757;
	bh=JjORIr37gZJWMkav6F6mixjKg9AKaEVNbKTK0x0cBGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo9nkpJOi81Eh4N27tR8/6wfsq/2eoC38d2EFQkCHV6QAP/n08Ym/3ucdYQd8TXfc
	 mZBWda6Km3l/eKEfTirX6R1Kt7jtQ28C/5/DQyCh7l9vggoszxr73ubr3joxppWFIu
	 /vMWguC39v+6ejmAa4bbo6xOqbwUCgsYMN/S1RAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/367] bus: ti-sysc: Configure uart quirks for k3 SoC
Date: Wed, 20 Sep 2023 13:31:45 +0200
Message-ID: <20230920112907.023427318@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e1a9838c96655..b542c2b2aef49 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1379,6 +1379,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47422e03, 0xffffffff,
 		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
+	SYSC_QUIRK("uart", 0, 0x50, 0x54, 0x58, 0x47424e03, 0xffffffff,
+		   SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_LEGACY_IDLE),
 
 	/* Quirks that need to be set based on the module address */
 	SYSC_QUIRK("mcpdm", 0x40132000, 0, 0x10, -ENODEV, 0x50000800, 0xffffffff,
-- 
2.40.1



