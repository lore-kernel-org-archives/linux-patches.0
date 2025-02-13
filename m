Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5D535961;
	Thu, 13 Feb 2025 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460032; cv=none; b=P531zwL9hCBl8WOzjcWXi4dDgftP6WRguHZdPRjBpb+rfjEt0rtR3cQnkWi9b0jliZ3hfsINN7mrpRSCZyAzMqgbnzZsQOcZdJplFPsaHfAH26ABAFbSKve0WR8O+6S4IdRhV9DpMtgxgz7W4weLQ32M8vYycQ5PtmR8YnVfe/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460032; c=relaxed/simple;
	bh=o4BR1UnZf6m2SJceqtQv6Xl10h9oZ+ArDifLwlmMkIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kns3Pk26yHs9JPwS4iIwvkHiPRTV/KHmNOMGqBEipcXzSxgPX+TC/6BmkHvCGVf1O2fRphVQL0YCOxRAUAihv7k6lbrRsNI4l2rsOKxAc5Fh9Fhjm6e2c5F30gMpBgznjMxfrEtMA/OFej3PVZy3DvXt6bTYzAUQb+7MhMyIDhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSi195gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSi195gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AA9C4CED1;
	Thu, 13 Feb 2025 15:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460032;
	bh=o4BR1UnZf6m2SJceqtQv6Xl10h9oZ+ArDifLwlmMkIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSi195gNp5efkG37X5CjEN1TqgtsErEodOzNvV8cy8pbWGV9F0Zf5cSIIXEA0TaKn
	 /a9V8ZzhHk1JDieAE7k8RNsRaEO0vSB+4TJzNSj7JQ4YfjKXJ/7Rlp+3AsJ/ru+T4l
	 JAU49CU3Zi2kXVP7sK7H0UrHMXg+GUbMRz9Fgbac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.13 437/443] x86/mm: Convert unreachable() to BUG()
Date: Thu, 13 Feb 2025 15:30:02 +0100
Message-ID: <20250213142457.480522628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 41a1e976623eb430f7b5a8619d3810b44e6235ad upstream.

Commit 2190966fbc14 ("x86: Convert unreachable() to BUG()") missed
one.

And after commit 06e24745985c ("objtool: Remove
annotate_{,un}reachable()") the invalid use of unreachable()
(rightfully) triggers warnings:

  vmlinux.o: warning: objtool: page_fault_oops() falls through to next function is_prefetch()

Fixes: 2190966fbc14 ("x86: Convert unreachable() to BUG()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241216093215.GD12338@noisy.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -678,7 +678,7 @@ page_fault_oops(struct pt_regs *regs, un
 			      ASM_CALL_ARG3,
 			      , [arg1] "r" (regs), [arg2] "r" (address), [arg3] "r" (&info));
 
-		unreachable();
+		BUG();
 	}
 #endif
 


