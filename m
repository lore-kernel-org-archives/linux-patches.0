Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907F114A82;
	Thu, 12 Dec 2024 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018985; cv=none; b=D+Mb7a2UAp18X8lDfQ7UlEH9qTJvhZ1FkBDvu+kOkaUStaNzsEf5VYgYABic/QkaGPH6aYcDxwl5JwQeW+2bmzONsLKdrZ6bjGrmY0dVPurSIQLimehcq09jWcfQmXLauyxvSGY73BJ1D0uvAWKXZ4qamoDdxATi2AU9GkACB8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018985; c=relaxed/simple;
	bh=3MzrG07u8jGH1gec08UizDm/VhlL/D5QHulS79Hf2MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFtPUZL8l+8ypRMAxmBjvBzauCgaX/x5hRoFceVjX2o515I2I+a7QOI8mMP+CJb1cK++/iSY23G3OscJhLcduV7b5YFt99U88mUUIO4zUkudNcNHWk5mkAf5M+xAZtSlexGcDQ4YNUA1RyeQHEBcepdJ+NzvKJPzj4QpE9DUuUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1poXIIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1poXIIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AB0C4CED0;
	Thu, 12 Dec 2024 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018985;
	bh=3MzrG07u8jGH1gec08UizDm/VhlL/D5QHulS79Hf2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1poXIIt8S/HcYARU7oXU1fA7WEgt9gDS0dJ52sRozOYcQn6iPN+hF6c0uqX0WGjq
	 1TRavz12Fq08cM5YQ6dw3WQe0UuRYvLABiPZsGupvDxq5rlxnGiMG4y+C9P8IbbiEg
	 0gZwz3Cogs3MSeXWF46f8L3QQ1hBDKhAJfsi/thQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/772] time: Fix references to _msecs_to_jiffies() handling of values
Date: Thu, 12 Dec 2024 15:50:31 +0100
Message-ID: <20241212144353.499208895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5e13f801c9021..3778e26f7b14c 100644
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
index 526257b3727ca..a92c7f3277ad6 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -539,7 +539,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
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



