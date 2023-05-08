Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF41168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA2CC433D2;
	Mon,  8 May 2023 11:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544912;
	bh=Hl1CeOmqL8RN0LahdOvA7GdYIF4hpMjs8AKYFZsm7ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GzCdGqvhPKz5y/y072ZjS87hFwzT1xwd2IbO015W/AdVHGvvBDVy46jpfjkBQD8V
	 zA0C/yyqKwdEU0phxY6R3ORHUmqJLSPo6fVhFcxyV47U0W5NzDWAvnUAPcslXdEqja
	 6OOGIc8Ze1a33N2/HahNWUpCf86E3G4sFNuTD4lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 563/694] macintosh: via-pmu-led: requires ATA to be set
Date: Mon,  8 May 2023 11:46:38 +0200
Message-Id: <20230508094452.993477861@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 05dce4ba125336875cd3eed3c1503fa81cd2f691 ]

LEDS_TRIGGER_DISK depends on ATA, so selecting LEDS_TRIGGER_DISK
when ATA is not set/enabled causes a Kconfig warning:

WARNING: unmet direct dependencies detected for LEDS_TRIGGER_DISK
  Depends on [n]: NEW_LEDS [=y] && LEDS_TRIGGERS [=y] && ATA [=n]
  Selected by [y]:
  - ADB_PMU_LED_DISK [=y] && MACINTOSH_DRIVERS [=y] && ADB_PMU_LED [=y] && LEDS_CLASS [=y]

Fix this by making ADB_PMU_LED_DISK depend on ATA.

Seen on both PPC32 and PPC64.

Fixes: 0e865a80c135 ("macintosh: Remove dependency on IDE_GD_ATA if ADB_PMU_LED_DISK is selected")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230223014241.20878-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 539a2ed4e13dc..a0e717a986dcb 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -86,6 +86,7 @@ config ADB_PMU_LED
 
 config ADB_PMU_LED_DISK
 	bool "Use front LED as DISK LED by default"
+	depends on ATA
 	depends on ADB_PMU_LED
 	depends on LEDS_CLASS
 	select LEDS_TRIGGERS
-- 
2.39.2



