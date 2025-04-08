Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B1F277030;
	Tue,  8 Apr 2025 12:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116772; cv=none; b=qtKvEylZbFnP6xDVrYYAf1lIwo2M4NVYG23Em5T7eeUlwtEqtAV+bSjTgw7YQYm8a1pQKWPOkfpj+aGnDwvpjGKNNHltNSw/WORKdZ5MaMZSU8z8fQ84840y6AvWh5qtm2x/xzzbsCgqxVYRwyXiSEg3+ZvH7VBlB2uzr5+1XQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116772; c=relaxed/simple;
	bh=pOUjmZY8LFXZMKhhk7GOeJ58d1Jyp2VpONBZhvXWI20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kez5iN7/LPm5Dd6GxwXu5ZdBOW7XDRBLaQu9D7ukWJc5qm/njiD1rHSNkFYuOhrA5mWUBd267JhyluZ4OtbOb9ghgN9JIzIaqXKvffic5zxHbNa2Vz2XqW/WZdxBnnityZpzWUTFUB61KXDUv59KXNHyf5foOwQxdaqlzEVU0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AA0m3I8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AA0m3I8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0BEC4CEEC;
	Tue,  8 Apr 2025 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116771;
	bh=pOUjmZY8LFXZMKhhk7GOeJ58d1Jyp2VpONBZhvXWI20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA0m3I8umbjj5i1ENb/P3E0eYL9Yt+WXX0rF/SahV919mWuqY5wsc7kSiRmVpGW3l
	 ocDDgjowqyMijOvm5owvCdNOby62ZWA9fPt2J33N+lqAZjv+qY0qamWOSkWTG/eG2o
	 tbb+5aP8vAYYRrv6Ed7xFn+oDVXyr4E8KALCnOxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Meissner <meissner@suse.de>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/423] perf tools: annotate asm_pure_loop.S
Date: Tue,  8 Apr 2025 12:49:09 +0200
Message-ID: <20250408104850.921114367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Meissner <meissner@suse.de>

[ Upstream commit 9a352a90e88a041f4b26d359493e12a7f5ae1a6a ]

Annotate so it is built with non-executable stack.

Fixes: 8b97519711c3 ("perf test: Add asm pureloop test tool")
Signed-off-by: Marcus Meissner <meissner@suse.de>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20250323085410.23751-1-meissner@suse.de
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/coresight/asm_pure_loop/asm_pure_loop.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/tests/shell/coresight/asm_pure_loop/asm_pure_loop.S b/tools/perf/tests/shell/coresight/asm_pure_loop/asm_pure_loop.S
index 75cf084a927d3..5777600467723 100644
--- a/tools/perf/tests/shell/coresight/asm_pure_loop/asm_pure_loop.S
+++ b/tools/perf/tests/shell/coresight/asm_pure_loop/asm_pure_loop.S
@@ -26,3 +26,5 @@ skip:
 	mov	x0, #0
 	mov	x8, #93 // __NR_exit syscall
 	svc	#0
+
+.section .note.GNU-stack, "", @progbits
-- 
2.39.5



