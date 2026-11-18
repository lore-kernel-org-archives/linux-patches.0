Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050247;
	b=02yQcZd2kHwOSZkHkaNXPaQ98lSGEwbUPeoWdPCzmuAsf6ZCzVPxTKrHOQTYyr5iMtwG
	 ntlk/0hEx3xZBu+BZexzrfCTj2p/FohyamBgRNJ4y0rp353b8lrFXkCba7jSKCR74w7xg
	 0O1qkP4UGjrPBRomWlIU3jLRQ1DoUgwd2QlKwP+bn/LCMP8I4mxAAZ+G5eVGMVnNgbZIo
	 GAJI1G28cH5BtswoLZsWpI3rq4L0pSVIc6koZQrzBYoS9+ki39vvCorsstLopFdruBLgc
	 VRAJH4a5qMFSqP1WdAXTtHWYLxFhL4HbXv7CJ3gRRSw6UJSYTNdNwBvoWubzkPpKpQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dMbDLG4EVRr6bTvsPt3Yqqa+d9umT0qoukB4fd2/42E=;
	b=ebIKjoPgi9FpDm3TtoYrfrw00smFqIjpwJxg4EhYgGy+Ak1ec2bLK67ZWzZFgT693Cx7
	 W6njxupkT6/SnOKofBDqQLSyUoT29/qIuRUzLh+2ZvBRZ3Nmo83/xG5fk9h8Oc7m32YRZ
	 4whqrKmfmzv3gVDThHept1SFPEBfEypv54kvVttU1P778a1k7eD+xECLaY/TPAnlAjDm/
	 F3RxBcmZMMkvkMHyChBrMqu8FSHLZxSp96abS1Dh4uVMSgJzAhUzRSvqJDEboeGsm3cZ/
	 0mDiAbuZ6TublLULlKynLW9h5ByqfL6yluisCLqvquurKz1zKKhnNwl2NJvReACtTQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIxiN69j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12576606A32A;
	Thu, 19 Nov 2026 01:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIxiN69j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA961F000C4;
	Thu, 19 Nov 2026 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050246;
	bh=dMbDLG4EVRr6bTvsPt3Yqqa+d9umT0qoukB4fd2/42E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIxiN69jQHX/a23Its3KDSmfI5NICjqziVnUwauHQGAgcefmsdC5zkl3TUfFm6JTc
	 +1DdD7fpsGUr9B7LBbpYHl6VRUoZem6ulpIbSvae4IeE/HZHO6FrdJuM27QSkcAVCV
	 alNabGSA38BndiudmCUvlYuEqExuUdcFxWiSZFBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2641/2857] rtc: class: Make the time32 hctosys limit configurable
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150336.682679232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 87dc050ca004c..95fc91fcd193d 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -30,6 +30,27 @@ config RTC_HCTOSYS
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
index adf2a3d475cad..1f34f5e26c25d 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -73,12 +73,14 @@ static void rtc_hctosys(struct rtc_device *rtc)
 
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



