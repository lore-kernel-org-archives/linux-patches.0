Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B631F7548;
	Tue,  3 Dec 2024 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236496; cv=none; b=FJMhCkSKQo2BXyDLxnG+bBRZanSW/PiNYbQSLZw3Tj1vEV4BxojwMOEv6tNMXTzq+KO4Cq+x0zfOBuFV/uvNllI/xyjxf5xDRUjd+/YvbQDrxMvBanMFcSWBYQNgOBdGPheDzXowYEe58h4rzu2yz1TMZmI8Ev7BIcJK6ZMkez0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236496; c=relaxed/simple;
	bh=mbCtnilK72EPOtw+J5FOmQmy7k91Whe2hfd6oD2jBZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCseRwpO/2GeWjKgSKp4yxYga0r4PcH+L3hgkzBmdxsuQkXdLfr9EQm+Rb2OBByynMzmEYFMCLp+FAwKhJDprLiuiOabvdSGqc5vMjuB81nxO4JA1jq37XFYmQG3fcDc5ft5xJgdVmnDt4PsdZS5IUjWsvjIs3UcdgBqJh6qDXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy1pBSdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy1pBSdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152AAC4CECF;
	Tue,  3 Dec 2024 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236496;
	bh=mbCtnilK72EPOtw+J5FOmQmy7k91Whe2hfd6oD2jBZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy1pBSdheUMQiO7hnTnERwEiSXozn1LjSM1YGyOdGzqdSP31EdGgmNsDkaZ0W8y+r
	 klWDSXfeGYXKX3xqkR9xGTDWj3aU2GMYy/aIXgvhlYaMZu4oPVPee0kBR2m3exX7NA
	 9QIzSrbqxJ85KsZUm2cHk9nuSVMrvROxAi8Li8GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/138] time: Fix references to _msecs_to_jiffies() handling of values
Date: Tue,  3 Dec 2024 15:30:58 +0100
Message-ID: <20241203141924.667915131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index fa928242567db..add50d10f4102 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -349,7 +349,7 @@ static inline unsigned long _msecs_to_jiffies(const unsigned int m)
  * - all other values are converted to jiffies by either multiplying
  *   the input value by a factor or dividing it with a factor and
  *   handling any 32-bit overflows.
- *   for the details see __msecs_to_jiffies()
+ *   for the details see _msecs_to_jiffies()
  *
  * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
diff --git a/kernel/time/time.c b/kernel/time/time.c
index f7d4fa5ddb9e2..4087cf51142c0 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -576,7 +576,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
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



