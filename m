Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EE026A0B0;
	Tue,  8 Apr 2025 12:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114880; cv=none; b=AiDGEptI4FyxFM28df9mFIq45ABh/NYfd0iwe+0SGAnzqRRaqFBSyW5qRZRPZcDF/1S9bUx913QqMB2VpI5DK2XwI5VC5BU9RWPZG4PJZwgMYF/omDMtPXBpfHZyzaUXZVDcOpydBzP1CEbRuerhg2yhbNvL/L+lCa/byBOjtns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114880; c=relaxed/simple;
	bh=ZRGX5NeWVVqIM9q6/IQfKKe4BiwtB9kZoCv84JfM7t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5rZtPaA/xuj2x/Zi2aWIIUuHl7TaFFsXdgEtD+ZbUbubSwCuG5lWOqlSZyjr/2YW2BFZr34S0geweLBnE0Hr3S+UTewqGWxdGXOIIrZGTFZuFnq4fU7OFdS8awUJgECa7Lpsq7D/O8CfkD0BC7oDEI5QumqiAv9n2TZtcR7dVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcesL2jF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcesL2jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F60C4CEE5;
	Tue,  8 Apr 2025 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114880;
	bh=ZRGX5NeWVVqIM9q6/IQfKKe4BiwtB9kZoCv84JfM7t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcesL2jF4BdyBb/8XYgxj2Lq5StLzAq9qCUnQo3I04x+cmS3OvTJ4oyeOmBjDL0kC
	 6MCiom9CUdmDlUzz8qXg9RSeEbyTqY0LiC3/Y8dDGOM4JIrofafibZCbicXek1W5gN
	 gjzNVTw7cSnu/sOsvQ6NZFhc8r1mwk4SA8F4SsTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Meissner <meissner@suse.de>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 270/499] perf tools: annotate asm_pure_loop.S
Date: Tue,  8 Apr 2025 12:48:02 +0200
Message-ID: <20250408104857.950454561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



