Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B846B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9768BC433EF;
	Mon, 16 Jan 2023 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886204;
	bh=tuANDWk/6EVbDZ52CaUnuNxkCuVhJcsym0J2vODEC3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lopYLziG7panx/3B7pRzEdCciOOS3/vxZQaGjTjfmVmuZixc5eQV/v5Nlr4mFG1BL
	 VCQGpuGI2iScwBIuDSnpUfwvy+WtRQ0Gu68jjaFO8AeaKK5aiYfNvz0zndLs509aiq
	 9+Cxa8zBY+jLTeLP216HqK3kILFkZoD9sGN2VErU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 341/658] rtc: cmos: fix build on non-ACPI platforms
Date: Mon, 16 Jan 2023 16:47:09 +0100
Message-Id: <20230116154925.145937250@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
to be defined on non-ACPI platforms.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e5f752ce28f9..3e9168cfbe5c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1289,6 +1289,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1



