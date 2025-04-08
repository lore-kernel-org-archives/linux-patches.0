Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C67026A0E0;
	Tue,  8 Apr 2025 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115806; cv=none; b=tRyukoSSqx/g4soBx39tE/PAB7YN/Qj1gODCyTN7O43OGj09hw+k5FYFCteNsKaXnyGG6BStec32ib+sCyx5AzlAUS5CFD9dHPU8Sx6+FJUurYbw/+9RtIOFL2HNgqsIdb8Ra+ypD+Mp/GU4j6QndJvRAcR0RLIkuWPyl+eY6QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115806; c=relaxed/simple;
	bh=Q8gPQEWcrtEeRtaoT964+0NwVj3IKdV9Z+s2v/rryYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmJ/sOUt7VuHi/AXPOzD+dUabY2+YCb+mRQqVtaOPdrY8Dxk6nPQbzYYXpx9FseQl6jbVZGGA5OD5aL4ssnQakfFpeeduojVLCDSU432qEOaGPWSr/hmnmzKzZfIelXg+0sCBzjR+wXUju8GuhMIopg7ch7rOZXNqowz3QtkkOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luy0Mj9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luy0Mj9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B70AC4CEE5;
	Tue,  8 Apr 2025 12:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115805;
	bh=Q8gPQEWcrtEeRtaoT964+0NwVj3IKdV9Z+s2v/rryYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luy0Mj9exwaec2wIcBiHDtlW3xH+LJFj8O0fssDQlaWqe7vCHPnum33Jv4fwcHh3J
	 ZohAcR9aOtuwqfBsAwX2YVxAVdVvY2Z/I5gLa9rJKh+rwC+eaUrkBcW4FSzKt0R1kp
	 6LBBhd5VXMqhkKsMOv0rI59h+RUn6jaXzpva/K6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Meissner <meissner@suse.de>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/204] perf tools: annotate asm_pure_loop.S
Date: Tue,  8 Apr 2025 12:50:40 +0200
Message-ID: <20250408104823.558079689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



