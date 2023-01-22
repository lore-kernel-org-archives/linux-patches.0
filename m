Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9638C2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01491C433D2;
	Sun, 22 Jan 2023 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400883;
	bh=PtlzAC8azuBHimLXPWec3uJc7Dv2kiaz9qte+QQltK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBK9kv/lHJhiQJJ4uUkKOOOdrg8nkdqwRhLcNzCofsDYsQr2OJJmUNisadusRIGVa
	 3r417fX8fm6evjdz8ytcno6T/t2JDF7uBgjSvLIKYqqf2JDR4vnwFQkiXvou8miu0P
	 E3RUCmA1RQyLyBrIvFTO1He2LFKMWdd6kh74lBRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/193] perf/x86/rapl: Add support for Intel Emerald Rapids
Date: Sun, 22 Jan 2023 16:02:36 +0100
Message-Id: <20230122150247.624365747@linuxfoundation.org>
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

[ Upstream commit 57512b57dcfaf63c52d8ad2fb35321328cde31b0 ]

Emerald Rapids RAPL support is the same as previous Sapphire Rapids.
Add Emerald Rapids model for RAPL.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230104145831.25498-2-rui.zhang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/rapl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 589c6885560d..52e6e7ed4f78 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -806,6 +806,7 @@ static const struct x86_cpu_id rapl_model_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&model_spr),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&model_spr),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&model_skl),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&model_skl),
-- 
2.35.1



