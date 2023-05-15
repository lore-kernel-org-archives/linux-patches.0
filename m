Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44125E56C
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F461C433EF;
	Mon, 15 May 2023 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169593;
	bh=fFIITTqZj4Tpks68nbymJI6pymHbMQrYOSVdLreAt7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzwoqT/xVZAp79vhA44yesDpFUAKZ+3FTaAlDObJHSEqPfjFlWLGQLblpu8C5XI8P
	 UPvCNbtfJpg7fNd1TF0Qvtc9aOySjbNXe1B6FiYmXsmw3zQCmny/6Le7wgLEBMV3mn
	 1nGSGwWS1qH40072pkAMHW4curUqm6v2zuqh2ewE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 107/246] perf vendor events s390: Remove UTF-8 characters from JSON file
Date: Mon, 15 May 2023 18:25:19 +0200
Message-Id: <20230515161725.789303142@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit eb2feb68cb7d404288493c41480843bc9f404789 ]

Commit 7f76b31130680fb3 ("perf list: Add IBM z16 event description for
s390") contains the verbal description for z16 extended counter set.

However some entries of the public description contain UTF-8 characters
which breaks the build on some distros.

Fix this and remove the UTF-8 characters.

Fixes: 7f76b31130680fb3 ("perf list: Add IBM z16 event description for s390")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/ZBwkl77/I31AQk12@osiris
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/s390/cf_z16/extended.json | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/pmu-events/arch/s390/cf_z16/extended.json b/tools/perf/pmu-events/arch/s390/cf_z16/extended.json
index c306190fc06f2..c2b10ec1c6e01 100644
--- a/tools/perf/pmu-events/arch/s390/cf_z16/extended.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z16/extended.json
@@ -95,28 +95,28 @@
 		"EventCode": "145",
 		"EventName": "DCW_REQ",
 		"BriefDescription": "Directory Write Level 1 Data Cache from Cache",
-		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestor’s Level-2 cache."
+		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestors Level-2 cache."
 	},
 	{
 		"Unit": "CPU-M-CF",
 		"EventCode": "146",
 		"EventName": "DCW_REQ_IV",
 		"BriefDescription": "Directory Write Level 1 Data Cache from Cache with Intervention",
-		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestor’s Level-2 cache with intervention."
+		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestors Level-2 cache with intervention."
 	},
 	{
 		"Unit": "CPU-M-CF",
 		"EventCode": "147",
 		"EventName": "DCW_REQ_CHIP_HIT",
 		"BriefDescription": "Directory Write Level 1 Data Cache from Cache with Chip HP Hit",
-		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestor’s Level-2 cache after using chip level horizontal persistence, Chip-HP hit."
+		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestors Level-2 cache after using chip level horizontal persistence, Chip-HP hit."
 	},
 	{
 		"Unit": "CPU-M-CF",
 		"EventCode": "148",
 		"EventName": "DCW_REQ_DRAWER_HIT",
 		"BriefDescription": "Directory Write Level 1 Data Cache from Cache with Drawer HP Hit",
-		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestor’s Level-2 cache after using drawer level horizontal persistence, Drawer-HP hit."
+		"PublicDescription": "A directory write to the Level-1 Data cache directory where the returned cache line was sourced from the requestors Level-2 cache after using drawer level horizontal persistence, Drawer-HP hit."
 	},
 	{
 		"Unit": "CPU-M-CF",
@@ -284,7 +284,7 @@
 		"EventCode": "172",
 		"EventName": "ICW_REQ_DRAWER_HIT",
 		"BriefDescription": "Directory Write Level 1 Instruction Cache from Cache with Drawer HP Hit",
-		"PublicDescription": "A directory write to the Level-1 Instruction cache directory where the returned cache line was sourced from the requestor’s Level-2 cache using drawer level horizontal persistence, Drawer-HP hit."
+		"PublicDescription": "A directory write to the Level-1 Instruction cache directory where the returned cache line was sourced from the requestors Level-2 cache using drawer level horizontal persistence, Drawer-HP hit."
 	},
 	{
 		"Unit": "CPU-M-CF",
-- 
2.39.2



