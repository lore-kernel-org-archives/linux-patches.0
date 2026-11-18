Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036836;
	b=e1u5OK4B1HfARa6WPRuiBlkLmVajDqGS3ef86aUZ3qdtMIwUcX7yYdYPGaIYt6H+0t2g
	 ow+/WQ83XunmAkhBjI3NCpbSeJNU9s3SZktfw8MpWiQ+LieaRvy5lBS2LSg1baa12Nm6/
	 jLHBBlN/jJghSUdPow3c7uyTq/ssVHr6B21vq5I1NOOWV8Ph/xaEDkYYpOkt5Fg2AagZy
	 7MH4JY/tFxyrGuEqzpSUAGPBfq10KTfJorz8WTAGKM8qnW+UMRY3nIMavh5Lly7l+TRD7
	 F75fNJDfdk6i8EUZvj6RMoWewT7iTLA6IgFKc5Faf4dJvOjOdhIC7CAxXNd9BSwrzUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cNA6eZ5bZdeUS/M9wgeHalXwjbmbG7kD/D01R/wnWgY=;
	b=ox8ulx7OZLCKi1q4TN7HpePmEodqFSOWqvSpCe4MyAq4ej0o7QYdIoTL4xeRFt8f6hkT
	 5qn3EABBQ9D5LS5xqH33JaHKQElWI9yWsrxCfJa058yS5sZWADmoe+1L6ux149itXXTbM
	 hbhytCM3ijzXz+GJGo51IfhGBw21DRqnvC37wM17smKKzaLpqtogLSkmGHC7dBhxh9ufI
	 ErshFK5mGw9JIKg1xJ7ha+Tlk6A24C9s7m1mo7v4gZfNqvfEDyCx7lvfz2oCt3cRd4y2Y
	 WHfyFXAh0UunVos6LWoGv9jicPvZtCCSQzpgU9tbYL6lN1Y9pCSIYynXApS22LyXBzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCJHs1AG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB05606A31C;
	Wed, 18 Nov 2026 21:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCJHs1AG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932901F000C4;
	Wed, 18 Nov 2026 21:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036836;
	bh=cNA6eZ5bZdeUS/M9wgeHalXwjbmbG7kD/D01R/wnWgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCJHs1AGjRAtFBWNkzm6cPwhuofNeHn+OCKGTVQNlLMRaUj+p/XtEMLrjDVOXS/EN
	 rHQvY0KP+mu58Q2sx1aYCNquO0X0sgoXHHP4mZZdvJH8mWFx5ud6LWIwKSHb79O+Y4
	 UHg8eawFwOmAKCdLqZJqJlLOsSwKV483Hb7xaVnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1160/3318] rtc: cmos: Disable ACPI RTC event before handling it
Date: Wed, 18 Nov 2026 15:29:42 +0100
Message-ID: <20261118150354.908880715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 3f67038df8b5cba07254d1cff60d73e988b49ab7 ]

Users of RTC_UIE_ON can stop receiving update interrupts when rtc-cmos
handles alarms through ACPI. In one 50-run test, 40 runs passed and 10
timed out after receiving between one and four of five expected events.

The ACPI ff_rt_clk counter stopped at 218, exactly matching the number
of events delivered to userspace, and reported:

    218     STS disabled     unmasked

rtc_handler() runs in the threaded ACPI SCI handler and calls
cmos_interrupt(), which schedules rtc->irqwork. The work can run before
rtc_handler() returns:

    ACPI SCI thread          rtc->irqwork

    cmos_interrupt()
      schedule_work()
                             __rtc_set_alarm()
                               rtc_wake_on()
    acpi_clear_event()
    acpi_disable_event()

The SCI thread then disables the event that the worker enabled for the
next alarm. That alarm sets its status while delivery remains disabled,
so no update interrupt reaches userspace.

Clear and disable the current ACPI RTC event before cmos_interrupt()
schedules the work. The worker can then enable the next event without
the handler undoing it. With this ordering, 150 runs delivered all 750
events without a stall.

Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261015173029.3091872-2-gourry@gourry.net
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e06f3b9cab2c8..ecda3e6cb026b 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -757,7 +757,9 @@ static u32 rtc_handler(void *context)
 	unsigned char rtc_intr;
 	unsigned long flags;
 
-
+	/* Quiesce this event before rtc->irqwork can arm the next one. */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	/*
 	 * Always update rtc irq when ACPI is used as RTC Alarm.
 	 * Or else, ACPI SCI is enabled during suspend/resume only,
@@ -780,8 +782,6 @@ static u32 rtc_handler(void *context)
 	}
 
 	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-- 
2.53.0



