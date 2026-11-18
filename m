Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045736;
	b=h6HdOTlQUmt1T0g2chJQVP0fZ0SPxYP5bcpABCpQYIOTFWX7zDexNa+snprjI9k3xUx6
	 vm1uUdj3RFe2GALJpUJjoPdvcNz9geFKUSMsjba88SRcYQS+mexNyNn9DRrspri3owRuy
	 2+ZhUzI5Q5Vt6EFVWPnBGIWMClyLFMMy30GEB0shupg/dt42nTGjrrHR19WieH61I+XRt
	 KlSANyPqS2oBPddEPGt6guCWJldNDphjVZivtFkOglLJ9m21BFDTpwIqD6ZN8XkSrjbqL
	 0kZOTJIldCTWE3G2lI0PA3CwVrQ7B7oSFYkCLAzXTIEZK5+yVU24EPGSe/wYMkdZ6ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2A8p6V/lqbOr+f+q6ThFb0deu31fVDymZtWZeFOmVkg=;
	b=BcQqagXSGKm8JBqELKb4Nh6K7jwQCV3NcNiWZ6PsBOR1MkPrCPa3NO095q7VmlotuhpW
	 Qp1J9hZJ/5efhqk7pp7jiF6TAF6xKqwkHeSDuVyK2lGDItXDLin8QjtsDSHOW8QtIwKPm
	 cCOXou/p/uZ166GRG4r8Si82FMxNkWbkOhHYeQjWjTtCSPyOEk97PrQACc3ACtqqyRXqc
	 RaQJBwKPaSdmt/xVk/V59Cx6xjAjD31dgwTY/csRPjyzdRWeD8YqoP8PSqWFATtN+yHUe
	 sY1zYM9cqYFfadx1U/7uaVkDdu9PVhFYpwDmWpeLq8qTkwYcubqfrMhl/KA3j5tSbkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b662lDfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9EC606A320;
	Wed, 18 Nov 2026 23:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b662lDfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753BA1F000C4;
	Wed, 18 Nov 2026 23:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045736;
	bh=2A8p6V/lqbOr+f+q6ThFb0deu31fVDymZtWZeFOmVkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b662lDfW3Yy7LpMMxSuAAg3TaTpJR+mO58+1GYxZEnZO4gVPdy1BU64yEOAAgydVK
	 0HHzKJMXTnlwau7biWfh1hdSsyVhlkjWm6lnGRSzbs22SY1jsiy4H48iCBDQ+naYnA
	 mXheJ86lkd0FiU0iyLDz6ydXAkMYjY03Pf0WiqEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0989/2857] rtc: cmos: Disable ACPI RTC event before handling it
Date: Wed, 18 Nov 2026 15:33:43 +0100
Message-ID: <20261118150237.211654924@linuxfoundation.org>
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
index 47799baa32d76..8854e4027c9c5 100644
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



