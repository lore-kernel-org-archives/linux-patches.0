Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F73B1F892B;
	Tue,  3 Dec 2024 15:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240284; cv=none; b=JC94YM97iwFeBv0uCIH+XWjjC0Lfwy6LvfW3gxHV07iuROHFg40RLys2ywGFWisVM2GHCf9HREXcLp/zDLdrrjMRt3QFrBQrW4Tu6JgANu6ub41y52E0HeTye3C/luCVWa58+KD5yhIm22WGJyDvKeRDAX+ziIp1ypD4blHSsN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240284; c=relaxed/simple;
	bh=dHGVSgarK0bcnz2zaFyGsWgjZspUSY+5lu+GR78+BVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa+aJjPAPIJT7u8KAID6Zk5Q5UpodccB74BdSOkWUufXNl3bRY0hn1dPp+jtfi9uSD7usE3zTsT7O9HrCjlP8x1wcuuF+PMTLM/UvxSaHJZit/DK2K7rYSNovY2Vvbi5/GE4yaMaSsj9wL8bPtH7zUayJ7EVcB53GAcydBSiZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORrffSSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORrffSSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB009C4CED8;
	Tue,  3 Dec 2024 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240284;
	bh=dHGVSgarK0bcnz2zaFyGsWgjZspUSY+5lu+GR78+BVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORrffSSqN5GdNbtx70wutf0BEyQRLtXj4UnaX16kZaYOW1CxvE+t4im0zr3J4GEiB
	 DewJlcDlX/TCpQ5V8mPN1OlHDHTYOHJcjFJVzYj+/sfI1BC60BGMiRxQ2m7763pegk
	 r/MNNVb2oGGwToPg/pVWnq9ZvZYjfveBD78DRUXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/826] time: Partially revert cleanup on msecs_to_jiffies() documentation
Date: Tue,  3 Dec 2024 15:36:53 +0100
Message-ID: <20241203144747.083665596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit b05aefc1f5886c8aece650c9c1639c87b976191a ]

The documentation's intention is to compare msecs_to_jiffies() (first
sentence) with __msecs_to_jiffies() (second sentence), which is what the
original documentation did. One of the cleanups in commit f3cb80804b82
("time: Fix various kernel-doc problems") may have thought the paragraph
was talking about the latter since that is what it is being documented.

Thus revert that part of the change.

Fixes: f3cb80804b82 ("time: Fix various kernel-doc problems")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241025110141.157205-1-ojeda@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 642647f5046be..e1879ca321033 100644
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
-- 
2.43.0



