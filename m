Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064FCFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29692C433EF;
	Mon, 15 May 2023 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169312;
	bh=dHW02TEX4HRwZjYJpY7MjbGKJ2AYw+w85shl+OROI10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9oND0Bm9h1paWTlTsTww/0ayKtqX5AqemAcG+O6Q6e2cr3nUje/nOJa0dhhcwGzc
	 3c5Rpc+qnLnAuy1EodQQW7CcziAapD0wQVgFX6eQxHQU+bt1KK9FFVxxmY+5udq479
	 r2KbWtJ9NDVj1m9svfZWuo5EUQfiPTyvkPDGu/jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cruise Hung <Cruise.Hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 019/246] drm/amd/display: Reset OUTBOX0 r/w pointer on DMUB reset
Date: Mon, 15 May 2023 18:23:51 +0200
Message-Id: <20230515161723.186562585@linuxfoundation.org>
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

From: Cruise Hung <Cruise.Hung@amd.com>

[ Upstream commit 425afa0ac99a05b39e6cd00704fa0e3e925cee2b ]

[Why & How]
We missed resetting OUTBOX0 mailbox r/w pointer on DMUB reset.
Fix it.

Fixes: 6ecf9773a503 ("drm/amd/display: Fix DMUB outbox trace in S4 (#4465)")
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
index a76da0131addd..b0adbf783aae9 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
@@ -130,6 +130,8 @@ void dmub_dcn32_reset(struct dmub_srv *dmub)
 	REG_WRITE(DMCUB_INBOX1_WPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_RPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_WPTR, 0);
+	REG_WRITE(DMCUB_OUTBOX0_RPTR, 0);
+	REG_WRITE(DMCUB_OUTBOX0_WPTR, 0);
 	REG_WRITE(DMCUB_SCRATCH0, 0);
 }
 
-- 
2.39.2



