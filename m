Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2228F3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23C5C433D2;
	Mon, 30 Jan 2023 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087386;
	bh=TVyG5JsgA9ts8zbDC5owS35CEr3yMGcKEAiFf8DzGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYQeCbEqecGK4d9WkFwsH04hCy6ohWFtgXpterVF9y5QVZ5pg10ZLvxN4N96G5g+J
	 wYYHkJiuxPWNGi5gAWSZnqcouW95N7+03ZKdPpm6XvtBUnfxslhO9KRxaXSz/1Zilw
	 FD5rW3ZCPC52jB/JZksaryun+myGKbizkULPV0Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Foley <pefoley2@pefoley.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/313] ata: pata_cs5535: Dont build on UML
Date: Mon, 30 Jan 2023 14:50:25 +0100
Message-Id: <20230130134345.541808394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Foley <pefoley2@pefoley.com>

[ Upstream commit 22eebaa631c40f3dac169ba781e0de471b83bf45 ]

This driver uses MSR functions that aren't implemented under UML.
Avoid building it to prevent tripping up allyesconfig.

e.g.
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x3a3): undefined reference to `__tracepoint_read_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x3d2): undefined reference to `__tracepoint_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x457): undefined reference to `__tracepoint_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x481): undefined reference to `do_trace_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x4d5): undefined reference to `do_trace_write_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x4f5): undefined reference to `do_trace_read_msr'
/usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../x86_64-pc-linux-gnu/bin/ld: pata_cs5535.c:(.text+0x51c): undefined reference to `do_trace_write_msr'

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36833a862998..d9b305a3427f 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -650,6 +650,7 @@ config PATA_CS5530
 config PATA_CS5535
 	tristate "CS5535 PATA support (Experimental)"
 	depends on PCI && (X86_32 || (X86_64 && COMPILE_TEST))
+	depends on !UML
 	help
 	  This option enables support for the NatSemi/AMD CS5535
 	  companion chip used with the Geode processor family.
-- 
2.39.0



