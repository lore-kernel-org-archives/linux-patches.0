Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17346B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9723BC433D2;
	Mon, 16 Jan 2023 16:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885617;
	bh=JcokrNxzenQXbXJr0diqgJDYzmX58m4naYo4V1Nv5rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzLf8OMn/DhzGAgW0UZOzP7PjBOKfNKbBkrYt7CIYQszJlVRVMYprc0lDGVZb50/e
	 /pqPtS/ca1GrZiyGAMGtrP0xwP2W97HUTpntBPUY9IIEaxp5qmftKKO43KQDH72fnF
	 TUT4w+Rw+P61NqzxWMsB0BNYalFbgBzAygsPWXwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ladislav Michl <ladis@linux-mips.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/658] MIPS: OCTEON: warn only once if deprecated link status is being used
Date: Mon, 16 Jan 2023 16:43:00 +0100
Message-Id: <20230116154913.757761574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 2e2d45bc850d..601afad60bfe 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -211,7 +211,7 @@ cvmx_helper_link_info_t __cvmx_helper_board_link_get(int ipd_port)
 {
 	cvmx_helper_link_info_t result;
 
-	WARN(!octeon_is_simulation(),
+	WARN_ONCE(!octeon_is_simulation(),
 	     "Using deprecated link status - please update your DT");
 
 	/* Unless we fix it later, all links are defaulted to down */
diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper.c b/arch/mips/cavium-octeon/executive/cvmx-helper.c
index de391541d6f7..89a397c73aa6 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper.c
@@ -1100,7 +1100,7 @@ cvmx_helper_link_info_t cvmx_helper_link_get(int ipd_port)
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



