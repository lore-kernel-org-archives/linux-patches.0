Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094751863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809F4C433EF;
	Wed, 28 Dec 2022 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241132;
	bh=bStODH//uoNgIQzokissAlAGcDFttmQ5PfzEbyo0UUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3qiWjViIqGH52rOgIC6TwV7DmYpHeSmq61v3J1wno5bPsfEH9zOqiI4Ermm1ffXG
	 mySh2Tyv2AWVQNhUSgZJQ05LQoidMwqziZixDy29NQ7iB4oyFBpfcjRxgJfal0kAOk
	 Py1tXTZfDD7lbvH/JLHPl4MpsR3M0NhWIeaVCB44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ladislav Michl <ladis@linux-mips.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0182/1146] MIPS: OCTEON: warn only once if deprecated link status is being used
Date: Wed, 28 Dec 2022 15:28:41 +0100
Message-Id: <20221228144335.096334451@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ladislav Michl <ladis@linux-mips.org>

[ Upstream commit 4c587a982603d7e7e751b4925809a1512099a690 ]

Avoid flooding kernel log with warnings.

Fixes: 2c0756d306c2 ("MIPS: OCTEON: warn if deprecated link status is being used")
Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c | 2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index d09d0769f549..0fd9ac76eb74 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -211,7 +211,7 @@ union cvmx_helper_link_info __cvmx_helper_board_link_get(int ipd_port)
 {
 	union cvmx_helper_link_info result;
 
-	WARN(!octeon_is_simulation(),
+	WARN_ONCE(!octeon_is_simulation(),
 	     "Using deprecated link status - please update your DT");
 
 	/* Unless we fix it later, all links are defaulted to down */
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper.c b/arch/mips/cavium-octeon/executive/cvmx-helper.c
index 6f49fd9be1f3..9abfc4bf9bd8 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper.c
@@ -1096,7 +1096,7 @@ union cvmx_helper_link_info cvmx_helper_link_get(int ipd_port)
 		if (index == 0)
 			result = __cvmx_helper_rgmii_link_get(ipd_port);
 		else {
-			WARN(1, "Using deprecated link status - please update your DT");
+			WARN_ONCE(1, "Using deprecated link status - please update your DT");
 			result.s.full_duplex = 1;
 			result.s.link_up = 1;
 			result.s.speed = 1000;
-- 
2.35.1



