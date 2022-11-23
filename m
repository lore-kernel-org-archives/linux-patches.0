Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6F1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944B9C43470;
	Wed, 23 Nov 2022 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194838;
	bh=AgeBNrJ+55Qc7UTqcitGrc64dU8FWmDYQycQ1ieO4YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npCSZKsDLo20zY5mhsYX7UOrARLCMOAq6lfD29zheQBWRx16El99NN25RUihYwPT1
	 TGLYZfACk2ikeKq4kKDowsRSogZoBiFcB17nAe33OpJLNx9okT0f9Kn8a+rJW/KyU5
	 NGv9Vgj9qSWUdjNPtOjeSV0Vz+zeLO3WeeUF3/8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/156] rtc: cmos: fix build on non-ACPI platforms
Date: Wed, 23 Nov 2022 09:50:32 +0100
Message-Id: <20221123084600.718736559@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index c0dc03ffa817..be92919af2f3 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1290,6 +1290,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 {
 }
 
+static void rtc_wake_setup(struct device *dev)
+{
+}
 #endif
 
 #ifdef	CONFIG_PNP
-- 
2.35.1



