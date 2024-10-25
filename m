Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4F1E378A;
	Fri, 25 Oct 2024 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729854130; cv=none; b=KyoVrmNEoN/P7A0a+rHG2eHazrTV+q1VCKUFEHp7UxxzMbWKgKD8K9EOrJs/nJ7EtdC5h9WTVPEecM6m9wj0cbM65TOXnAebbRBCenl00CbtJTMq2gKeoSb9QPBfemYv+kBlfO4lO8OAbedW97STdoxFEMyCI7hjwUiwcCuLZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729854130; c=relaxed/simple;
	bh=lzaqkcW22wXDJdpJCAvhK1JkYxWjhcuBl7/dsr2me2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hczfG2q0hYPrlFdIhGfH1qnRbX5AxophIIAT5KysXDnO11BHV4Gd7q2ZJDGYOh+kmxpib4A5hEEVV+txU+Fg+FYZF+Vfh5TIrkZmOeEi5tBnDVbVr4L5Lz/sxmY7DvMrAivaTQanVkOI+LvhakmnWznIPMY/yWNKJ1E7A2RlkSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERwwOYT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERwwOYT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3817BC4CEE7;
	Fri, 25 Oct 2024 11:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729854129;
	bh=lzaqkcW22wXDJdpJCAvhK1JkYxWjhcuBl7/dsr2me2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERwwOYT6CqR6fXts0pMWrDYMp9loPTxIoglOBdsRd1SQHUUKSynbk/fxowWb0/LVU
	 bvcdnyZLl1B/YldjiZeQpwm1rsxMFmaArfQ6Ymg44kj+6NrPOoT3VKstROUK0ms+TP
	 p2T2icuyUuuKKQWUnqxlznE+yvPKoOyw4OKhvG2D4ycosM8CCK249fjexByRAlYIk9
	 svG4nE6uyFSEmCr8ynACkGuT44+O3DR6g3U/ByDBqeeWV5mAlkJGq9gwA5t3DHVzPV
	 rhDMp6nW7BXLOjD8qm2HRZ9Y3dWFajJbWEIhRHJTk5v1ioH0j6QizrXgzfEyGel0T1
	 uyXIWumUB0zog==
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
Subject: [PATCH 2/2] time: fix references to _msecs_to_jiffies handling of values
Date: Fri, 25 Oct 2024 13:01:41 +0200
Message-ID: <20241025110141.157205-2-ojeda@kernel.org>
In-Reply-To: <20241025110141.157205-1-ojeda@kernel.org>
References: <20241025110141.157205-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The details about the handling of the "normal" values were moved
to the `_msecs_to_jiffies` helpers in commit ca42aaf0c861 ("time:
Refactor msecs_to_jiffies"). However, the same commit still mentioned
`__msecs_to_jiffies` in the added documentation.

Thus point to `_msecs_to_jiffies` instead.

Fixes: ca42aaf0c861 ("time: Refactor msecs_to_jiffies")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/jiffies.h | 2 +-
 kernel/time/time.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1220f0fbe5bf..5d21dacd62bc 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -502,7 +502,7 @@ static inline unsigned long _msecs_to_jiffies(const unsigned int m)
  * - all other values are converted to jiffies by either multiplying
  *   the input value by a factor or dividing it with a factor and
  *   handling any 32-bit overflows.
- *   for the details see __msecs_to_jiffies()
+ *   for the details see _msecs_to_jiffies()
  *
  * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
diff --git a/kernel/time/time.c b/kernel/time/time.c
index e1879ca32103..1ad88e97b4eb 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -556,7 +556,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
  * - all other values are converted to jiffies by either multiplying
  *   the input value by a factor or dividing it with a factor and
  *   handling any 32-bit overflows.
- *   for the details see __msecs_to_jiffies()
+ *   for the details see _msecs_to_jiffies()
  *
  * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
--
2.47.0
