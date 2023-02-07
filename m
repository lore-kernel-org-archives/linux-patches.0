Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69753212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF33C433D2;
	Tue,  7 Feb 2023 13:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774977;
	bh=wDND9gLyrbUiDn+N+fgrzTLJVry4TzV6UJ++R+frSn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZimTKGcsCYGR4VSEtgd7V5vlS61WIulGZ/uskLED+2aKbPAMQ+aM59roFA2Pdi3t
	 TfhAIZ2H+9TD66n4mTTs1PkYEZU0XfkHI3I73vn9QUK9yk26LDbNKWSbk8cntJO3PD
	 KWKPg/08ya48An+S9z7PoEnNq5FJY9SjpOGeIpJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/208] perf/x86/intel: Add Emerald Rapids
Date: Tue,  7 Feb 2023 13:55:51 +0100
Message-Id: <20230207125638.766973642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6795e558e9cc6123c24e2100a2ebe88e58a792bc ]

>From core PMU's perspective, Emerald Rapids is the same as the Sapphire
Rapids. The only difference is the event list, which will be
supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1b92bf05fd65..5a1d0ea402e4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6342,6 +6342,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 		pmem = true;
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, spr_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-- 
2.39.0



