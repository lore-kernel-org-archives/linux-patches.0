Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3247D1FBF56;
	Fri, 25 Oct 2024 11:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729854127; cv=none; b=sGn019SwhAjMrMXlukcg2xMjx1BqNVxgVxAQRUSZnU1gjYikHZOdkHfCerhVOqoRPBtk7eQTYN56BBPo+pWSOVmJsv/VSSYVhyy5fsAaWc27dS0f14/GFws+zi8xW/n/frBhnhHOGUD12uN1OhU3xS38M8RV/baYy/S1+NPmNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729854127; c=relaxed/simple;
	bh=ifAcyvypJDtlQncfdXN1N28xOgSvyoF3DwR5ovbT8m4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ibm7/zkutPxmDiW+ataoXR5vvBoeQTD1ueXuLKzRD6jIR5WSf4PsPlVxOh9B7e+uJ462vGBVRreUrA3cDrJNTAolrA2AoBkAqpOcPu3iaTky88KtQi5+j6lowV/WAlBramBX02gr9/Dks4e067a1/IZtcmqPjAblVfEzl4AqKbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRHeK0Fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRHeK0Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056E7C4CECD;
	Fri, 25 Oct 2024 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729854126;
	bh=ifAcyvypJDtlQncfdXN1N28xOgSvyoF3DwR5ovbT8m4=;
	h=From:To:Cc:Subject:Date:From;
	b=pRHeK0FxmsUycLEdiG+Rt5J8RXfkDNhWggHzxOQinJeiMMpL94wx9n4ypoxvShgJn
	 jw4Sl3TBg/XoymFBtow9c3zlhmopy5cbnQmGdnAMc/pAC6KAMZ6jdEGrEZgcdEhEPA
	 +ytHnlzSQpaV/c/ZIn8Arh2AG7s1AXr2KMcZkS8u8zo1HTwQz4k0/NMiEiq4zyltzK
	 Xgjf2FbhTDay9TRSJjZMX38l5Cj6aUypuQHBy0AddALH2wtW+2OUnY4TLlkzTHVniu
	 ffnCxkXuJHv0G64xNja/77OBfEg4c7pwtkUq+yjE4kl95PR3lNSivN/RA7N/nUKHgt
	 nXBWRwMjxmdPg==
From: Miguel Ojeda <ojeda@kernel.org>
To: John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Ingo Molnar <mingo@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 1/2] time: revert cleanup on msecs_to_jiffies() documentation
Date: Fri, 25 Oct 2024 13:01:40 +0200
Message-ID: <20241025110141.157205-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The documentation's intention is to compare `msecs_to_jiffies` (first
sentence) with `__msecs_to_jiffies` (second sentence), which is what the
original documentation did. One of the cleanups in commit f3cb80804b82
("time: Fix various kernel-doc problems") may have thought the paragraph
was talking about the latter since that is what it is being documented.

Thus revert that part of the change.

Fixes: f3cb80804b82 ("time: Fix various kernel-doc problems")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 642647f5046b..e1879ca32103 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
  *   handling any 32-bit overflows.
  *   for the details see __msecs_to_jiffies()
  *
- * __msecs_to_jiffies() checks for the passed in value being a constant
+ * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
  * code, __msecs_to_jiffies() is called if the value passed does not
  * allow constant folding and the actual conversion must be done at

base-commit: 42f7652d3eb527d03665b09edac47f85fb600924
-- 
2.47.0

