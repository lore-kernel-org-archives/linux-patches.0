Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7783E269AE4;
	Tue,  8 Apr 2025 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113388; cv=none; b=gb1eWOp3Z3sWBIJU+CWZTYo46Si4FRzucFGuj+bRXNAMosoP2EvMeI4OtuHKfi9aGja+S7a8AswrKpGN47Bv3pu+gOkoH6PHUjDSuiledpH4tNgq+sXA6OJz/qqwkt//ZkN/YHE5j0yVA6+YE1lq3VPqGzeshtASnXPwqjmlJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113388; c=relaxed/simple;
	bh=k5zwlHN9CFuodxTvWW6KYv0gDVk74sxKM9Ae+o7ONfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0zjAgYw663BtE3fOjBGXngpTc1i6Eg3/cj0jLi7mKr5B2/r5yaiTzCkO2S7jTvrlCUfsY+RP7BTIPbRH6cixZMOF9Hwr2Wv9zSxsrVHEc21AYBFc4izfbUxEt1DaZAYwHTM16rTDvVv4VgC+5+oqxllzcclUU4YNCNeC7UNF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIT2R6qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIT2R6qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D42C4CEE5;
	Tue,  8 Apr 2025 11:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113388;
	bh=k5zwlHN9CFuodxTvWW6KYv0gDVk74sxKM9Ae+o7ONfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIT2R6qZMEjhTOiik14mzeiaPELyt2Z5RqSXStbw6Trv3GI8I/0n0ReOgrYiw2uty
	 fGzRcxYeXJOC1XXefsrLD6qM7H4bwJ4AjT8F+3dDb4/GoVSIyPqWOkDB49QpgHfj4c
	 TBTqhPYZbAkFfeoD0FdwBsDVVze2kE9o6SwmELLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Meissner <meissner@suse.de>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/268] perf tools: annotate asm_pure_loop.S
Date: Tue,  8 Apr 2025 12:49:11 +0200
Message-ID: <20250408104832.298470668@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



