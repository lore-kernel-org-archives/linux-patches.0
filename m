Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061981;
	b=e1g3AAyVJiMZ0Il+4A7yo1CIwSLnNZ91FTn8ylWReB3CK4MKUaAa7UIHxiudgG3ao+FZ
	 asgvsGBF3SFhdGUsKsLRTKuJPsRYz4pf+271usq1peIRZAlwBkGIYnylP4ZutxBUPJlQS
	 eRu2dMh8AkU08mFw/TZjDL3PXL3HL0a5H40ic2qeIijNL1IEm0+W8tplBn6mEktN6sP/e
	 kQOtrgS2dHenKrIjzA5z1c6QC85xNn7cS0WxABxrm2tZu43I/uf1IarWzkpShX4UU5sEX
	 QMgO7/Ttpcm8yNn6tNiAr6vG2ZMjlgzObCo5qCurAAgbWv/9iOQXLveTuR6h6HhxLYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhOs5gDK3wUAfZ4Pv0hy1tK2GU+xnzq8gwOEFGaa60E=;
	b=sLjn+TGM7vSGNuRoCC3GTGmY5PDoXR2b2bIjf3JDARyPeuFw2m9Mp50DvQ8z4+IjZrKB
	 r2EIL+edFjvorewSRIGLng/YJFibSqGY3eV4as2Xh5isCm7cyMLlcG65mab5MYxPBLnXL
	 4n4DB/Kb+KDrJ/3ie44QoEJ/gcX4VLsqmXGUodvPmWLLMszu0CKn0MLww3q/7YmI4vULB
	 8eM1IZCH1A5rGBdYT9DgfLhpYGEGW2uIr7Y4UY49KgI/Rrdliuz53iUdc16RBIuC6HbGx
	 uMf540sW0ruBYcxIX+uvHAe48yWF9GKD0ktkOMjbkRufPSKUniriGlcpM8WiVrnMpSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ofw2Q1rK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86C606A326;
	Thu, 19 Nov 2026 04:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ofw2Q1rK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934ED1F000C4;
	Thu, 19 Nov 2026 04:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061981;
	bh=JhOs5gDK3wUAfZ4Pv0hy1tK2GU+xnzq8gwOEFGaa60E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ofw2Q1rKBscncsA1dPxDT+6kBAjavkE3fDur4U9r7dEvZxgBdqR7GusIEYAG4br/j
	 pHlemQEAK/Dau37HXAQZelTPxrjUZMw8zkxW++UB7eNq8QJT9CSfFlmoDPC+3JiwIB
	 FPI/+/znWvjBzyP0ommRIRg4DUDDM3VC89SJvtVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1730/1848] rtc: class: Make the time32 hctosys limit configurable
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150032.003890338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit b253c2e96a80aac8e2bc67b425bf007ed78d4d8c ]

The RTC_HCTOSYS feature faces an impossible dilemma on 32-bit systems:

 a) systemd requires RTC_HCTOSYS=y with the correct timestamp
    for its intended operation

 b) broken RTC hardware can produce random future timestamps
    beyond 2038 at boot time

 c) time32 userspace immediately hangs if the time is set to a
    date beyond 2038 and requires timestamps to be clamped

 d) time64 userspace is intended to survive the actual 2038
    date and requires timestamps to not be clamped

Commit b3a5ac42ab18 ("rtc: hctosys: Ensure system time doesn't overflow
time_t") introduced this limit to protect time32 userspace from future
RTC dates that can break boot and address constraints a), b) and c),
but broke d) in the process by limiting RTC_HCTOSYS to the time32 range
and falling back to RTC_HCTOSYS=n behavior when the RTC time overflows
that.

Make the behavior configurable with a new RTC_HCTOSYS_TIME32_LIMIT
option that chooses between breaking c) or d). On systems with
COMPAT_32BIT_TIME=n, only RTC_HCTOSYS_TIME32_LIMIT=n is allowed since
userspace can be assumed to be fully built for time64. 64-bit kernels
running 32-bit userland never had the cutoff and continue to not offer
the option.

Warn on rejection with the RTC date and option name so users can
identify the cause and find the setting.

[arnd: reword Kconfig text and patch description,
       add COMPAT_32BIT_TIME dependency]
----
I ended up rewriting most of the text but kept Karl's ownership
as he did the original patch.

Fixes: b3a5ac42ab18 ("rtc: hctosys: Ensure system time doesn't overflow time_t")
Link: https://lore.kernel.org/all/20220908115337.1604277-1-arnd@kernel.org/
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20261020080026.2461578-1-arnd@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 21 +++++++++++++++++++++
 drivers/rtc/class.c |  8 +++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 6a4aa5abe366b..4e417548a29ef 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -40,6 +40,27 @@ config RTC_HCTOSYS
 	  the value read from a specified RTC device. This is useful to avoid
 	  unnecessary fsck runs at boot time, and to network better.
 
+config RTC_HCTOSYS_TIME32_LIMIT
+	bool "Reject RTC dates after the 2038 cutoff"
+	depends on RTC_HCTOSYS && COMPAT_32BIT_TIME && !64BIT
+	default y
+	help
+	  Reject RTC dates after 03:14:07 UTC on 19 January 2038 when
+	  initializing the system clock in order to work around broken
+	  RTC implementations that produce nondeterministic timestamps
+	  without a working backup battery.
+
+	  A rejected date leaves system time unchanged, normally near
+	  the Unix epoch, and the RTC's hctosys sysfs attribute reads
+	  0. Userspace must supply the time if no other source has
+	  initialized it.
+
+	  Say Y here if the kernel may have to run old time32 userspace on
+	  hardware that can produce unpredictable RTC timestamps.  If the
+	  kernel is intended to only run time64 compatible userspace and
+	  continue working past 2038, you must pick N here in order to
+	  have a working RTC_HCTOSYS functionality.
+
 config RTC_HCTOSYS_DEVICE
 	string "RTC used to set the system time"
 	depends on RTC_HCTOSYS
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 81aeb7a191b5f..db0ccaeabe05b 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -72,12 +72,14 @@ static void rtc_hctosys(struct rtc_device *rtc)
 
 	tv64.tv_sec = rtc_tm_to_time64(&tm);
 
-#if BITS_PER_LONG == 32
-	if (tv64.tv_sec > INT_MAX) {
+	if (IS_ENABLED(CONFIG_RTC_HCTOSYS_TIME32_LIMIT) &&
+	    tv64.tv_sec > INT_MAX) {
+		dev_warn(rtc->dev.parent,
+			 "hctosys: rejecting %ptR UTC due to CONFIG_RTC_HCTOSYS_TIME32_LIMIT=y\n",
+			 &tm);
 		err = -ERANGE;
 		goto err_read;
 	}
-#endif
 
 	err = do_settimeofday64(&tv64);
 
-- 
2.53.0



