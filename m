Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73F1223C57;
	Thu, 12 Dec 2024 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025160; cv=none; b=NL6ivD9AqfIo33qNMugEqHTIX0yWhhGsNaiaE2L+qZN+Ve9BGdZq7OrXERWGQmEfWInLSav7boyxrYxTtSfZbHiwyv9nXVhrt5TxVLY5V8RyDOfWz57ZnwzvJginu2n6ZELHFOVkwVMcLwWYNmA6C8rBwZSCWBRnyHHP3Y9oPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025160; c=relaxed/simple;
	bh=rMM6ngU/iTJb4dvR45M0kpqUTB0ZUOQhAlFTjCkIUGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTLVVqMmiAg0fwKXqWTnwUJSdexMtFrfNyogK8SLbckJ6Jt0+tSG/rokmShlwsRLddz0+OHfcj2SINUghr6bZSLSk2b2+RTtMODssH0UNjPiWrAowBZZWukXx439unUrGprtdyjIH1w3dMQCU2ysjhwjf1Gxby/JVELpFpUjIEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoUezl8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoUezl8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35587C4CECE;
	Thu, 12 Dec 2024 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025160;
	bh=rMM6ngU/iTJb4dvR45M0kpqUTB0ZUOQhAlFTjCkIUGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoUezl8k8vOZ50TFiGatJllw6me9juk8ULXnA5Oms2MESOAqliQNFysXLzkpmAz2O
	 jNUSxrNkKwCXTEpsFyhlH7tlP5KdQHoWqfPwrBc9dzzuE+QL9jBjVq2kgcgTPFRG0P
	 rELYfxa4zRIrnAECOUpidE3ZCXS70/DcFTMnu8ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/321] time: Fix references to _msecs_to_jiffies() handling of values
Date: Thu, 12 Dec 2024 15:59:24 +0100
Message-ID: <20241212144231.810889279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1b6d31da7cbc3..c078f28bbc10b 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -350,7 +350,7 @@ static inline unsigned long _msecs_to_jiffies(const unsigned int m)
  * - all other values are converted to jiffies by either multiplying
  *   the input value by a factor or dividing it with a factor and
  *   handling any 32-bit overflows.
- *   for the details see __msecs_to_jiffies()
+ *   for the details see _msecs_to_jiffies()
  *
  * msecs_to_jiffies() checks for the passed in value being a constant
  * via __builtin_constant_p() allowing gcc to eliminate most of the
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 83f403e7a15c4..8660090669879 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -581,7 +581,7 @@ EXPORT_SYMBOL(ns_to_timespec64);
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



