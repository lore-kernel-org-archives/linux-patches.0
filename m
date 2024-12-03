Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF61DA4E;
	Tue,  3 Dec 2024 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238014; cv=none; b=bcoCPZTe9I9WHXKPzvZYAfIH3yhfVnY8miiP1226/1pGeLr+1L2X/uxDQYtXvqGJz5331pLVn7Mo6hY/c6mzkpqz384G7dusMRGEa6Q91Puzj72JDPvIukw1HMcWYHlQHaP2f+dPReJBGDMpNYsRdageTo8kOFKMD93hXt/DhoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238014; c=relaxed/simple;
	bh=nDlws/fnM9g1fNJpoFejq0VL5xbpuejMAbXf3l9+m5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIN3vN6MV8l5zkrMDvMiasJz0qCONXQsPa4NEZMBy0Che+ynIShJ/g+zgHDMezrplZKGMFFoJrNu81eer9jR9X15nIucNiL2RgSr8NMZzDxc1muwHmlXC1978KGTJmDgZ3CSciEJ3fC0vj9y3bMeEKVQxqTJeW9WBbr9v5OOFWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL07AxzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL07AxzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB38C4CECF;
	Tue,  3 Dec 2024 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238014;
	bh=nDlws/fnM9g1fNJpoFejq0VL5xbpuejMAbXf3l9+m5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL07AxzDXz0MaEca6iakaVu66oBlSnQgoon2SNYmNh+PJqebhKzjKuTFnsIVGxGGc
	 QotaG2eSwm5FYnwJnPFAimGeRncr4eIXbsbWSiI/xwjKawweL0j6KCMs+uBLBjJAvA
	 UHP778it0QdhSIF0aVko1m94pDbAdNH7z18LEBKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 133/817] time: Fix references to _msecs_to_jiffies() handling of values
Date: Tue,  3 Dec 2024 15:35:05 +0100
Message-ID: <20241203144000.913762315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 92b043fd995a63a57aae29ff85a39b6f30cd440c ]

The details about the handling of the "normal" values were moved
to the _msecs_to_jiffies() helpers in commit ca42aaf0c861 ("time:
Refactor msecs_to_jiffies"). However, the same commit still mentioned
__msecs_to_jiffies() in the added documentation.

Thus point to _msecs_to_jiffies() instead.

Fixes: ca42aaf0c861 ("time: Refactor msecs_to_jiffies")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241025110141.157205-2-ojeda@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jiffies.h | 2 +-
 kernel/time/time.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index d9f1435a5a13c..26c7c0a4c7f8c 100644
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
index e1879ca321033..1ad88e97b4ebc 100644
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
2.43.0



