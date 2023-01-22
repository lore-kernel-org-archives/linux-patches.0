Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB102590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6420BC433D2;
	Sun, 22 Jan 2023 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400880;
	bh=AzwnMT4LleFSOrS5E2lqg2yqM7HBEVytpO5lCrrj7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhWkKOb5kHXYpN1pKonjQKuiStBfwsdjeXDleE07jTEDzp965+tfEKRZ/7k+bruOA
	 9jB8kx2cZsnnRW8bUNfJRb7uQAESe0c9jO1DOjLEKCT+3L2wjbqcLv0ASKujaRDlu9
	 vgHRyDX4K6h7XpJZUOmzplBBlLZ8CMsgl8CAnSLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/193] perf/x86/rapl: Add support for Intel Meteor Lake
Date: Sun, 22 Jan 2023 16:02:35 +0100
Message-Id: <20230122150247.570906644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit f52853a668bfeddd79f319d536a506f68cc2b478 ]

Meteor Lake RAPL support is the same as previous Sky Lake.
Add Meteor Lake model for RAPL.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230104145831.25498-1-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index ae5779ea4417..589c6885560d 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -809,6 +809,8 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&model_skl),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&model_skl),
 	{},
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_model_match);
-- 
2.35.1



