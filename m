Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C3D2DBF75;
	Tue, 21 Jul 2026 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660088; cv=none; b=QLg11joNbd8Rtqe+JOSK/KX8qMu7iJiPBD4SJf6oU1b8gv66ngMtoPPPbN5BC4js9sgcl8Teg6IdHSGI/HgGN1K10UR5hPl9CqUz0xVB5JlWtTUlpZs7KHv2f2CE+8qtFmcwKIm1JBxdF0Tx24ts5rFQcfLp9Sshu9V1bGUIJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660088; c=relaxed/simple;
	bh=N1UiXBJYbrKnTmX++T/gWVZUnLq/z7UKwHRLxaQoXpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQQaSsRQwg/qmCy43871AiHzd5smZUoT44y99qkGsu6+ys6feLubY2Gdf6mMxtX8KUBxkiRHI5xsh7FAjuquEataXHWwy1w9cUt/M7tVBlXIhl6Gwqt+TKckrj81gaWgC0JIbAP4YxH2z/yC7+PSZ+liFGLsKNUvIYh2G7J4sx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8fvNfTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8fvNfTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2371F000E9;
	Tue, 21 Jul 2026 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660087;
	bh=+jvsIRvqp5Da4P4U4xIjq63YpBKB7ol0aKPeHeHadBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8fvNfTE9zngkmH850PXg3X4/JYbcDpHXPVsYCAEeQBqhqdAL6P2xoa2AFdWJG+78
	 2IaZRjtHHx7tLUJH/OSibiCoAdmdcjWNx05y/r6NmaBGEhBqpWeYyq9Z8oYw2acQID
	 Lfc7oIeGsmVyh9IqI32ZFF+3SSmnaRono5KbK7TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0847/2077] coresight: etm4x: Correct TRCVMIDCCTLR1 save and restore
Date: Tue, 21 Jul 2026 17:08:40 +0200
Message-ID: <20260721152612.769865320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 0ec0a8785d21f63db520bd9d2a67c55e855d36a8 ]

It is a typo to use trcvmidcctlr0 to save and restore TRCVMIDCCTLR1.
Use trcvmidcctlr1 instead.

Fixes: f5bd523690d2 ("coresight: etm4x: Convert all register accesses")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260408-arm_cs_fix_trcvmidcctlr1_typo-v1-1-6a5695363b46@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 591dfe0bc63505..a251375db24b17 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1983,7 +1983,7 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 
 	state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		state->trcvmidcctlr0 = etm4x_read32(csa, TRCVMIDCCTLR1);
+		state->trcvmidcctlr1 = etm4x_read32(csa, TRCVMIDCCTLR1);
 
 	state->trcclaimset = etm4x_read32(csa, TRCCLAIMCLR);
 
@@ -2106,7 +2106,7 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR0);
 	if (drvdata->numvmidc > 4)
-		etm4x_relaxed_write32(csa, state->trcvmidcctlr0, TRCVMIDCCTLR1);
+		etm4x_relaxed_write32(csa, state->trcvmidcctlr1, TRCVMIDCCTLR1);
 
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-- 
2.53.0



