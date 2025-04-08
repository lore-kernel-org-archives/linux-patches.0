Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34379268C5D;
	Tue,  8 Apr 2025 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111741; cv=none; b=ulqIWR0VJLcjABuU4Sp+JEUqryF6Zr7l7jJ8wEOD5F1/p4/DgHATIPbJfIPR/PlekHjSU3kJLnWrA+PFhZlzfZUF0rB5tiQtQNvVdx4FLrf3tTxR1EsApacPLbd7vdK8UO1fA7X5hxvScvAOnLa335hR5vIWH0hjYg8uO80OjVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111741; c=relaxed/simple;
	bh=SvvV0POcN/aBW8iCiM/w7QFQrct58pSKYrWD5sEuu3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGAOwkU05vRFWW5nA+srv06IPPYATC0cJMNpMLpI7MAtA/8RjZjBHUaWQrdusjj9NfYXH8hNx7NJm8M+kiANmeTWqUZYcPw3pxdxp5uXx/5xN7H1YAQNSOY3EjN3RLJbFK6+JE/mEYc16YOk7p3VZxr1gV20glXJieelDQltuxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seZ1vtJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seZ1vtJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C361C4CEE5;
	Tue,  8 Apr 2025 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111740;
	bh=SvvV0POcN/aBW8iCiM/w7QFQrct58pSKYrWD5sEuu3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seZ1vtJ4owe1z9/YLkTTYBmbkQo1i/0xKrinJFxPSMOMSJm45uYjhZlCnZI+RkCS2
	 /w25Hep2Y1g9kM30mXDzqSqajPo6TCX6d2zbY10HET7GmdqQfD69BTc1tDOidITQHe
	 uY2ESXvQ2Yv6tNsXkQnG3lDfTqX7/TmKqSeQWQg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Meissner <meissner@suse.de>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 541/731] perf tools: annotate asm_pure_loop.S
Date: Tue,  8 Apr 2025 12:47:18 +0200
Message-ID: <20250408104926.860268957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



