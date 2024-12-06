Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7811442E8;
	Fri,  6 Dec 2024 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496935; cv=none; b=m2vW+D2w5R72cSuXphMuK0FvOsJBD5A+7aIjNd6OVRVZxXhdipxGfJw/tkCMSXBQGk/lH6/A7HgorMdmOeGSeeB6PPLWiXhWHlXewUQYYrKBg0b1HiUI1RjPPJaHNph9CdCS2LMNko6fh++iT8vCsKrNihNIuRt3Li4IuX5SgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496935; c=relaxed/simple;
	bh=Voo8w02BcmBp/dr3Z8aNDTl4E+R+Yj9a8x31I0EYjrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu7G0jzVTauqnKNfHYDGkvoiguzSyW8xFgKIoGutqW7yw6EA/lxJWTMRZ4eOzsnqfZtElczq8prtTBhunPa9TOKUl/6zr1Ao6ycS7rgH/FB6Vwk7Sv2Vn99o8ub937zPE8FfT+XZfXYxpRQpJ/97tDnbf0zZBJqEWDC2mFNXQ78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ1d6E77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ1d6E77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560DBC4CED1;
	Fri,  6 Dec 2024 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496934;
	bh=Voo8w02BcmBp/dr3Z8aNDTl4E+R+Yj9a8x31I0EYjrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJ1d6E77JmKojf8xPmrFaDqqcn8voUR6bvNovPCvmR7mSfdxz+W0ebkn86IHn/How
	 VfqgDVINzZqT6FX1U74WqhAmE6GYiqKWPK19oTsaKuGhIofQc0eDBLU0nxOf+idASk
	 TiFVoUuXq0a0y0zyJ2DnEY7f0E1yWbmowwH5IQpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/676] time: Fix references to _msecs_to_jiffies() handling of values
Date: Fri,  6 Dec 2024 15:28:46 +0100
Message-ID: <20241206143657.539084767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e0ae2a43e0ebd..03f38fe9b9a10 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -499,7 +499,7 @@ static inline unsigned long _msecs_to_jiffies(const unsigned int m)
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



